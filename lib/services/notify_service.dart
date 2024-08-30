import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifyService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotify() async {
    AndroidInitializationSettings initializationAndroidSettings =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    var initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    var initializationSettings = InitializationSettings(
      android: initializationAndroidSettings,
      iOS: initSettingsIOS,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print('====heloo====');
      },
    );
  }

  notifyDetail() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, await notifyDetail());
  }
  // void registerShowNotificationListener(String title, String body) async {
  //   var androidInit =
  //       const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iOSinit = io(
  //       onDidReceiveLocalNotification:
  //           (int id, String title, String body, String payload) {});
  //   var initializationSettings =
  //       InitializationSettings(android: androidInit, iOS: iOSinit);
  //   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   _flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: (value) {});

  //   noficationCompleter = Completer();
  //   // showNotification = showDialogListener;

  //   var androidDetails = AndroidNotificationDetails(
  //       channel.id, channel.name, channel.description,
  //       importance: Importance.max, icon: "@mipmap/ic_launcher");
  //   var iOSDetails = const IOSNotificationDetails();
  //   var generalNotificationDetails =
  //       NotificationDetails(android: androidDetails, iOS: iOSDetails);

  //   await _flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     generalNotificationDetails,
  //   );
  // }
}
