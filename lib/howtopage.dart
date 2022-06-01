import 'package:flutter/material.dart';

class HowtoPage extends StatefulWidget {
  const HowtoPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<HowtoPage> createState() => _HowtoPageState();
}

class _HowtoPageState extends State<HowtoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "遊び方",
            style: TextStyle(fontSize: 24),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                    "インカの黄金は探検者になってダイヤや宝物を集めて点数を競うゲームです.\n"
                    "探検者は「遺跡を探検する」を選ぶことで次のカードにしたがって行動します.\n"
                    "カードの種類は3種類です.\n",
                    style: TextStyle(fontSize: 12)),
                Text(
                    "「ダイヤカード」:書いてある数字を探検中のプレイヤー数に応じてダイヤとして分配されます. "
                    "余りは遺跡の中に置かれます. "
                    "余りのダイヤカードはプレイヤーが「キャンプに戻る」を選択した時に同時に戻るプレイヤー数に応じて分配されます. "
                    "ダイヤの点数は1個1点です\n",
                    style: TextStyle(fontSize: 12)),
                Text(
                    "「障害カード」:各ラウンドにおいて同じ絵柄のカードを2回引く探検中のプレイヤーは手持ちのダイヤをすべて失い"
                    "ラウンドが終了します. "
                    "一度2回引かれたカードはゲームから1枚取り除かれます. \n",
                    style: TextStyle(fontSize: 12)),
                Text(
                    "「宝物カード」遺跡の中に置かれます. 「キャンプに戻る」を選択したプレイヤーが一人だった時"
                    "遺跡の中に置かれた宝物はそのプレイヤーのものになります. 宝物の点数は3枚目まで5点,4枚目から10点です. \n",
                    style: TextStyle(fontSize: 12)),
                Text(
                  "カード一覧\n"
                  "ダイヤカード:1,2,3,4,5,7,9,11,12,13,14,15の11種類を1枚ずつ\n"
                  "障害カード:コウモリ,火,ミイラ,ヘビ,クモの5種類を3枚ずつ\n"
                  "宝物カード:5枚\n"
                  "障害カードがゲームから追放されたとき入れ替えるためのダイヤカード:3,5,7,11を1枚ずつ",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
