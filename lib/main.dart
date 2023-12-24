import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shake/shake.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidAlarmManager.initialize(); //初期化

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

Future<void> displayTime() async {
  // アラームを鳴らす
  FlutterRingtonePlayer.playAlarm();

  // 5回振ったことを検知
  Completer<void> completer = Completer<void>();

  int shakeCount = 0;

  ShakeDetector detector = ShakeDetector.waitForStart(
    onPhoneShake: () {
      shakeCount++;
      print('振動検知: $shakeCount 回');
      if (shakeCount == 5) {
        completer.complete();
      }
    },
  );

  detector.startListening();

  await completer.future;

  // 5回振られた後の処理をここに追加
  FlutterRingtonePlayer.stop();

  detector.stopListening();
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
                await AndroidAlarmManager.oneShotAt(
                  DateTime.now().add(Duration(seconds: 2)),//Duration(seconds: 5),
                  //scheduleTime,
                  0,
                  displayTime,
                  exact: true,
                  allowWhileIdle: true,
                );
              },
              child: const Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}