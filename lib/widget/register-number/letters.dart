import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/utils/is_device_size.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class RegisterLetters extends StatefulWidget {
  final int? length;
  final Widget Function(BuildContext, int)? itemBuilder;
  final String? title;
  final double? height;
  final double? width;
  final int? listLength;
  final String? oneTitle;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final String? staticTitle;
  final Widget Function(BuildContext, int)? listItemBuilder;
  final MainAxisAlignment? mainAxisAlignment;
  final bool isNULL;
  final double? subHeight;
  final Color? textColor;
  final int? maxLines;
  final int? rightLines;
  final bool softWrap;
  final bool isStaticWidget;
  final Widget? staticWidget;
  final double? subWidth;
  final double? lineWidth;
  final double? rightWidth;
  final bool? hideOnPressed;
  final bool isDismissible;
  final bool isShowIcon;
  final Function()? onIconPressed;

  const RegisterLetters({
    Key? key,
    this.length,
    this.width,
    this.height,
    this.maxLines,
    this.softWrap = false,
    this.isNULL = false,
    this.staticWidget,
    this.itemBuilder,
    this.oneTitle,
    this.staticTitle,
    this.subHeight,
    this.padding,
    this.textColor,
    this.title,
    this.subWidth,
    this.backgroundColor,
    this.isStaticWidget = false,
    this.mainAxisAlignment,
    this.listItemBuilder,
    this.listLength,
    this.lineWidth,
    this.rightWidth,
    this.rightLines,
    this.isShowIcon = true,
    this.isDismissible = true,
    this.hideOnPressed = false,
    this.onIconPressed,
  }) : super(key: key);

  @override
  _RegisterLettersState createState() => _RegisterLettersState();
}

class _RegisterLettersState extends State<RegisterLetters> {
  void _onButtonPressed() {
    showModalBottomSheet(
      backgroundColor: white,
      isDismissible: widget.isDismissible,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: [
              Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                    ),
                    Center(
                        child: Text(
                      widget.oneTitle ?? "Title",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: dark, fontSize: 16),
                    )),
                    widget.isShowIcon
                        ? GestureDetector(
                            onTap: widget.onIconPressed ??
                                () {
                                  Navigator.pop(context);
                                },
                            child: Container(
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.close,
                                color: dark,
                                size: 24,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              widget.isStaticWidget
                  ? Expanded(
                      child: widget.staticWidget ?? const SizedBox.shrink(),
                    )
                  : Expanded(
                      child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: widget.length,
                      itemBuilder: widget.itemBuilder!,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                    )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.hideOnPressed! ? () {} : _onButtonPressed(),
      child: Container(
        height: widget.subHeight ?? 48,
        width: widget.subWidth ?? 48,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        )),
        child: Center(
          child: Container(
            width: widget.rightWidth ?? DeviceSize.width(5, context),
            child: Text(
              widget.title.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: widget.textColor ?? white,
              ),
              textAlign: TextAlign.center,
              softWrap: widget.softWrap,
              maxLines: widget.rightLines ?? 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

const CYRILLIC_ALPHABETS_RAW =
    '''["А","Б","В","Г","Д","Е","Ё","Ж","З","И","Й","К","Л","М","Н","О","Ө","П","Р","С","Т","У","Ү","Ф","Х","Ц","Ч","Ш","Щ","Ъ","Ь","Ы","Э","Ю","Я"]''';
const CYRILLIC_ALPHABETS_LIST = [
  "А",
  "Б",
  "В",
  "Г",
  "Д",
  "Е",
  "Ё",
  "Ж",
  "З",
  "И",
  "Й",
  "К",
  "Л",
  "М",
  "Н",
  "О",
  "Ө",
  "П",
  "Р",
  "С",
  "Т",
  "У",
  "Ү",
  "Ф",
  "Х",
  "Ц",
  "Ч",
  "Ш",
  "Щ",
  "Ъ",
  "Ь",
  "Ы",
  "Э",
  "Ю",
  "Я"
];
