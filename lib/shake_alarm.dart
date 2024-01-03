import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shake/shake.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'time_of_day_converter.dart';
// import 'notification_controller.dart';

// アラームを鳴らし、スマホが振ったら止める
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

// アラームの管理を行うクラス
class ShakeAlarm {

  // selectedTime(TimeOfDay)⇒アラーム時刻(DateTime)に変換
  static DateTime _createNextDateTimeFromTime(TimeOfDay selectedTime) {

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

  // アラームをセットする
  static void setAlarm(TimeOfDay selectedTime) async {
    
    // スケジュール時刻
    final DateTime selectedDateTime = _createNextDateTimeFromTime(selectedTime);
    final id = TimeOfDayConverter.toMinutes(selectedTime);
    
    // アラームをセット
    await AndroidAlarmManager.oneShotAt(
      selectedDateTime,
      id,
      shakeAlarm,
      alarmClock: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    print('set at ${selectedTime}');
  }

  // アラームを削除する
  static void cancelAlarm(TimeOfDay selectedTime) async {
    final id = TimeOfDayConverter.toMinutes(selectedTime);
    await AndroidAlarmManager.cancel(id);
  }
}
