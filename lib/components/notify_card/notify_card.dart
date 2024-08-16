import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wx_exchange_flutter/models/notify.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class NotifyCard extends StatefulWidget {
  final Notify data;
  final Function() onClick;
  const NotifyCard({super.key, required this.data, required this.onClick});

  @override
  State<NotifyCard> createState() => _NotifyCardState();
}

class _NotifyCardState extends State<NotifyCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
          color: widget.data.isSeen == false ? borderColor : white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset('assets/svg/transfer_history.svg'),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.data.title}',
                          style: TextStyle(
                            color: dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${widget.data.data}',
                          style: TextStyle(
                            color: gray,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: dark,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
