import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/firebase_options.dart';
import 'package:wx_exchange_flutter/provider/exchange_provider.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';
import 'package:wx_exchange_flutter/services/navigation.dart';
import 'package:wx_exchange_flutter/services/notify_service.dart';
import 'package:wx_exchange_flutter/src/auth/check-biometric.dart';
import 'package:wx_exchange_flutter/src/auth/foget_password_page.dart';
import 'package:wx_exchange_flutter/src/auth/login_page.dart';
import 'package:wx_exchange_flutter/src/auth/otp_page.dart';
import 'package:wx_exchange_flutter/src/auth/password_page.dart';
import 'package:wx_exchange_flutter/src/auth/register_page.dart';
import 'package:wx_exchange_flutter/src/exchange_page/exchange_order/order_info_page.dart';
import 'package:wx_exchange_flutter/src/exchange_page/exchange_order/payment_info_page.dart';
import 'package:wx_exchange_flutter/src/exchange_page/signature/signature_page.dart';
import 'package:wx_exchange_flutter/src/history_page/exchange.dart';
import 'package:wx_exchange_flutter/src/history_page/transfer_detail.dart';
import 'package:wx_exchange_flutter/src/main_page.dart';
import 'package:wx_exchange_flutter/src/notification_page/notification_page.dart';
import 'package:wx_exchange_flutter/src/profile_page/profile_detail_page.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/profile_delete.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/receiver_settings.dart';
import 'package:wx_exchange_flutter/src/transfer_page/remittance/remittance.dart';
import 'package:wx_exchange_flutter/src/profile_page/profile_page.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/address_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/email_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/password_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/phone_settings.dart';
import 'package:wx_exchange_flutter/src/splash_page/splash_page.dart';
import 'package:wx_exchange_flutter/widget/dialog/dialog_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotifyService().initNotify();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotifyService().showNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
  });

  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

GetIt locator = GetIt.instance;

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static int invalidTokenCount = 0;
  static setInvalidToken(int count) {
    invalidTokenCount = count;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => ExchangeProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return MaterialApp(
            builder: (context, widget) => Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) =>
                    DialogManager(child: loading(context, widget)),
              ),
            ),
            title: 'WX Exchange',
            theme: ThemeData(useMaterial3: false),
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.routeName,
            navigatorKey: locator<NavigationService>().navigatorKey,
            routes: {
              'NotificationPage': (context) => const NotificationPage(),
              'SplashScreen': (context) => const SplashScreen(),
            },
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case SplashScreen.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const SplashScreen();
                  });
                case LoginPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  });
                case RegisterPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const RegisterPage();
                  });
                case OtpPage.routeName:
                  OtpPageArguments arguments =
                      settings.arguments as OtpPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return OtpPage(
                      method: arguments.method,
                      username: arguments.username,
                    );
                  });
                case ForgetPasswordPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const ForgetPasswordPage();
                  });
                case PassWordPage.routeName:
                  PassWordPageArguments arguments =
                      settings.arguments as PassWordPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return PassWordPage(
                      method: arguments.method,
                    );
                  });
                case MainPage.routeName:
                  MainPageArguments arguments =
                      settings.arguments as MainPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return MainPage(
                      initialIndex: arguments.initialIndex,
                    );
                  });
                case SignaturePage.routeName:
                  SignaturePageArguments arguments =
                      settings.arguments as SignaturePageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return SignaturePage(
                      pushedFrom: arguments.pushedFrom,
                    );
                  });
                case OrderInfoPage.routeName:
                  OrderInfoPageArguments arguments =
                      settings.arguments as OrderInfoPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return OrderInfoPage(
                      signature: arguments.signature,
                    );
                  });

                case PaymentDetailPage.routeName:
                  PaymentDetailPageArguments arguments =
                      settings.arguments as PaymentDetailPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return PaymentDetailPage(
                      data: arguments.data,
                      type: arguments.type,
                    );
                  });
                case RemittancePage.routeName:
                  RemittancePageArguments arguments =
                      settings.arguments as RemittancePageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return RemittancePage(
                      signature: arguments.signature,
                    );
                  });
                case TransferDetailPage.routeName:
                  TransferDetailPageArguments arguments =
                      settings.arguments as TransferDetailPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return TransferDetailPage(
                      data: arguments.data,
                      listenController: arguments.listenController,
                      notifyData: arguments.notifyData,
                    );
                  });
                case OrderDetailPage.routeName:
                  OrderDetailPageArguments arguments =
                      settings.arguments as OrderDetailPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return OrderDetailPage(
                      data: arguments.data,
                      listenController: arguments.listenController,
                      notifyData: arguments.notifyData,
                    );
                  });
                case ProfilePage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const ProfilePage();
                  });
                case PhoneSettingsPage.routeName:
                  PhoneSettingsPageArguments arguments =
                      settings.arguments as PhoneSettingsPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return PhoneSettingsPage(
                      phone: arguments.phone,
                    );
                  });
                case EmailSettingsPage.routeName:
                  EmailSettingsPageArguments arguments =
                      settings.arguments as EmailSettingsPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return EmailSettingsPage(
                      email: arguments.email,
                    );
                  });
                case ReceiverSettingsPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const ReceiverSettingsPage();
                  });
                case AddressSettingsPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const AddressSettingsPage();
                  });
                case PasswordSettingsPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const PasswordSettingsPage();
                  });
                case CheckBiometric.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const CheckBiometric();
                  });
                case NotificationPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const NotificationPage();
                  });
                case ProfileDetailPage.routeName:
                  ProfileDetailPageArguments arguments =
                      settings.arguments as ProfileDetailPageArguments;
                  return MaterialPageRoute(builder: (context) {
                    return ProfileDetailPage(
                      data: arguments.data,
                    );
                  });
                case ProfileDeletePage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const ProfileDeletePage();
                  });
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
