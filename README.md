# アンドロイド用アラームアプリの練習
- Flutterの勉強がてら作ってみました。
- 現時点(2023年12月19日)ではバグも多いです。
<br>

## 搭載したい機能(完了済みの機能は線で消す予定)
- 標準の目覚ましアプリと同様に時刻を指定できる(トグルなどで鳴らすかどうかを選択できる)
- アラームを設定したら0:00に通知で設定された時刻を表示
- 指定時刻にアラームを鳴らす
- アラームは画面操作 or <b>スマホを振る</b>で止められるようにする。
- (アラームを好きな曲にできる)
<br><br>

## 現時点(2023年12月19日)で発生しているバグ
- スリープ状態にしてから数時間経つと指定時刻になってもアラームが鳴らない。
- スマホを5回振ったら止められるようにしたいが、2回とかで止まるときもある。
<br><br>

## 参考サイトなど
- ローカル通知の基礎：https://youtu.be/26TTYlwc6FM
- 指定時刻のローカル通知：https://youtu.be/T6Wg0AmIESE
<br><br>

## 使用パッケージ(カッコ内はバージョン)
- flutter_local_notifications(15.0.0)：ローカル通知。バージョンを15以降にすると指定時刻での通知が上手くできませんでした。
- flutter_datetime_picker_plus(2.1.0)：時刻選択。
- timezone(^0.9.2)：タイムゾーンの取得?
- flutter_ringtone_player(3.2.0)：アラームを鳴らす。
- android_alarm_manager_plus(3.0.3)：アンドロイド用で指定時刻にバックグラウンドで処理が可能。
<br><br>
