import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_controller.dart';
import 'alarm_datas.dart';
import 'edit_alarm_screen.dart';
import 'time_of_day_converter.dart';
import 'shake_alarm.dart';

void main() async {

  // 初期設定
  WidgetsFlutterBinding.ensureInitialized();
  AndroidAlarmManager.initialize(); //初期化
  NotificationController().initNotification();

  // 画面を表示
  MaterialApp app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
  );

  final scope = ProviderScope(
    child: app
  );
  
  runApp(scope);
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)  {

    Map<TimeOfDay, bool> alarmDatas =  ref.watch(alarmDatasNotifierProvider);

    return Scaffold(
      // 上側
      appBar: AppBar(
        title: const Text('Main'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 40),
            onPressed: () async {
              // ポップするまで待機
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditAlarmScreen()),
              );
            },
          ),
          
          IconButton(
            icon: const Icon(Icons.restart_alt, size: 40),
            onPressed: () async {
              // AlarmDatasNotifireProviderにセーブデータを書き込み
              final notifier = ref.read(alarmDatasNotifierProvider.notifier);
              notifier.loadSaveData();
            },
          ),
        ],
      ),

      body: Center(
        child: ListView(
          children: <Widget>[

            for (var entry in alarmDatas.entries) ...{
              Container(
                alignment: const Alignment(0.0, 0.0),
                margin: const EdgeInsets.symmetric(vertical:5, horizontal:20),
                padding: const EdgeInsets.symmetric(vertical:5),
                color: (entry.value)?const Color.fromARGB(255, 231, 231, 231) : const Color.fromARGB(255, 115, 115, 115),
                child: Row(
                  children: <Widget>[

                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        // セーブデータから消す
                        final notifier = ref.read(alarmDatasNotifierProvider.notifier);
                        notifier.remove(entry.key); 

                        // アラームをキャンセル
                        ShakeAlarm.cancelAlarm(entry.key);
                      },
                      iconSize: 48,
                      color: Colors.red,
                    ),
                    Text(
                      TimeOfDayConverter.toStringFromTimeOfDay(entry.key),
                      style: const TextStyle(
                        fontSize: 44, // フォントサイズを調整
                      ),
                    ),

                    const Spacer(),

                    // トグル
                    Switch(
                      value: entry.value,
                      onChanged: (value) {

                        // セーブデータを変更
                        final notifier = ref.read(alarmDatasNotifierProvider.notifier);
                        notifier.update(entry.key, value); 

                        // オンにする場合はアラームをセット
                        if(value){
                          ShakeAlarm.setAlarm(entry.key);
                        }

                        // オフにする場合はアラームをキャンセル
                        else{
                          ShakeAlarm.cancelAlarm(entry.key);
                        }
                      },
                    ),
                  ],
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
}