import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController{
  
  // 「flutter_local_notifications」にあるローカル通知を扱うためのクラスをインスタンス化 
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // 初期設定
  Future<void> initNotification() async{

    // プラットフォームごとの初期設定をまとめる(今回はAndroidのみ)
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('test_icon')
    );

    // 通知設定を初期化(先程の設定＋通知をタップしたときの処理)
    await notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // 通知を表示する
  Future<void> showNotification(String body) async{
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId', 
        'channelName',
        importance: Importance.max
      )
    );

    notificationsPlugin.show(
      0,
      "アラーム時刻",
      body,
      notificationDetails,
    );
  }
}