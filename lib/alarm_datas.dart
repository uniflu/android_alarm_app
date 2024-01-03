import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';
import 'time_of_day_converter.dart';
part 'alarm_datas.g.dart';

@riverpod
class AlarmDatasNotifier extends _$AlarmDatasNotifier {

  // SplayTreeMap<TimeOfDay, bool>を作成
  SplayTreeMap<TimeOfDay, bool> _createSplayTreeMap(){
    return SplayTreeMap<TimeOfDay, bool>(
      (a, b) => TimeOfDayConverter.toMinutes(a) -TimeOfDayConverter.toMinutes(b)
    );
  }

  @override
  SplayTreeMap<TimeOfDay, bool> build() {
    return _createSplayTreeMap();
  }

  // セット
  void loadSaveData() async {

    // セーブデータを読み取り
    final prefs = await SharedPreferences.getInstance();

    // 返り値
    SplayTreeMap<TimeOfDay, bool> alarmDatas = _createSplayTreeMap();

    // セーブしていたデータを読み込み
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      int minuteTime = int.parse(key); 
      TimeOfDay timeOfDay = TimeOfDayConverter.toTimeOfDay(minuteTime);
      alarmDatas[timeOfDay] = prefs.getBool(key) ?? false;
    }

    // stateを更新
    state = alarmDatas;
  }

  // 上書き
  void update(TimeOfDay timeOfDay, bool value) async {

    // SharedPreferencesのインスタンス
    final prefs = await SharedPreferences.getInstance(); 

    // stateを更新
    var oldState = _createSplayTreeMap()..addAll(state); 
    oldState[timeOfDay] = value;
    state = oldState;

    // セーブデータを更新
    int minuteTime = TimeOfDayConverter.toMinutes(timeOfDay);
    prefs.setBool(minuteTime.toString(), value);
  }

  // 追加
  void add(TimeOfDay timeOfDay, bool value) async {

    // SharedPreferencesのインスタンス
    final prefs = await SharedPreferences.getInstance(); 

    // 新規データを追加
    var oldState = _createSplayTreeMap()..addAll(state); 
    oldState[timeOfDay] = value;
    state = oldState;

    // SharedPreferencesに追加
    int minuteTime = TimeOfDayConverter.toMinutes(timeOfDay);
    prefs.setBool(minuteTime.toString(), value);
  }

  // 削除
  void remove(TimeOfDay timeOfDay) async {

    // SharedPreferencesのインスタンス
    final prefs = await SharedPreferences.getInstance(); 

    // stateから消す
    var oldState = _createSplayTreeMap()..addAll(state); 
    oldState.remove(timeOfDay);
    state = oldState;

    // SharedPreferencesから削除
    int minuteTime = TimeOfDayConverter.toMinutes(timeOfDay);
    prefs.remove(minuteTime.toString());
  }
}
