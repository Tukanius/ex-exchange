import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/utils_textfield.dart';

class CustomAnimateBorder extends CustomPainter {
  final double animationPercent;

  final Color color;

  CustomAnimateBorder(this.animationPercent, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.strokeWidth = 2;
    paint.color = color;
    paint.style = PaintingStyle.stroke;

    var path = Path();
    path.moveTo(0, size.height / 2);

    path.lineTo(0, 8);
    path.quadraticBezierTo(0, 0, 8, 0);
    path.lineTo(size.width - 8, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 8);
    path.lineTo(size.width, size.height / 2);

    var path2 = Path();
    path2.moveTo(0, size.height / 2);

    path2.lineTo(0, size.height - 8);
    path2.quadraticBezierTo(0, size.height, 8, size.height);
    path2.lineTo(size.width - 8, size.height);
    path2.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 8);
    path2.lineTo(size.width, size.height / 2);

    final p1 = UtilsTextField.createAnimatedPath(path, animationPercent);
    final p2 = UtilsTextField.createAnimatedPath(path2, animationPercent);

    canvas.drawPath(p1, paint);
    canvas.drawPath(p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
