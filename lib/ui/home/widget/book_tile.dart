import 'package:bookshelf/feature/book/domain/model.dart';
import 'package:flutter/material.dart';

import '../../resources.dart';

class BookTile extends StatelessWidget {
  const BookTile(this.data);

  final Book data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    'ISBN - ${data.isbn13}',
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ),
              Spacer(),
              if (data.price == 0.0)
                Text(R.strings.free.toUpperCase())
              else
                Text('\$${data.price.toString()}'),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                height: 100.0,
                child: Image(
                  image: NetworkImage(data.image),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (data.subtitle.isNotEmpty) ...[
                      SizedBox(height: 6.0),
                      Opacity(
                        opacity: 0.6,
                        child: Text(
                          data.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 12.0),
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Center(
              child: Text(data.url),
            ),
          ),
        ],
      ),
    );
  }
}
