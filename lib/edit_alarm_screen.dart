import 'package:android_alarm_app/alarm_datas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shake/shake.dart';
// import 'notificationController.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:shared_preferences/shared_preferences.dart';

DateTime scheduleTime = DateTime.now();
// TimeOfDay? selectedTime;

final selectedTimeProvider = StateProvider<TimeOfDay>(
  (ref) {
    return TimeOfDay(hour: 0, minute: 0);
  }
);

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

class EditAlarmScreen extends ConsumerWidget {
  const EditAlarmScreen({super.key});

  // selectedTime(TimeOfDay)⇒アラーム時刻(DateTime)に変換
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
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedTime = ref.watch(selectedTimeProvider);

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

                // 時刻選択
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context, 
                  initialTime: const TimeOfDay(hour: 0, minute: 0),                  
                );

                // 時刻を選択したかどうかで処理を分岐
                if(pickedTime != null){
                  final notifier = ref.read(selectedTimeProvider.notifier);
                  notifier.state = pickedTime;
                }
              },
              child: const Text('Select Schedule Time'),
            ),

            ElevatedButton(
              onPressed: () async{

                // スケジュール時刻
                final DateTime selectedDateTime = createNextDateTimeFromTime(selectedTime);

                // アラーム時刻を通知として表示
                // NotificationController().showNotification(selectedTime!.toString());

                // アラームを保存
                final notifier = ref.read(alarmDatasNotifierProvider.notifier);
                notifier.add(selectedTime, true);

                // アラームをセット
                await AndroidAlarmManager.oneShotAt(
                  selectedDateTime,
                  selectedTime.hour * 60 + selectedTime.minute,
                  shakeAlarm,
                  alarmClock: true,
                  wakeup: true,
                  rescheduleOnReboot: true,
                );

                // MainScreenに戻る
                Navigator.pop(context);
              },
              child: Text('Set Alarm at ${selectedTime.hour} : ${selectedTime.minute}'),
              
            ),

            // // アラームをキャンセル
            // ElevatedButton(
            //   onPressed: () async{
            //     await AndroidAlarmManager.cancel(0);
            //   },
            //   child: const Text('Cancel'),
            // ),
          ],
        ),
      ),
    );
  }
}