import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ProfileDetailPageArguments {
  User data;
  ProfileDetailPageArguments({
    required this.data,
  });
}

class ProfileDetailPage extends StatefulWidget {
  final User data;
  static const routeName = "ProfileDetailPage";
  const ProfileDetailPage({super.key, required this.data});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  FocusNode phone = FocusNode();
  FocusNode firstname = FocusNode();
  FocusNode lastname = FocusNode();
  FocusNode register = FocusNode();
  FocusNode email = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Center(
              child: SvgPicture.asset('assets/svg/back_arrow.svg'),
            ),
          ),
        ),
        title: Text(
          'Миний мэдээлэл',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnimatedTextField(
              readOnly: true,
              borderColor: blue,
              colortext: blackAccent,
              name: 'lastName',
              focusNode: firstname,
              initialValue: "${widget.data.lastName}",
              labelText: 'Овог',
            ),
            SizedBox(
              height: 16,
            ),
            AnimatedTextField(
              initialValue: "${widget.data.firstName}",
              readOnly: true,
              borderColor: blue,
              colortext: blackAccent,
              name: 'firstName',
              focusNode: lastname,
              labelText: 'Нэр',
            ),
            SizedBox(
              height: 16,
            ),
            AnimatedTextField(
              initialValue: "${widget.data.phone}",
              readOnly: true,
              borderColor: blue,
              colortext: blackAccent,
              name: 'phone',
              focusNode: phone,
              labelText: 'Утасны дугаар',
            ),
            SizedBox(
              height: 16,
            ),
            AnimatedTextField(
              initialValue: "${widget.data.registerNo}",
              readOnly: true,
              borderColor: blue,
              colortext: blackAccent,
              name: 'registerNo',
              focusNode: register,
              labelText: 'Регистрийн дугаар',
            ),
            SizedBox(
              height: 16,
            ),
            AnimatedTextField(
              initialValue: "${widget.data.email}",
              readOnly: true,
              borderColor: blue,
              colortext: blackAccent,
              name: 'email',
              focusNode: email,
              labelText: 'И-мэйл',
            ),
            SizedBox(
              height: 16,
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(width: 1, color: borderColor),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.all(16),
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             Expanded(
            //               child: Text(
            //                 'Овог:',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: Text(
            //                 '${widget.data.lastName}',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(
            //           height: 8,
            //         ),
            //         Row(
            //           children: [
            //             Expanded(
            //               child: Text(
            //                 'Нэр:',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: Text(
            //                 '${widget.data.firstName}',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(
            //           height: 8,
            //         ),
            //         Row(
            //           children: [
            //             Expanded(
            //               child: Text(
            //                 'Утасны дугаар:',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: Text(
            //                 '${widget.data.phone}',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(
            //           height: 8,
            //         ),
            //         Row(
            //           children: [
            //             Expanded(
            //               child: Text(
            //                 'Регистрийн дугаар:',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: Text(
            //                 '${widget.data.registerNo}',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(
            //           height: 8,
            //         ),
            //         Row(
            //           children: [
            //             Expanded(
            //               child: Text(
            //                 'И-мэйл:',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               child: Text(
            //                 '${widget.data.email}',
            //                 style: TextStyle(
            //                   color: dark,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(
            //           height: 8,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
