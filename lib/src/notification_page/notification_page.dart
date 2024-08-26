import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wx_exchange_flutter/api/user_api.dart';
import 'package:wx_exchange_flutter/components/controller/listen.dart';
import 'package:wx_exchange_flutter/components/notify_card/notify_card.dart';
import 'package:wx_exchange_flutter/components/refresher/refresher.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/src/history_page/exchange.dart';
import 'package:wx_exchange_flutter/src/history_page/transfer_detail.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = "NotificationPage";
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AfterLayoutMixin {
  ListenController listenController = ListenController();
  bool isLoading = true;
  int page = 1;
  int limit = 10;
  Result notifyList = Result(rows: [], count: 0);
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    listenController.addListener(() async {
      await list(page, limit);
      listenController.refreshList("refresh");
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  afterFirstLayout(BuildContext context) async {
    await list(page, limit);
  }

  list(page, limit) async {
    Offset offset = Offset(page: page, limit: limit);
    Filter filter = Filter();
    notifyList = await UserApi()
        .getNotification(ResultArguments(filter: filter, offset: offset));
    setState(() {
      isLoading = false;
    });
  }

  onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isLoading = true;
      limit = 10;
    });
    await list(page, limit);
    refreshController.refreshCompleted();
  }

  onLoading() async {
    setState(() {
      limit += 10;
    });
    await list(page, limit);
    refreshController.loadComplete();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
          'Мэдэгдэл',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: blue,
              ),
            )
          : Refresher(
              color: blue,
              refreshController: refreshController,
              onLoading: onLoading,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      notifyList.rows!.isNotEmpty
                          ? Column(
                              children: notifyList.rows!
                                  .map(
                                    (data) => NotifyCard(
                                      onClick: () async {
                                        var res =
                                            await UserApi().seenNot(data.id);
                                        print('===CLICKED===');
                                        print(res);
                                        print(data.data);
                                        print('===CLICKED===');
                                        if (data.type == "TRANSFER") {
                                          Navigator.of(context).pushNamed(
                                            TransferDetailPage.routeName,
                                            arguments:
                                                TransferDetailPageArguments(
                                              data: data.trade,
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).pushNamed(
                                            OrderDetailPage.routeName,
                                            arguments: OrderDetailPageArguments(
                                              data: data.trade,
                                            ),
                                          );
                                        }
                                        // Navigator.of(context).pushNamed(
                                        //   TransferDetailPage.routeName,
                                        //   arguments:
                                        //       TransferDetailPageArguments(
                                        //     data: data.trade,
                                        //   ),
                                        // );
                                      },
                                      data: data,
                                    ),
                                  )
                                  .toList(),
                            )
                          : Column(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svg/notfound.svg',
                                        // ignore: deprecated_member_use
                                        color: dark,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Мэдэгдэл хоосон байна.',
                                        style: TextStyle(
                                          color: dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 80,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      // Column(
                      //   children: [1, 2, 3, 4]
                      //       .map(
                      //         (e) => GestureDetector(
                      //           onTap: () {
                      //             // print('helo');
                      //             // NotifyService().showNotification(
                      //             //   title: 'batnaa',
                      //             //   body: 'batnaagaas irsn token',
                      //             // );
                      //             // Navigator.of(context).pushNamed(
                      //             //   MainPage.routeName,
                      //             //   arguments:
                      //             //       MainPageArguments(initialIndex: 1),
                      //             // );
                      //           },
                      //           child: Container(
                      //             margin: EdgeInsets.only(bottom: 8),
                      //             padding: EdgeInsets.all(12),
                      //             width: MediaQuery.of(context).size.width,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(16),
                      //               border: Border.all(
                      //                 color: borderColor,
                      //                 width: 1,
                      //               ),
                      //             ),
                      //             child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Expanded(
                      //                   child: Row(
                      //                     children: [
                      //                       SvgPicture.asset(
                      //                           'assets/svg/transfer_history.svg'),
                      //                       SizedBox(
                      //                         width: 12,
                      //                       ),
                      //                       Expanded(
                      //                         child: Column(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.start,
                      //                           children: [
                      //                             Text(
                      //                               'Мөнгөн гуйвуулга',
                      //                               style: TextStyle(
                      //                                 color: dark,
                      //                                 fontSize: 14,
                      //                                 fontWeight:
                      //                                     FontWeight.w500,
                      //                               ),
                      //                               overflow:
                      //                                   TextOverflow.ellipsis,
                      //                             ),
                      //                             SizedBox(
                      //                               height: 5,
                      //                             ),
                      //                             Text(
                      //                               'Гуйвуулгын төлөв амжилттай солигдлоо.',
                      //                               style: TextStyle(
                      //                                 color: gray,
                      //                                 fontSize: 12,
                      //                                 fontWeight:
                      //                                     FontWeight.w500,
                      //                               ),
                      //                               overflow:
                      //                                   TextOverflow.ellipsis,
                      //                               maxLines: 2,
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 Icon(
                      //                   Icons.arrow_forward_ios_rounded,
                      //                   color: dark,
                      //                   size: 16,
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //       .toList(),
                      // )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
