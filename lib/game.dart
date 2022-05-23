import "dart:async";

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

enum Consequence {
  campalone,
  campwithfriends,
  havetrouble,
  undefine,
}

class GameState {
  List<String> cardsOnDeck = [];
  List<String> cardsOnBoard = [];
  List<String> cardsOnSide = [];
  int diamonds = 0; //道中手に入れたダイヤ
  // int treasures = 0; //手に入れた宝
  int diamondsLeft = 0; //道中残されたダイヤ
  int treasuresLeft = 0; //道中残された宝
  int diamondsIncamp = 0; //持って帰ってダイヤ
  int treasureIncamp = 0; //持って帰った宝
  List<String> Troubles = [];
  int roundNumber = 1;
  int turnNumber = 0;
  Consequence? consequence;
  bool RoundOverFlag = false;
  bool troubleFlag = false;
  int score = 0;
  int playersNum = 3;

  Players Alice = Players("Alice");
  Players Bob = Players("Bob");
  Players Charlie = Players("Charlie");
  List<Players> competitors = [];

  GameState() {
    this.cardsOnDeck = cardList.toList()..shuffle();
    this.cardsOnBoard = [];
    this.cardsOnSide = standbyCardList.toList()..shuffle();
    List<Players> competitors = [Alice, Bob, Charlie];
  }

  void init() {
    Troubles.clear();
    diamondsLeft = 0; //道中残されたダイヤ
    treasuresLeft = 0; //道中残された宝

    //道中手に入れたダイヤ
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

  void newTurn() {
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
      diamondsLeft = int.parse(card.replaceFirst("diamond_", "")) % playersNum;
      for (var _competitor in competitors) {
        _competitor.diamonds =
            int.parse(card.replaceFirst("diamond_", "")) ~/ playersNum;
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

  void backToCamp() {
    //ダイヤをキャンプに入れscore計算
    score += diamonds;
    diamondsIncamp = diamonds;
    diamonds = 0;

    // 宝をキャンプに入れる 宝は3枚目まで5点4枚目以降10点
    //もっとすっきり書きたい
    for (var i = 0; i < treasuresLeft; i++) {
      treasureIncamp++;
      if (treasureIncamp > 3) {
        score += 10;
      } else {
        score += 5;
      }
      cardsOnBoard.remove("treasure");
    }
    // treasures = 0;
    RoundOverFlag = true;
    //ほんとは余ったダイヤとかの処理する
  }

  void reroll() {
    print(cardsOnBoard);
    print(cardsOnDeck..sort());
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

  Players(String name) {
    this.playerName = name;
  }

  void init() {
    diamonds = 0;
  }

  void decide() {}
}
