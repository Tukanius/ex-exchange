import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wx_exchange_flutter/models/history_model.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class TradeHistoryButton extends StatefulWidget {
  final TradeHistory data;
  const TradeHistoryButton({
    super.key,
    required this.data,
  });

  @override
  State<TradeHistoryButton> createState() => _TradeHistoryButtonState();
}

class _TradeHistoryButtonState extends State<TradeHistoryButton> {
  late String createdDate = Utils.formatUTC8(widget.data.createdAt!);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.data.type == "TRANSFER"
                    ? SvgPicture.asset('assets/svg/transfer_history.svg')
                    : widget.data.tradeStatus == "SUCCESS"
                        ? SvgPicture.asset('assets/svg/trade_history_succ.svg')
                        : SvgPicture.asset('assets/svg/trade_history_pen.svg'),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' ${widget.data.toCurrency == 'MNT' ? '₮' : widget.data.toCurrency == "JPY" ? '¥' : '₮'} ${widget.data.toAmount}',
                      style: TextStyle(
                        color: dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      createdDate,
                      style: TextStyle(
                        color: gray,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.data.tradeStatus == "PENDING"
                ? Text(
                    'Хүлээгдэж буй',
                    style: TextStyle(
                      color: blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : widget.data.tradeStatus == "SUCCESS"
                    ? Text(
                        'Амжилттай',
                        style: TextStyle(
                          color: success,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        'Цуцалсан',
                        style: TextStyle(
                          color: cancel,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
