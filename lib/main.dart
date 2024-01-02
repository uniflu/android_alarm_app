import 'package:flutter/material.dart';
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

TimeOfDay? selectedTime = TimeOfDay.now();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  DateTime createNextDateTimeFromTime(TimeOfDay selectedTime) {

    // 現在の時刻と比較対象の時刻をDateTime型に変換
    final DateTime now = DateTime.now();
    DateTime selectedDateTime = now.copyWith(
      hour: selectedTime.hour,
      minute: selectedTime.minute,
      second: 0
    );

    // selectedDateTimeが既に過ぎている場合は明日に設定
    if (selectedDateTime.isBefore(now)) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    } 
    
    return selectedDateTime;
  }

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
              onPressed: () async{
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context, 
                  initialTime: const TimeOfDay(hour: 0, minute: 0),                  
                );

                // 時刻を選択したかどうかで処理を分岐
                if(pickedTime != null){
                  print('selectedTime =  ${selectedTime}');
                  selectedTime = pickedTime;
                }
                else{
                  print('selectedTime = null');
                }
              },
              child: const Text('Select Schedule Time'),
            ),

            ElevatedButton(
              onPressed: (selectedTime == null) ? null :  () async{

                // スケジュール時刻
                final DateTime selectedDateTime = createNextDateTimeFromTime(selectedTime!);

                // アラーム時刻を通知として表示
                NotificationController().showNotification(selectedTime!.toString());

                // アラームをセット
                await AndroidAlarmManager.oneShotAt(
                  // DateTime.now().add(Duration(seconds: 2)),
                  selectedDateTime,
                  0,
                  shakeAlarm,
                  // exact: true,
                  // allowWhileIdle: true,
                  alarmClock: true,
                  wakeup: true,
                  rescheduleOnReboot: true,
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