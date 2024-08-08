import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArrowBack extends StatefulWidget {
  const ArrowBack({super.key});

  @override
  State<ArrowBack> createState() => _ArrowBackState();
}

class _ArrowBackState extends State<ArrowBack> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset('assets/svg/back_arrow.svg'),
    );
  }
}
