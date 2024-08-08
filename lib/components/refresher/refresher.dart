import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refresher extends StatefulWidget {
  final Widget child;
  final Color color;
  final Function()? onRefresh;
  final Function()? onLoading;
  final RefreshController refreshController;
  final Axis? direction;
  const Refresher({
    super.key,
    required this.refreshController,
    this.onLoading,
    this.onRefresh,
    required this.color,
    required this.child,
    this.direction,
  });

  @override
  State<Refresher> createState() => _RefresherState();
}

class _RefresherState extends State<Refresher> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: widget.onRefresh != null,
      enablePullUp: widget.onLoading != null,
      scrollDirection: widget.direction ?? Axis.vertical,
      controller: widget.refreshController,
      header: WaterDropHeader(
        complete: Text(''),
        waterDropColor: widget.color,
        refresh: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: widget.color,
          ),
        ),
      ),
      onRefresh: widget.onRefresh,
      onLoading: widget.onLoading,
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator(
              color: widget.color,
            );
          } else if (mode == LoadStatus.failed) {
            body = const Text("Алдаа гарлаа. Дахин үзнэ үү!");
          } else {
            body = const Text("");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      child: widget.child,
    );
  }
}
