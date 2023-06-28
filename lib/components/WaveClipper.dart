//
// import 'package:flutter/material.dart';
// class CustomShapeBorder extends ContinuousRectangleBorder {
//
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection textDirection}) {
//     final double innerCircleRadius = 150.0;
//     final double controlPointDistance = innerCircleRadius / 2;
//
//     Path path = Path();
//     path.lineTo(0, rect.height);
//     path.quadraticBezierTo(
//         rect.width / 2 - controlPointDistance - 30,
//         rect.height + 15,
//         rect.width / 2 - innerCircleRadius / 2,
//         rect.height + 50);
//     path.cubicTo(
//         rect.width / 2 - innerCircleRadius / 2 + 20,
//         rect.height + innerCircleRadius - 40,
//         rect.width / 2 + innerCircleRadius / 2 - 20,
//         rect.height + innerCircleRadius - 40,
//         rect.width / 2 + innerCircleRadius / 2 - 5,
//         rect.height + 50);
//     path.quadraticBezierTo(
//         rect.width / 2 + controlPointDistance + 30,
//         rect.height + 15,
//         rect.width,
//         rect.height);
//     path.lineTo(rect.width, 0.0);
//     path.close();
//
//     return path;
//   }
// }
