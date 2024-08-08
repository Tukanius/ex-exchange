import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/custom_animate.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class AnimatedTextField extends StatefulWidget {
  final String name;
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final TextInputType inputType;
  final TextInputAction? inputAction;
  final String? initialValue;
  final InputDecoration? decoration;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focus;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? nextFocusNode;
  final bool obscureText;
  final bool hasObscureControl;
  final bool autoFocus;
  final double? fontSize;
  final bool readOnly;
  final FontWeight fontWeight;
  final int? maxLines;
  final Function? onComplete;
  final String? Function(dynamic)? validator;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int? maxLenght;
  final bool showCounter;
  final Function(dynamic)? onChanged;
  final Color? fillColor;
  final Color? colortext;
  final Color? hintTextColor;
  final TextAlign? textAlign;
  final double? verticalPadding;
  final Color borderColor;
  final FloatingLabelBehavior? floatLabel;

  const AnimatedTextField({
    Key? key,
    required this.labelText,
    required this.name,
    this.hintText,
    this.obscureText = false,
    this.inputType = TextInputType.visiblePassword,
    this.textCapitalization = TextCapitalization.none,
    this.showCounter = true,
    this.hasObscureControl = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.fontWeight = FontWeight.w400,
    this.maxLines = 1,
    this.fontSize = 14,
    this.hintTextColor,
    this.colortext,
    this.onChanged,
    this.nextFocusNode,
    required this.focusNode,
    this.validator,
    this.nextFocus,
    this.errorText,
    this.maxLenght,
    this.textAlign,
    this.inputFormatters,
    this.focus,
    this.onComplete,
    this.initialValue,
    this.decoration,
    this.inputAction,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.verticalPadding,
    required this.borderColor,
    this.floatLabel,
  }) : super(key: key);

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  bool isFocused = false;
  bool isPasswordVisible = false;
  late Animation<double> alpha;
  late AnimationController controller;
  @override
  void initState() {
    isPasswordVisible = widget.hasObscureControl;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    final Animation<double> curve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    alpha = Tween(begin: 0.0, end: 1.0).animate(curve);

    controller.addListener(() {
      setState(() {});
    });
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: CustomPaint(
        painter: CustomAnimateBorder(alpha.value, widget.borderColor),
        child: FormBuilderTextField(
          buildCounter: widget.showCounter
              ? null
              : (context,
                      {int? currentLength, bool? isFocused, int? maxLength}) =>
                  null,
          controller: widget.controller,
          autofocus: widget.autoFocus,
          maxLines: widget.maxLines,
          keyboardType: widget.inputType,
          textInputAction: widget.inputAction,
          initialValue: widget.initialValue,
          obscureText:
              widget.hasObscureControl ? isPasswordVisible : widget.obscureText,
          readOnly: widget.readOnly,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLenght,
          onChanged: widget.onChanged,
          name: widget.name,
          focusNode: widget.focusNode,
          onEditingComplete: () {
            if (widget.nextFocusNode != null) {
              widget.nextFocusNode!.requestFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          onSubmitted: (value) {
            if (widget.onComplete is Function) {
              widget.onComplete!();
            }
          },
          textAlign:
              widget.textAlign != null ? widget.textAlign! : TextAlign.start,
          style: TextStyle(
            color: widget.colortext,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.hintTextColor ?? colortext,
              fontSize: 14,
            ),
            floatingLabelBehavior:
                widget.floatLabel ?? FloatingLabelBehavior.auto,
            labelText: widget.labelText,
            labelStyle: TextStyle(color: hintText),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.verticalPadding ?? 12,
            ),
            fillColor: widget.fillColor,
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
        ),
      ),
    );
  }
}
