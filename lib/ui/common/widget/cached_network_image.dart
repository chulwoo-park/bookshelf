import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> _getDirectorySize(Directory dir) async {
  int size = 0;
  await for (var entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File) {
      size += await entity.length();
    }
  }

  return size;
}

Future<void> _writeBytes(Map data) async {
  await data['cache'].writeAsBytes(data['bytes']);
}

Future<Uint8List> _readBytes(File cache) async {
  return await cache.readAsBytes();
}

/// It customized from [NetworkImage] for disk cache.
class CachedNetworkImage extends ImageProvider<NetworkImage>
    implements NetworkImage {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  CachedNetworkImage(
    this.url, {
    this.scale = 1.0,
    this.headers,
  })  : assert(url != null),
        assert(scale != null);

  final _DiskImageCache _cache = _DiskImageCache();

  @override
  final String url;

  @override
  final double scale;

  @override
  final Map<String, String> headers;

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<NetworkImage>(this);

  @override
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    final chunkEvents = StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<NetworkImage>('Image key', key),
        ];
      },
    );
  }

  static final HttpClient _sharedHttpClient = HttpClient()
    ..autoUncompress = false;

  static HttpClient get _httpClient {
    HttpClient client = _sharedHttpClient;
    assert(() {
      if (debugNetworkImageHttpClientProvider != null)
        client = debugNetworkImageHttpClientProvider();
      return true;
    }());
    return client;
  }

  String _cacheKey(CachedNetworkImage key) {
    final Uri resolved = Uri.base.resolve(key.url);
    return (resolved.pathSegments).join('_');
  }

  Future<ui.Codec> _loadAsync(
    CachedNetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async {
    if (await _cache.contains(_cacheKey(key))) {
      return _loadAsyncFromFile(key, chunkEvents, decode);
    } else {
      return _loadAsyncFromHttp(key, chunkEvents, decode);
    }
  }

  Future<ui.Codec> _loadAsyncFromFile(
    CachedNetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async {
    try {
      assert(key == this);

      final Uri resolved = Uri.base.resolve(key.url);

      final bytes = await _cache.get(_cacheKey(key));

      if (bytes.lengthInBytes == 0)
        throw Exception('NetworkImage is an empty file: $resolved');

      return decode(bytes);
    } catch (e) {
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  Future<ui.Codec> _loadAsyncFromHttp(
    CachedNetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async {
    try {
      assert(key == this);

      final Uri resolved = Uri.base.resolve(key.url);

      final HttpClientRequest request = await _httpClient.getUrl(resolved);

      headers?.forEach((String name, String value) {
        request.headers.add(name, value);
      });
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw NetworkImageLoadException(
            statusCode: response.statusCode, uri: resolved);
      }

      final Uint8List bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (int cumulative, int total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: cumulative,
            expectedTotalBytes: total,
          ));
        },
      );
      if (bytes.lengthInBytes == 0)
        throw Exception('NetworkImage is an empty file: $resolved');

      await _cache.put(_cacheKey(key), bytes);
      return decode(bytes);
    } catch (e) {
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is CachedNetworkImage &&
        other.url == url &&
        other.scale == scale;
  }

  @override
  int get hashCode => ui.hashValues(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NetworkImage')}("$url", scale: $scale)';
}

class _DiskImageCache {
  static const _capacity = 100 * 1024 * 1024;
  static const _metadataKey = 'cache_metadata';

  static Map<String, _CacheMetadata> _metadata;
  static Completer _initializeCompleter;
  static Directory _cacheDir;

  Future<void> _initIfNeeded() async {
    if (_initializeCompleter == null) {
      _initializeCompleter = Completer();
      _initialize(_initializeCompleter);
    }
    return _initializeCompleter.future;
  }

  void _initialize(Completer completer) async {
    final tempDir = await getTemporaryDirectory();
    _cacheDir = Directory(tempDir.path + '/cached_image');
    if (!(await _cacheDir.exists())) {
      _cacheDir.create();
    }
    await _readMetadata();
    completer.complete();
  }

  File _getCacheFile(String key) => File('${_cacheDir.path}/$key');

  Future<bool> contains(String key) async {
    await _initIfNeeded();
    final cache = _getCacheFile(key);
    return await cache.exists();
  }

  Future<Uint8List> get(String key) async {
    await _initIfNeeded();
    if (_metadata.containsKey(key)) {
      _metadata[key].copyWith(usedAt: DateTime.now());
    }
    final cache = _getCacheFile(key);
    if (await cache.exists()) {
      return compute(_readBytes, cache);
    } else {
      throw CacheMissException();
    }
  }

  // todo: width, height, scale and etc
  Future<void> put(String key, Uint8List bytes) async {
    try {
      await _initIfNeeded();
      if (await _getDirectorySize(_cacheDir) > _capacity) {
        final sortedMetadata = _metadata.values.toList()
          ..sort((m1, m2) => m2.usedAt.compareTo(m1.usedAt));
        sortedMetadata.removeLast();
        _metadata = Map.fromIterable(sortedMetadata, key: (e) => e.key);
      }

      final cache = _getCacheFile(key);
      if (!(await cache.exists())) {
        await cache.create();
      }
      compute(_writeBytes, {
        'cache': cache,
        'bytes': bytes,
      });
      _metadata[key] = _CacheMetadata(
        key,
        cache,
        DateTime.now(),
        DateTime.now(),
      );
      _writeMetadata();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _writeMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString(
        _metadataKey,
        await compute(
          jsonEncode,
          _metadata.values.map((e) {
            return <String, dynamic>{
              'key': e.key,
              'file': e.file.path,
              'createdAt': e.createdAt.millisecondsSinceEpoch,
              'usedAt': e.usedAt.millisecondsSinceEpoch,
            };
          }).toList(),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _readMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final jsonString = prefs.getString(_metadataKey);
      final json = await compute(jsonDecode, jsonString);
      _metadata = Map<String, _CacheMetadata>.fromIterable(
        (json as List).map((e) {
          return _CacheMetadata(
            e['key'],
            File(e['file']),
            DateTime.fromMillisecondsSinceEpoch(int.tryParse(e['createdAt'])),
            DateTime.fromMillisecondsSinceEpoch(int.tryParse(e['usedAt'])),
          );
        }),
        key: (e) => e.key,
      );
    } catch (e) {
      prefs.remove(_metadataKey);
      _metadata = {};
    }
  }
}

class _CacheMetadata {
  _CacheMetadata(
    this.key,
    this.file,
    this.createdAt,
    this.usedAt,
  );

  final String key;
  final File file;
  final DateTime createdAt;
  final DateTime usedAt;

  _CacheMetadata copyWith({
    File file,
    DateTime usedAt,
  }) {
    return _CacheMetadata(
      key,
      file ?? this.file,
      createdAt,
      usedAt ?? this.usedAt,
    );
  }
}
