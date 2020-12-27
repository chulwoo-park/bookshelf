import 'package:bookshelf/common/exception/exceptions.dart';
import 'package:bookshelf/common/model/state.dart';
import 'package:bookshelf/di/service_locator.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/presentation/bloc.dart';
import 'package:bookshelf/feature/book/presentation/event.dart';
import 'package:bookshelf/feature/note/presentation/bloc.dart';
import 'package:bookshelf/ui/common/widget/cached_network_image.dart';
import 'package:bookshelf/ui/common/widget/error.dart';
import 'package:bookshelf/ui/common/widget/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/link.dart';

import '../resources.dart';
import 'note_list.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen(this.data, {Key key}) : super(key: key);

  final Book data;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  BookDetailBloc get _bloc {
    if (mounted) {
      return BlocProvider.of<BookDetailBloc>(context);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _bloc?.add(BookDetailRequested(widget.data.isbn13));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(widget.data.title),
          ),
          BlocBuilder<BookDetailBloc, AsyncState>(
            builder: (context, state) {
              if (state is Initial) {
              } else if (state is Loading) {
                return _buildLoadingIndicator();
              } else if (state is Failure) {
                return _buildErrorMessage(state.error);
              } else if (state is Success<BookDetail>) {
                final detail = state.data;
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Image(
                          image: CachedNetworkImage(detail.image),
                          fit: BoxFit.cover,
                        ),
                        Text(
                          detail.title,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (detail.subtitle != null &&
                            detail.subtitle.isNotEmpty) ...[
                          SizedBox(height: 6.0),
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                              detail.subtitle,
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 15.0),
                        Text(R.strings.authors(detail.authors)),
                        SizedBox(height: 28.0),
                        Row(
                          children: [
                            StarRating(detail.rating),
                            Spacer(),
                            if (detail.isFree)
                              Text(
                                R.strings.free.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              )
                            else
                              Text(
                                '\$${detail.price}',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 28.0),
                        Text.rich(
                          TextSpan(
                            text: '${detail.description} ',
                            style: TextStyle(
                              height: 1.4,
                              fontSize: 16.0,
                            ),
                            children: [
                              WidgetSpan(
                                child: Link(
                                  uri: Uri.parse(detail.url),
                                  builder: (context, followLink) => InkWell(
                                    onTap: followLink,
                                    child: Text(
                                      R.strings.more.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 60.0),
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(0.5),
                            1: FlexColumnWidth(),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            _TableRow(
                              label: R.strings.labelPublished,
                              child: Text('${detail.year}'),
                            ),
                            _TableSpacer(),
                            _TableRow(
                              label: R.strings.labelPublisher,
                              child: Text(detail.publisher),
                            ),
                            _TableSpacer(),
                            _TableRow(
                              label: R.strings.labelYear,
                              child: Text('${detail.year}'),
                            ),
                            _TableSpacer(),
                            _TableRow(
                              label: R.strings.labelIsbn,
                              child: Row(
                                children: [
                                  Text(detail.isbn10),
                                  SizedBox(width: 6.0),
                                  Text(detail.isbn13),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (detail.pdfs.isNotEmpty) ...[
                          SizedBox(height: 12.0),
                          Text(
                            R.strings.labelPdf,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          for (var pdf in detail.pdfs)
                            Row(
                              children: [
                                Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.0),
                                Link(
                                  uri: Uri.parse(pdf.url),
                                  builder: (context, followLink) {
                                    return InkWell(
                                      onTap: followLink,
                                      child: Text(
                                        '${pdf.title}',
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              return SliverToBoxAdapter();
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 80.0),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        icon: Icon(
          Icons.article_rounded,
          color: Colors.white,
        ),
        label: Text(
          R.strings.notes,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[900],
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              final locator = ServiceLocator.of(context);
              return BlocProvider(
                create: (context) => NoteListBloc(
                  widget.data.isbn13,
                  locator.addNote,
                  locator.getNotes,
                ),
                child: NoteList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorMessage(dynamic error) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ErrorMessage(
        message: error is NetworkConnectivityException
            ? R.strings.checkNetworkMessage
            : R.strings.detailErrorMessage,
        onRetry: _refresh,
      ),
    );
  }
}

class _TableRow extends TableRow {
  _TableRow({
    @required String label,
    @required Widget child,
  }) : super(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child,
          ],
        );
}

class _TableSpacer extends TableRow {
  const _TableSpacer()
      : super(
          children: const [
            SizedBox(height: 12.0),
            SizedBox(height: 12.0),
          ],
        );
}
