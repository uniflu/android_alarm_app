import 'package:flutter/material.dart';
import 'package:android_alarm_app/alarm_datas.dart';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'time_of_day_converter.dart';
import 'shake_alarm.dart';

DateTime scheduleTime = DateTime.now();

final selectedTimeProvider = StateProvider<TimeOfDay>(
  (ref) {
    return const TimeOfDay(hour: 0, minute: 0);
  }
);

class EditAlarmScreen extends ConsumerWidget {
  const EditAlarmScreen({super.key});

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

                // // スケジュール時刻
                // final DateTime selectedDateTime = createNextDateTimeFromTime(selectedTime);

                // アラーム時刻を通知として表示
                // NotificationController().showNotification(selectedTime!.toString());

                // セーブデータに保存
                final notifier = ref.read(alarmDatasNotifierProvider.notifier);
                notifier.add(selectedTime, true);

                // アラームをセット
                ShakeAlarm.setAlarm(selectedTime);
                // await AndroidAlarmManager.oneShotAt(
                //   selectedDateTime,
                //   TimeOfDayConverter.toMinutes(selectedTime),
                //   shakeAlarm,
                //   alarmClock: true,
                //   wakeup: true,
                //   rescheduleOnReboot: true,
                // );

                // MainScreenに戻る
                Navigator.pop(context);
              },

              child: Text('Set Alarm at ${TimeOfDayConverter.toStringFromTimeOfDay(selectedTime)}'),
            ),
          ],
        ),
      ),
    );
  }
}