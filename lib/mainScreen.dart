import 'package:android_alarm_app/editAlarmScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'notificationController.dart';
// import 'editAlarmScreen.dart';


late Map<TimeOfDay, bool> alarmDatas = Map<TimeOfDay, bool>();

void main() async {
  // 初期設定
  WidgetsFlutterBinding.ensureInitialized();
  AndroidAlarmManager.initialize(); //初期化
  NotificationController().initNotification();

  // shared_preferencesに保存されているデータを全部読み込む
  final prefs = await SharedPreferences.getInstance();
  Set<String> keys = prefs.getKeys();
  for (String key in keys) {
    int minuteTime = int.parse(key); 
    TimeOfDay timeOfDay = TimeOfDay(hour: minuteTime ~/ 60, minute: minuteTime % 60);
    alarmDatas[timeOfDay] = prefs.getBool(key) ?? false;
  }

  // 画面を表示
  final app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
  );
  
  runApp(app);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  {

  @override
  Widget build(BuildContext context)  {

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

              setState(() {});
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
                color: (entry.value)?Colors.white : Colors.grey,
                child: Row(
                  children: <Widget>[

                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: (){
                        setState(() {
                          
                          // GlobalSetting().saveData.alarmDatas.removeAt(i); // 指定したインデックスの要素を削除                    
                        });
                      },
                      iconSize: 48,
                      color: Colors.red,
                    ),

                    Text(
                      '${entry.key.hour} : ${entry.key.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 44, // フォントサイズを調整
                      ),
                    ),

                    const Spacer(),

                    // トグル
                    // Switch(
                    //   value: GlobalSetting().saveData.alarmDatas[i].isSetting,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       GlobalSetting().saveData.alarmDatas[i].isSetting = value;
                    //       GlobalSetting().save();
                    //     });
                    //   },
                    // ),
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