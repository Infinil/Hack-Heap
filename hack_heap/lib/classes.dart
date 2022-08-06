import 'package:hack_heap/barrel.dart';
import 'package:hack_heap/hackathons.dart';

class HackathonDocument {
  HackathonDocument({
    this.participants,
    required this.date,
    required this.image,
    required this.mode,
    required this.name,
    required this.timeline,
    required this.url
  });
  
  final int date;
  final int? participants;
  final String image;
  final String mode;
  final String name;
  final String timeline;
  final String url;
}

class ForwardController {
  VoidCallback hackathonsReload = (){};

  static final _notifications = FlutterLocalNotificationsPlugin();
  BuildContext? context;
  String? notificationTitle;
  String? notificationDescription;
  String? notificationIcon;
  String? notificationPayload;

  static Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'description',
        priority: Priority.max,
        importance: Importance.max
      ),
      iOS: IOSNotificationDetails()
    );
  }

  Future<void> initializeSettings() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings(
      '@drawable/ic_stat_notifications_active'
    );
    const InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await _notifications.initialize(
      initializationSettings,
      onSelectNotification: selectNotification
    );
  }

  Future<void> selectNotification(payload) async {
    showWebView(context: context!, url: payload);
  }

  Future<void> showNotifications() async {
    _notifications.show(
      0, 
      notificationTitle, 
      notificationDescription, 
      await notificationDetails(),
      payload: notificationPayload
    );
  }
}