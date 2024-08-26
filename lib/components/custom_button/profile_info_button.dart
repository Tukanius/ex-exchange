// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ProfileInfoButton extends StatefulWidget {
  final Function() onClick;
  final String text;
  final String svgPath;
  final bool? dan;
  final bool? danVerify;

  ProfileInfoButton({
    required this.onClick,
    Key? key,
    required this.text,
    required this.svgPath,
    this.dan = false,
    this.danVerify,
  }) : super(key: key);

  @override
  State<ProfileInfoButton> createState() => _ProfileInfoButtonState();
}

class _ProfileInfoButtonState extends State<ProfileInfoButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          color: white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  widget.svgPath,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${widget.text}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: dark,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (widget.dan == true && widget.danVerify == true)
                  SvgPicture.asset('assets/svg/secured.svg')
                else if (widget.danVerify == false)
                  SvgPicture.asset(
                    'assets/svg/secured.svg',
                    color: dark,
                  ),
                if (widget.danVerify == false) SizedBox(width: 16),
                if (widget.dan == false || widget.danVerify == false)
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: dark,
                    size: 14,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
