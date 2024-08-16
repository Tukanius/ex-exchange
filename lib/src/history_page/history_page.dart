// ignore_for_file: deprecated_member_use

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wx_exchange_flutter/api/exchange_api.dart';
import 'package:wx_exchange_flutter/components/history_button/history_button.dart';
import 'package:wx_exchange_flutter/components/refresher/refresher.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/src/history_page/exchange.dart';
import 'package:wx_exchange_flutter/src/history_page/transfer_detail.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = "HistoryPage";
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with AfterLayoutMixin {
  bool isLoading = true;
  int page = 1;
  int limit = 10;
  int currentIndex = 0;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  afterFirstLayout(BuildContext context) async {
    try {
      await listHistory(page, limit, '');
    } catch (e) {
      print(e.toString());
    }
  }

  listHistory(page, limit, query) async {
    Offset offset = Offset(page: page, limit: limit);
    Filter filter = Filter(tradeStatus: query);
    resultHistory = await ExchangeApi().getHistory(
      ResultArguments(filter: filter, offset: offset),
    );
    setState(() {
      isLoading = false;
    });
  }

  changeIndex(int index) async {
    setState(() {
      currentIndex = index;
      isLoading = true;
    });
    if (currentIndex == 0) await listHistory(page, limit, '');
    if (currentIndex == 1) await listHistory(page, limit, 'PENDING');
    if (currentIndex == 2) await listHistory(page, limit, 'SUCCESS');
    if (currentIndex == 3) await listHistory(page, limit, 'CANCELED');
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
    if (currentIndex == 0) await listHistory(page, limit, '');
    if (currentIndex == 1) await listHistory(page, limit, 'PENDING');
    if (currentIndex == 2) await listHistory(page, limit, 'SUCCESS');
    if (currentIndex == 3) await listHistory(page, limit, 'CANCELED');
    refreshController.refreshCompleted();
  }

  onLoading() async {
    setState(() {
      limit += 10;
    });
    if (currentIndex == 0) await listHistory(page, limit, '');
    if (currentIndex == 1) await listHistory(page, limit, 'PENDING');
    if (currentIndex == 2) await listHistory(page, limit, 'SUCCESS');
    if (currentIndex == 3) await listHistory(page, limit, 'CANCELED');
    refreshController.loadComplete();
  }

  Result resultHistory = Result();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/history.svg',
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'Гүйлгээний түүх',
                        style: TextStyle(
                          color: dark,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            changeIndex(0);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: currentIndex == 0
                                  ? blue.withOpacity(0.1)
                                  : white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              child: Text(
                                'Бүгд',
                                style: TextStyle(
                                  color: currentIndex == 0 ? blue : dark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            changeIndex(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: currentIndex == 1
                                  ? blue.withOpacity(0.1)
                                  : white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              child: Text(
                                'Хүлээгдэж байгаа',
                                style: TextStyle(
                                  color: currentIndex == 1 ? blue : dark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            changeIndex(2);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: currentIndex == 2
                                  ? blue.withOpacity(0.1)
                                  : white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              child: Text(
                                'Амжилттай',
                                style: TextStyle(
                                  color: currentIndex == 2 ? blue : dark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            changeIndex(3);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: currentIndex == 3
                                  ? blue.withOpacity(0.1)
                                  : white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              child: Text(
                                'Цуцалсан',
                                style: TextStyle(
                                  color: currentIndex == 3 ? blue : dark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Refresher(
                      refreshController: refreshController,
                      color: blue,
                      onLoading: onLoading,
                      onRefresh: onRefresh,
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: blue,
                              ),
                            )
                          : resultHistory.rows!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: resultHistory.rows!.length,
                                  itemBuilder: (context, index) {
                                    final data = resultHistory.rows![index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (data.type == "TRANSFER") {
                                          Navigator.of(context).pushNamed(
                                            TransferDetailPage.routeName,
                                            arguments:
                                                TransferDetailPageArguments(
                                                    data: data),
                                          );
                                        } else {
                                          Navigator.of(context).pushNamed(
                                            OrderDetailPage.routeName,
                                            arguments: OrderDetailPageArguments(
                                                data: data),
                                          );
                                        }
                                      },
                                      child: TradeHistoryButton(data: data),
                                    );
                                  },
                                )
                              : Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svg/notfound.svg',
                                        color: dark,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Түүх олдсонгүй.',
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
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
