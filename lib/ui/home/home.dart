import 'dart:math';

import 'package:bookshelf/common/model/state.dart';
import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:bookshelf/feature/book/presentation/bloc.dart';
import 'package:bookshelf/feature/book/presentation/event.dart';
import 'package:bookshelf/feature/book/presentation/state.dart';
import 'package:bookshelf/ui/home/widget/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resources.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController;

  BookListBloc get _bloc {
    if (mounted) {
      return BlocProvider.of<BookListBloc>(context);
    } else {
      return null;
    }
  }

  bool get canRequestLoadMore {
    final currentState = _bloc?.state;
    return currentState is BookListLoaded &&
        currentState.loadMoreState == BookListLoadMoreState.idle;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: _AppBarDelegate(
                onQueryChanged: (query) {},
                onQuerySubmitted: (query) {
                  _bloc?.add(BookSearched(query));
                },
              ),
            ),
            BlocConsumer<BookListBloc, AsyncState>(
              listener: (context, state) {
                if (canRequestLoadMore) {
                  _loadNextPageIfTooShort(state);
                }
              },
              builder: (context, state) {
                if (state is Loading) {
                  return _buildLoadingIndicator();
                } else if (state is BookListLoaded) {
                  if (state.items.isEmpty) {
                    return _buildEmptyMessage();
                  } else {
                    return _SliverBookList(
                      books: state.items,
                      loadMoreState: state.loadMoreState,
                    );
                  }
                } else if (state is Failure) {
                  return _buildErrorMessage();
                }

                return SliverToBoxAdapter();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _loadNextPageIfTooShort(AsyncState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!canRequestLoadMore) return;

      final itemsTooShort = _scrollController.position.maxScrollExtent == 0;
      if (itemsTooShort) {
        _bloc?.add(NextPageRequested());
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification scroll) {
    if (!mounted || !canRequestLoadMore) return true;

    if (scroll.metrics.extentAfter < 500) {
      _bloc?.add(NextPageRequested());
    }
    return true;
  }

  Widget _buildLoadingIndicator() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          R.strings.searchEmptyMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          R.strings.searchErrorMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final titleSize = 45.0;

  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onQuerySubmitted;

  _AppBarDelegate({
    @required this.onQueryChanged,
    @required this.onQuerySubmitted,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final systemPadding = MediaQuery.of(context).padding;
    final theme = Theme.of(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: max(maxExtent - shrinkOffset, minExtent),
      child: Padding(
        padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ) +
            systemPadding,
        child: Stack(
          children: [
            Positioned(
              top: -shrinkOffset + 25.0,
              child: Text(
                R.strings.searchTitle,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned.fill(
              top: max(titleSize + 20.0 - shrinkOffset, 0.0),
              bottom: 10.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Icon(Icons.search),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: TextField(
                          onChanged: onQueryChanged,
                          onSubmitted: onQuerySubmitted,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: R.strings.searchHint,
                            hintMaxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 170.0;

  @override
  double get minExtent => 100.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _SliverBookList extends StatelessWidget {
  const _SliverBookList({
    Key key,
    this.books = const [],
    this.loadMoreState = BookListLoadMoreState.idle,
  }) : super(key: key);

  final List<Book> books;
  final BookListLoadMoreState loadMoreState;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= books.length) {
            return _buildLoadMoreItem();
          } else {
            return InkWell(
              onTap: () {},
              child: BookTile(books[index]),
            );
          }
        },
        childCount: books.length + 1,
      ),
    );
  }

  Widget _buildLoadMoreItem() {
    switch (loadMoreState) {
      case BookListLoadMoreState.loading:
        return Center(child: CircularProgressIndicator());
      case BookListLoadMoreState.failure:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(R.strings.searchErrorMessage),
            FlatButton(
              onPressed: () {},
              child: Text(R.strings.retry),
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }
}
