// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wx_exchange_flutter/src/exchange_page/exchange_page.dart';
import 'package:wx_exchange_flutter/src/history_page/history_page.dart';
import 'package:wx_exchange_flutter/src/transfer_page/trans.dart';
// import 'package:wx_exchange_flutter/src/transfer_page/transfer_page.dart';
import 'package:wx_exchange_flutter/src/profile_page/profile_page.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MainPage extends StatefulWidget {
  static const routeName = "MainPage";
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  static const List<Widget> currentPages = [
    ExchangePage(),
    // MoneyOrder(),
    TransferPage(),
    HistoryPage(),
  ];
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  void ontappedItem(int index) {
    setState(() {
      selectedIndex = index;
      _scrollController.jumpTo(0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        child: KeyboardVisibilityProvider(
          child: Scaffold(
            backgroundColor: blue,
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxisScrolled) {
                return <Widget>[
                  SliverAppBar(
                    toolbarHeight: 60,
                    automaticallyImplyLeading: false,
                    pinned: false,
                    snap: true,
                    floating: true,
                    elevation: 0,
                    backgroundColor: blue,
                    centerTitle: false,
                    title: Row(
                      children: [
                        SizedBox(
                          width: 3,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child:
                                  SvgPicture.asset('assets/svg/wx_white.svg'),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Transfer & Exchange',
                              style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      SvgPicture.asset('assets/svg/notify.svg'),
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ProfilePage.routeName);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: greytext,
                          child: SvgPicture.asset('assets/svg/avatar.svg'),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(92),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: white, width: 1),
                          ),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  SvgPicture.asset('assets/svg/mn.svg'),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Төгрөг',
                                    style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(
                                'assets/svg/forward_arrow.svg',
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/svg/jp.svg'),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Иен',
                                    style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: Container(
                child: currentPages.elementAt(selectedIndex),
              ),
            ),
            extendBody: true,
            bottomNavigationBar: !_isKeyboardVisible
                ? BottomNavigationBar(
                    // selectedItemColor: blue,
                    unselectedItemColor: white,
                    elevation: 0,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    backgroundColor: white.withOpacity(0.8),
                    type: BottomNavigationBarType.fixed,
                    fixedColor: blue,
                    onTap: ontappedItem,
                    currentIndex: selectedIndex,
                    items: [
                      BottomNavigationBarItem(
                        icon: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedIndex == 0
                                ? blue.withOpacity(0.1)
                                : null,
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/transfer.svg',
                            color: selectedIndex == 0 ? blue : null,
                          ),
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedIndex == 1
                                ? blue.withOpacity(0.1)
                                : null,
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/export.svg',
                            color: selectedIndex == 1 ? blue : null,
                          ),
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedIndex == 2
                                ? blue.withOpacity(0.1)
                                : null,
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/history.svg',
                            color: selectedIndex == 2 ? blue : null,
                          ),
                        ),
                        label: '',
                      ),
                    ],
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
