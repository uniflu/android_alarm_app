import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shake/shake.dart';
import 'dart:async';
import 'notificationController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidAlarmManager.initialize(); //初期化
  NotificationController().initNotification();

  final app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyApp(),
  );
  
  runApp(app);
}

DateTime scheduleTime = DateTime.now();

Future<void> shakeAlarm() async {
  // アラームを鳴らす
  FlutterRingtonePlayer.playAlarm();

  // 指定回数振ったら止める
  ShakeDetector.autoStart(

    // 5回振ってから、onPhoneShakeを呼び出す
    minimumShakeCount: 5,

    // 検知の強さの最低値を少し小さくする
    shakeThresholdGravity: 2,

    // 5回振った後にアラームを止める
    onPhoneShake: () {
      FlutterRingtonePlayer.stop();
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Android_Alarm_App'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onChanged: (date) => scheduleTime = date,
                  onConfirm: (date) {},
                );
              },
              child: const Text('Select Schedule Time'),
            ),

            ElevatedButton(
              onPressed: () async{
                // アラーム時刻を通知として表示
                NotificationController().showNotification(scheduleTime.toString());

                // アラームをセット
                await AndroidAlarmManager.oneShotAt(
                  // DateTime.now().add(Duration(seconds: 2)),
                  scheduleTime,
                  0,
                  shakeAlarm,
                  exact: true,
                  allowWhileIdle: true,
                  wakeup: true,
                );
              },
              child: const Text('Set Alarm'),
            ),

            // アラームをキャンセル
            ElevatedButton(
              onPressed: () async{
                await AndroidAlarmManager.cancel(0);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}