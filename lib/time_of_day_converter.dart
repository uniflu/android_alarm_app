import 'package:flutter/material.dart';

class TimeOfDayConverter {
  static int toMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  static TimeOfDay toTimeOfDay(int minutes) {
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return TimeOfDay(hour: hours, minute: remainingMinutes);
  }

  static String toStringFromTimeOfDay(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')}";
  }
}
