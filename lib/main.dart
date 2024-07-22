import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/splash_page/splash_page.dart';

void main() async {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return MaterialApp(
            // builder: (context, widget) => Navigator(
            //   onGenerateRoute: (settings) => MaterialPageRoute(
            //     builder: (context) =>
            //         DialogManager(child: loading(context, widget)),
            //   ),
            // ),
            title: 'Green Score',
            theme: ThemeData(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case SplashScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const SplashScreen();
                  });

                // case CollectScooterScore.routeName:
                //   CollectScooterScoreArguments arguments =
                //       settings.arguments as CollectScooterScoreArguments;
                //   return MaterialPageRoute(builder: (context) {
                //     return CollectScooterScore(
                //       id: arguments.id,
                //     );
                //   });
                default:
                  return MaterialPageRoute(
                    builder: (_) => const SplashScreen(),
                  );
              }
            },
          );
        },
      ),
    );
  }
}

Widget loading(BuildContext context, widget) {
  bool shouldPop = false;

  return PopScope(
    canPop: shouldPop,
    child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Container(
        color: Colors.blue,
        child: SafeArea(
          bottom: false,
          top: false,
          child: Stack(
            children: [
              Opacity(
                opacity: 1,
                child: Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      widget,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
