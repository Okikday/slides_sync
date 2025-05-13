import 'package:flutter/widgets.dart';

class StarClipper extends CustomClipper<Path> {
  final StarBorder starBorder;

  StarClipper(this.starBorder);

  @override
  Path getClip(Size size) {
    return starBorder.getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
