import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating(this.data, {Key key}) : super(key: key);

  final double data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildStars(Icons.star_border),
        ClipRect(
          clipper: _CustomClipper(data / 5.0),
          child: _buildStars(Icons.star),
        ),
      ],
    );
  }

  Widget _buildStars(IconData icon) {
    return Row(
      children: [
        for (int i = 0; i < 5; i++) Icon(icon),
      ],
    );
  }
}

class _CustomClipper extends CustomClipper<Rect> {
  const _CustomClipper(this.factor);

  final double factor;

  @override
  Rect getClip(Size size) {
    return Offset.zero & Size(size.width * factor, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    if (identical(this, oldClipper) || oldClipper is! _CustomClipper) {
      return false;
    }
    return (oldClipper as _CustomClipper).factor != factor;
  }
}
