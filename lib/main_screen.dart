import 'package:android_alarm_app/alarm_datas.dart';
import 'package:android_alarm_app/edit_alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'notification_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // 初期設定
  WidgetsFlutterBinding.ensureInitialized();
  AndroidAlarmManager.initialize(); //初期化
  NotificationController().initNotification();

  // shared_preferencesに保存されているデータを全部読み込む
  // final prefs = await SharedPreferences.getInstance();
  // Set<String> keys = prefs.getKeys();
  // for (String key in keys) {
  //   int minuteTime = int.parse(key); 
  //   TimeOfDay timeOfDay = TimeOfDay(hour: minuteTime ~/ 60, minute: minuteTime % 60);
  //   alarmDatas[timeOfDay] = prefs.getBool(key) ?? false;
  // }

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


              // // セーブデータを読み取り
              // final prefs = await SharedPreferences.getInstance();
    
              // // 返り値
              // SplayTreeMap<TimeOfDay, bool> alarmDatas = SplayTreeMap<TimeOfDay, bool>(
              //   (a, b) {
              //     final aMinutes = a.hour * 60 + a.minute;
              //     final bMinutes = b.hour * 60 + b.minute;
              //     return aMinutes.compareTo(bMinutes);
              //   }
              // ); //Map<TimeOfDay, bool>();

              // // セーブしていたデータを読み込み
              // Set<String> keys = prefs.getKeys();
              // for (String key in keys) {
              //   int minuteTime = int.parse(key); 
              //   TimeOfDay timeOfDay = TimeOfDay(hour: minuteTime ~/ 60, minute: minuteTime % 60);
              //   alarmDatas[timeOfDay] = prefs.getBool(key) ?? false;
              // }

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
                        final notifier = ref.read(alarmDatasNotifierProvider.notifier);
                        notifier.remove(entry.key); 
                      },
                      iconSize: 48,
                      color: Colors.red,
                    ),
                    Text(
                      '${entry.key.hour.toString().padLeft(2, '0')} : ${entry.key.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 44, // フォントサイズを調整
                      ),
                    ),

                    const Spacer(),

                    // トグル
                    Switch(
                      value: entry.value,
                      onChanged: (value) {
                        final notifier = ref.read(alarmDatasNotifierProvider.notifier);
                        notifier.update(entry.key, !entry.value); 
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