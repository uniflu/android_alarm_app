import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';
part 'alarm_datas.g.dart';

@riverpod
class AlarmDatasNotifier extends _$AlarmDatasNotifier {

  // final SharedPreferences prefs = SharedPreferences.getInstance().then((v) => _prefs = v);
  // late final SharedPreferences _prefs;// = SharedPreferences.getInstance();
  // late final _prefsFuture = SharedPreferences.getInstance().then((v) => _prefs = v);

  @override
  SplayTreeMap<TimeOfDay, bool> build() {

    // SharedPreferencesのインスタンスを取得
    // SharedPreferences.getInstance().then((v) {
    //   _prefs = v;
    // });
    // // _prefs = await SharedPreferences.getInstance(); 
    
    // // 返り値
    // Map<TimeOfDay, bool> alarmDatas = Map<TimeOfDay, bool>();

    // // セーブしていたデータを読み込み
    // Set<String> keys = _prefs.getKeys();
    // for (String key in keys) {
    //   int minuteTime = int.parse(key); 
    //   TimeOfDay timeOfDay = TimeOfDay(hour: minuteTime ~/ 60, minute: minuteTime % 60);
    //   alarmDatas[timeOfDay] = _prefs.getBool(key) ?? false;
    // }
    
    return SplayTreeMap<TimeOfDay, bool>(
      (a, b) {
        final aMinutes = a.hour * 60 + a.minute;
        final bMinutes = b.hour * 60 + b.minute;
        return aMinutes.compareTo(bMinutes);
      }
    ); //Map<TimeOfDay, bool>();
  }




  // セット
  void loadSaveData() async {

    // セーブデータを読み取り
    final prefs = await SharedPreferences.getInstance();

    // 返り値
    SplayTreeMap<TimeOfDay, bool> alarmDatas = SplayTreeMap<TimeOfDay, bool>(
      (a, b) {
        final aMinutes = a.hour * 60 + a.minute;
        final bMinutes = b.hour * 60 + b.minute;
        return aMinutes.compareTo(bMinutes);
      }
    ); //Map<TimeOfDay, bool>();

    // セーブしていたデータを読み込み
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      int minuteTime = int.parse(key); 
      TimeOfDay timeOfDay = TimeOfDay(hour: minuteTime ~/ 60, minute: minuteTime % 60);
      alarmDatas[timeOfDay] = prefs.getBool(key) ?? false;
    }
  }

  // 上書き
  void update(TimeOfDay timeOfDay, bool value) async {

    // SharedPreferencesのインスタンス
    final prefs = await SharedPreferences.getInstance(); 

    // 更新
    // コピーをとる
    var oldState = SplayTreeMap<TimeOfDay, bool>(
      (a, b) {
        return (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute);
      }
    )..addAll(state); 
    oldState[timeOfDay] = value;
    state = oldState;

    // セーブデータを更新
    int minuteTime = timeOfDay.hour * 60 + timeOfDay.minute;
    prefs.setBool(minuteTime.toString(), value);
  }

  // 追加
  void add(TimeOfDay timeOfDay, bool value) async {

    // SharedPreferencesのインスタンス
    final prefs = await SharedPreferences.getInstance(); 

    // コピーをとる
    var oldState = SplayTreeMap<TimeOfDay, bool>(
      (a, b) {
        return (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute);
      }
    )..addAll(state); 

    // 新規データを追加
    oldState[timeOfDay] = value;

    // stateを上書き
    state = oldState;

    // SharedPreferencesに追加
    int minuteTime = timeOfDay.hour * 60 + timeOfDay.minute;
    prefs.setBool(minuteTime.toString(), value);
  }

  // 削除
  void remove(TimeOfDay timeOfDay) async {

    // SharedPreferencesのインスタンス
    final prefs = await SharedPreferences.getInstance(); 

    // コピーをとる
    var oldState = SplayTreeMap<TimeOfDay, bool>(
      (a, b) {
        return (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute);
      }
    )..addAll(state); 

    // 変数から消す
    oldState.remove(timeOfDay);
    state = oldState;

    // SharedPreferencesから削除
    int minuteTime = timeOfDay.hour * 60 + timeOfDay.minute;
    prefs.remove(minuteTime.toString());
  }
}
