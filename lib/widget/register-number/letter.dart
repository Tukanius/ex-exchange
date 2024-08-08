import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class RegisterLetter extends StatefulWidget {
  final String? text;
  final Function()? onPressed;
  final double width;
  final double height;
  final Color? color;
  final Color textColor;
  final double fontSize;
  final Radius radius;

  const RegisterLetter({
    Key? key,
    this.text,
    this.onPressed,
    this.color,
    this.width = 50,
    this.height = 50,
    this.textColor = dark,
    this.radius = const Radius.circular(10.0),
    this.fontSize = 16,
  }) : super(key: key);

  @override
  _RegisterItemState createState() => _RegisterItemState();
}

class _RegisterItemState extends State<RegisterLetter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: widget.color ?? white,
          border: Border.all(
            color: black.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.all(widget.radius)),
      child: GestureDetector(
        onTap: widget.onPressed ?? () {},
        child: Container(
          color: transparent,
          child: Center(
            child: Text(
              widget.text ?? "A",
              style: TextStyle(color: black, fontSize: widget.fontSize),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
