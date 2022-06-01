import 'dart:math';

List<String> cardList = [
  //treasureが5枚,dangerが5種3枚ずつ,合計30枚
  "diamond_1",
  "diamond_2",
  "diamond_3",
  "diamond_4",
  "diamond_5",
  "diamond_7",
  "diamond_9",
  "diamond_11",
  "diamond_13",
  "diamond_14",
  "diamond_15",
  "treasure",
  "treasure",
  "treasure",
  "treasure",
  "treasure",
  "danger_bat",
  "danger_bat",
  "danger_bat",
  "danger_fire",
  "danger_fire",
  "danger_fire",
  "danger_mummy",
  "danger_mummy",
  "danger_mummy",
  "danger_snake",
  "danger_snake",
  "danger_snake",
  "danger_spider",
  "danger_spider",
  "danger_spider",
];

List<String> standbyCardList = [
  // 3,5,7,11
  "diamond_3",
  "diamond_5",
  "diamond_7",
  "diamond_11",
];

class GameState {
  List<String> cardsOnDeck = [];
  List<String> cardsOnBoard = [];
  List<String> cardsOnSide = [];
  int diamondsLeft = 0; //道中残されたダイヤ
  int treasuresLeft = 0; //道中残された宝
  List<String> Troubles = []; //1つのラウンドで出た障害カード
  int roundNumber = 1;
  int turnNumber = 0;
  bool RoundOverFlag = false;
  bool troubleFlag = false;
  int score = 0;
  int playersNum = 3;

  Players Alice = Players("Alice");
  Players Bob = Players("Bob");
  Players Charlie = Players("Charlie");
  List<Players> competitors = []; //playerのリスト
  List<Players> competitorsInruins = []; //遺跡に残っているplayerのリスト
  List<Players> camper = []; //1つのターンで一緒に帰るプレイヤーのリスト

  GameState() {
    this.cardsOnDeck = cardList.toList()..shuffle();
    this.cardsOnBoard = [];
    this.cardsOnSide = standbyCardList.toList()..shuffle();
    this.competitors = [Alice, Bob, Charlie];
    this.competitorsInruins = [Alice, Bob, Charlie];
  }

  void init() {
    competitorsInruins = [Alice, Bob, Charlie];
    camper = [];
    Troubles.clear();
    diamondsLeft = 0; //道中残されたダイヤの初期化
    treasuresLeft = 0; //道中残された宝の初期化

    //道中手に入れたダイヤの初期化
    for (var _competitors in competitors) {
      _competitors.init();
    }

    // consequence = undefine;
    RoundOverFlag = false;
    troubleFlag = false;
    turnNumber = 1;

    //一番最初の場札
    var _temp = cardsOnDeck[0];
    //デッキの先頭を削除
    cardsOnDeck.removeAt(0);
    //場札の末尾に追加
    cardsOnBoard.add(_temp);
    _encounter(_temp);
  }

  void AliceBackToCamp() {
    camper.add(Alice);
    competitorsInruins.remove(Alice);
  }

  void AIaction() {
    //AIが行くか退くか決める
    for (var who in competitorsInruins) {
      who.will = who.decide(this);
      if (who != Alice && who.will == "back") {
        camper.add(who);
        competitorsInruins.remove(who);
      }
    }
  }

  void newTurn() async {
    // AIaction();
    backToCamp(camper);
    if (competitorsInruins.isEmpty) {
      RoundOverFlag = true;
    }
    if (cardsOnDeck.length > 0) {
      var _temp = cardsOnDeck[0];
      //デッキの先頭を削除
      cardsOnDeck.removeAt(0);
      //場札の末尾に追加
      cardsOnBoard.add(_temp);
      //めくれたカードにしたがって処理
      _encounter(_temp);
    }
    turnNumber++;
  }

  void _encounter(String card) async {
    if (card.contains("diamond")) {
      //"card_diamond_xx"の"card_diamond_"の部分を消して数字にする
      diamondsLeft += int.parse(card.replaceFirst("diamond_", "")) %
          competitorsInruins.length;
      for (var _competitor in competitorsInruins) {
        _competitor.diamonds += int.parse(card.replaceFirst("diamond_", "")) ~/
            competitorsInruins.length;
      }
    } else if (card.contains("treasure")) {
      treasuresLeft += 1;
    }
    // 障害カードを引いたとき
    else {
      var _trouble = card.replaceFirst("danger_", "");
      if (Troubles.contains(_trouble)) {
        //score加算なしで終わり
        troubleFlag = true;
        RoundOverFlag = true;
      } else {
        //1枚目の障害カードを記録
        Troubles.add(_trouble);
      }
    }
  }

  void backToCamp(List<Players> camper) {
    //ダイヤをキャンプに入れscore計算
    for (var who in camper) {
      who.score += who.diamonds;
      who.diamondsIncamp += who.diamonds;
      who.diamonds = 0;
      competitorsInruins.remove(who);
    }
    // 宝をキャンプに入れる 宝は3枚目まで5点4枚目以降10点
    //もっとすっきり書きたい
    if (camper.length == 1) {
      for (var i = 0; i < treasuresLeft; i++) {
        camper[0].treasureIncamp++;
        if (camper[0].treasureIncamp > 3) {
          camper[0].score += 10;
        } else {
          camper[0].score += 5;
        }
        cardsOnBoard.remove("treasure");
      }
      camper[0].score += diamondsLeft;
      camper[0].diamondsIncamp += diamondsLeft;
      diamondsLeft = 0;
    }
    camper.clear();
  }

  void reroll() {
    //障害カードを抜いてサイドカードと入れ替え
    if (troubleFlag) {
      cardsOnBoard.removeAt(cardsOnBoard.length - 1);
      cardList.add(cardsOnSide[0]);
      cardsOnSide.removeAt(0);
    }
    //場のカードを片づける
    cardsOnDeck.addAll(cardsOnBoard);
    cardsOnBoard.clear();
    cardsOnDeck.shuffle();
    roundNumber++;
    init();
  }
}

class Players {
  String? playerName;
  int diamonds = 0;
  int diamondsIncamp = 0;
  int treasureIncamp = 0;
  int score = 0;
  String will = "";

  Players(String name) {
    this.playerName = name;
  }

  void init() {
    diamonds = 0;
  }

  String decide(GameState gs) {
    double _randomNum = (100 + Random().nextInt(30) - Random().nextInt(30)) /
        100; //0.7~1.3の間で変動
    int _secondDangerCardNum = 0; //引いたら負けるカードの枚数

    for (var i in gs.cardsOnBoard) {
      if (i.contains("danger")) {
        for (var j in gs.cardsOnDeck) {
          if (i == j) _secondDangerCardNum++;
        }
      }
    }

    //このラウンド負ける確率＝引いたらいけないカードの数/残りの枚数
    double _defeatProbability =
        _secondDangerCardNum / gs.cardsOnDeck.length * 100;

    if (_defeatProbability * _randomNum < 10) {
      return "go";
    } else {
      return "back";
    }
  }
}
