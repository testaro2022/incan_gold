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
  bool _visibleAlice = false;
  bool _visibleBob = false;
  bool _visibleChalie = false;
  bool _visibleCard = false;

  Widget tellAIAction(Players AI) {
    if (_gameState.competitorsInruins.contains(AI)) {
      return Text("${AI.playerName}(COM)は次のターン遺跡を探検するようです",
          style: TextStyle(fontSize: 24));
    } else {
      if (_gameState.camper.contains(AI)) {
        return Text("${AI.playerName}(COM)は次のターンキャンプに帰るようです",
            style: TextStyle(fontSize: 24));
      } else {
        return Text("${AI.playerName}(COM)はキャンプにいます。",
            style: TextStyle(fontSize: 24));
      }
    }
  }

  Widget tellNextCard() {
    String _text = "";
    if (_gameState.competitorsInruins.isEmpty) {
      // _text = "探検隊は全員帰りました";
      return Text("探検隊は全員帰りました", style: TextStyle(fontSize: 24));
    } else {
      switch (_gameState.cardsOnDeck[0]) {
        case "danger_spider":
          _text = "次のカードは障害カード「クモ」でした\n";
          break;
        case "danger_mummy":
          _text = "次のカードは障害カード「ミイラ」でした\n";
          break;
        case "danger_fire":
          _text = "次のカードは障害カード「火」でした\n";
          break;
        case "danger_snake":
          _text = "次のカードは障害カード「ヘビ」でした\n";
          break;
        case "danger_bat":
          _text = "次のカードは障害カード「ヘビ」でした\n";
          break;
        case "treasure":
          _text = "次のカードは宝物カードでした\n";
          break;
        default:
          _text =
              "次のカードはダイヤカード「${_gameState.cardsOnDeck[0].replaceAll("diamond_", "")}」でした\n";
          break;
      }
      if (_gameState.Troubles.contains(
          _gameState.cardsOnDeck[0].replaceFirst("danger_", ""))) {
        _text += "2回目の障害カードなので探検はここで終わりです。";
      } else {
        _text += "探検隊は洞窟の奥へと進んだ......";
      }
    }
    return Text(_text, style: TextStyle(fontSize: 24));
  }

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
                  const SizedBox(height: 20),
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
                      const SizedBox(height: 67)
                    ],
                  ),
                  //進むか引くかのボタン
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 遺跡に進むボタン
                      SizedBox(
                        width: 500,
                        height: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _visibleAlice = true;
                            });
                          },
                          child: Text("次のターンへ"),
                        ),
                      ),
                      //余白
                      const SizedBox(width: 20)
                    ],
                  )
                ],
              ),
              //ALiceが遺跡にいるとき
              Visibility(
                visible: _visibleAlice &&
                    _gameState.competitorsInruins.contains(_gameState.Alice),
                child: Container(
                    color: Colors.red.withOpacity(0.8),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Alice(あなた)は次のターンどうする？",
                            style: TextStyle(fontSize: 24)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 80,
                              child: ElevatedButton(
                                child: Text("キャンセル"),
                                onPressed: () {
                                  setState(() {
                                    _visibleAlice = false;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 80,
                              child: ElevatedButton(
                                child: Text("遺跡を探検する"),
                                onPressed: () {
                                  // _gameState.newTurn();
                                  setState(() {
                                    _visibleBob = true;
                                    _visibleAlice = false;
                                    _gameState.AIaction();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 80,
                              child: ElevatedButton(
                                child: Text("キャンプに戻る"),
                                onPressed: () {
                                  setState(() {
                                    _gameState.AliceBackToCamp();
                                    _visibleBob = true;
                                    _visibleAlice = false;
                                    _gameState.AIaction();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              //Aliceがキャンプにいるとき
              Visibility(
                visible: _visibleAlice &&
                    !(_gameState.competitorsInruins.contains(_gameState.Alice)),
                child: Container(
                    color: Colors.red.withOpacity(0.8),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Alice(あなた)はキャンプに帰っています。",
                            style: TextStyle(fontSize: 24)),
                        SizedBox(
                          width: 200,
                          height: 80,
                          child: ElevatedButton(
                            child: Text("次へ"),
                            onPressed: () {
                              setState(() {
                                _visibleBob = true;
                                _visibleAlice = false;
                                _gameState.AIaction();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              //Bobのターン
              Visibility(
                visible: _visibleBob,
                child: Container(
                    color: Colors.red.withOpacity(0.5),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tellAIAction(_gameState.Bob),
                        SizedBox(
                          width: 200,
                          height: 80,
                          child: ElevatedButton(
                            child: Text("次へ"),
                            onPressed: () {
                              setState(() {
                                _visibleBob = false;
                                _visibleChalie = true;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              //Chalieのターン
              Visibility(
                visible: _visibleChalie,
                child: Container(
                    color: Colors.red.withOpacity(0.5),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tellAIAction(_gameState.Charlie),
                        SizedBox(
                          width: 200,
                          height: 80,
                          child: ElevatedButton(
                            child: Text("次へ"),
                            onPressed: () {
                              setState(() {
                                _visibleCard = true;
                                _visibleChalie = false;
                              });
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              //次のカードの解説
              Visibility(
                visible: _visibleCard,
                child: Container(
                    color: Colors.red.withOpacity(0.3),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tellNextCard(),
                        SizedBox(
                          width: 200,
                          height: 80,
                          child: ElevatedButton(
                            child: Text("確認"),
                            onPressed: () {
                              setState(() {
                                _visibleCard = false;
                                _gameState.newTurn();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              //ゲーム終了時に出る
              Visibility(
                visible:
                    _gameState.roundNumber == 5 && _gameState.RoundOverFlag,
                child: Container(
                    color: Colors.grey.withOpacity(0.8),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Alice score: ${_gameState.Alice.score}",
                            style: TextStyle(fontSize: 24)),
                        Text("Bob score: ${_gameState.Bob.score}",
                            style: TextStyle(fontSize: 24)),
                        Text("Chalie score: ${_gameState.Charlie.score}",
                            style: TextStyle(fontSize: 24)),
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
              //Round終了時に出る
              Visibility(
                visible: _gameState.RoundOverFlag && _gameState.roundNumber < 5,
                child: Container(
                  color: Colors.grey.withOpacity(0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ラウンド${_gameState.roundNumber}が終了しました",
                          style: TextStyle(fontSize: 24)),
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
