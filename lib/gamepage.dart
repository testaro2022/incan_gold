import 'package:flutter/material.dart';
import 'package:incan_gold/game.dart';
import 'main.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final int MAX_ROUND_NUM = 5;
  final int PLAYERS_NUM = 3;
  GameState _gameState = GameState();

  @override
  void initState() {
    super.initState();
    _gameState.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 最上段:余白
                  SizedBox(
                    width: 0,
                    height: 20,
                  ),
                  //上段:ROUND数とplayerスコアを置く
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //現在のラウンド表示
                      Text("Round${_gameState.roundNumber}/$MAX_ROUND_NUM\n"
                          "diamondLeft:${_gameState.diamondsLeft},\n"
                          "deck:${_gameState.cardsOnDeck.length}"),
                      //playerスコア
                      for (var _competitors in _gameState.competitors)
                        SizedBox(
                            width: 100,
                            height: 90,
                            child: Card(
                              color: (_gameState.competitorsInruins
                                      .contains(_competitors))
                                  ? Colors.yellow
                                  : Colors.grey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("${_competitors.playerName}"),
                                      //拾ったダイヤ
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: Image.asset(
                                                'images/icon_diamond.png'),
                                          ),
                                          Text("×${_competitors.diamonds}"),
                                        ],
                                      ),
                                      //キャンプに入れたダイヤ
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: Image.asset(
                                                'images/icon_tent.png'),
                                          ),
                                          Text(
                                              "×${_competitors.diamondsIncamp}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: Image.asset(
                                                'images/icon_treasure.png'),
                                          ),
                                          Text(
                                              "×${_competitors.treasureIncamp}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("score:${_competitors.score}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //playerの現在のスコアを表す
                                ],
                              ),
                            )),
                    ],
                  ),
                  //中段1:カードを置く
                  Row(
                    children: [
                      //山札
                      SizedBox(
                          width: 43,
                          height: 68,
                          child: Card(
                            child: Image.asset('images/card_deck.png'),
                          )),
                      //カード
                      for (String _card in (_gameState.cardsOnBoard.length > 13)
                          ? _gameState.cardsOnBoard.sublist(0, 14)
                          : _gameState.cardsOnBoard)
                        SizedBox(
                            width: 45,
                            height: 67,
                            child: Card(
                              child: Image.asset('images/card_${_card}.png'),
                            )),
                    ],
                  ),
                  //中段2:入りきらないカードを置く
                  Row(
                    children: [
                      //カード
                      for (var _card in (_gameState.cardsOnBoard.length > 13)
                          ? _gameState.cardsOnBoard.sublist(14)
                          : [])
                        SizedBox(
                            width: 45,
                            height: 67,
                            child: Card(
                              child: Image.asset('images/card_${_card}.png'),
                            )),
                      //ボタン下部固定のためのダミーsizedbox
                      SizedBox(
                        width: 0,
                        height: 67,
                      )
                    ],
                  ),
                  //下段:テキストメッセージ+進むか引くかのボタン
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //余白
                      SizedBox(
                        width: 10,
                        height: 0,
                      ),
                      //テキストメッセージ
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  for (var text
                                      in _gameState.textmessage.reversed)
                                    Text(text),
                                  Text(
                                      "===============GAME START==============="),
                                ],
                              ),
                            ),
                          ),
                          // child: Column(
                          //   children: [
                          //     for (var text in _gameState.textmessage)
                          //       Text(text),
                          //   ],
                          // ),
                          color: Color(0xFFD3DEF1),
                          height: 100.0,
                        ),
                      ),
                      //余白
                      SizedBox(
                        width: 10,
                        height: 0,
                      ),
                      //キャンプに戻るボタン
                      SizedBox(
                        width: 100,
                        height: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _gameState.AliceBackToCamp();
                              _gameState.AIaction();
                              _gameState.newTurn();
                            });
                          },
                          child: Text(
                            "キャンプ\nに戻る",
                          ),
                        ),
                      ),
                      //余白
                      SizedBox(
                        width: 10,
                        height: 0,
                      ),
                      // 遺跡に進むボタン
                      SizedBox(
                        width: 100,
                        height: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _gameState.AIaction();
                              _gameState.newTurn();
                            });
                          },
                          child: Text((_gameState.competitorsInruins
                                  .contains(_gameState.Alice))
                              ? "遺跡を\n探検する"
                              : "次のターンへ"),
                        ),
                      ),
                      //余白
                      SizedBox(
                        width: 20,
                        height: 0,
                      )
                    ],
                  )
                ],
              ),
              Visibility(
                visible:
                    _gameState.roundNumber == 5 && _gameState.RoundOverFlag,
                child: Container(
                    color: Colors.grey.withOpacity(0.8),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i in _gameState.competitors)
                        Text("${i.playerName} score: ${i.score}",style: TextStyle(fontSize: 24),),
                        SizedBox(
                          width: 200,
                          height: 80,
                          child: ElevatedButton(
                            child: Text("最初に戻る"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage(
                                        title: "Incan Gold Home Page")),
                              );
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              Visibility(
                visible: _gameState.RoundOverFlag && _gameState.roundNumber < 5,
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ラウンド${_gameState.roundNumber}が終了しました"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 80,
                            child: ElevatedButton(
                              child: Text("次のラウンドへ"),
                              onPressed: () {
                                setState(() {
                                  _gameState.reroll();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
