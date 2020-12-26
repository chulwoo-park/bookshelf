import 'dart:math';

import 'package:flutter/material.dart';

import '../resources.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _AppBarDelegate(),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Row(
                      children: [
                        Text('Book'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final titleSize = 45.0;

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
