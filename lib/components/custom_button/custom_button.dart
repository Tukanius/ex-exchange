import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class CustomButton extends StatefulWidget {
  final String labelText;
  final Function() onClick;
  final bool? isLoading;
  final Color buttonColor;
  final Color? textColor;
  final double? height;
  final double? circular;
  CustomButton({
    this.textColor,
    this.isLoading,
    required this.onClick,
    this.labelText = '',
    required this.buttonColor,
    this.height,
    Key? key,
    this.circular,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height ?? 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.circular ?? 12),
          color: widget.buttonColor,
        ),
        child: ElevatedButton(
          onPressed: widget.isLoading == false ? widget.onClick : () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading == true)
                Container(
                  margin: EdgeInsets.only(
                    right: 15,
                  ),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: white,
                    strokeWidth: 2.5,
                  ),
                ),
              Text(
                widget.labelText.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: widget.textColor == null ? white : widget.textColor,
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.circular ?? 12),
            ),
            shadowColor: Colors.transparent,
            backgroundColor: widget.buttonColor,
          ),
        ),
      ),
    );
  }
}
