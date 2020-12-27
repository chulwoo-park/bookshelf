import 'package:flutter/material.dart';

import '../../resources.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    @required this.message,
    this.onRetry,
  }) : super(key: key);

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: 12.0),
            MaterialButton(
              child: Text(R.strings.retry),
              color: Colors.black.withOpacity(0.8),
              textColor: Colors.white,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
