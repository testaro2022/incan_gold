import 'package:flutter/material.dart';
import 'howtopage.dart';
import 'gamepage.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight, //左向きを許可
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Incan Gold',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Incan Gold Home Page'),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) =>
              MyHomePage(title: 'Incan Gold Home Page'),
          '/gamepage': (BuildContext context) =>
              new GamePage(title: 'Incan Gold　Game'),
          '/howtoplaypage': (BuildContext context) =>
              new HowtoPage(title: 'How to Play Incan Gold'),
          // '/scorepage': (BuildContext context) => new ScorePage(title: 'レコード'),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GamePage(title: "Incan Gold Home Page")),
                  );
                },
                child: Text(
                  "スタート",
                ),
              ),
            ),
            SizedBox(
              width: 0,
              height: 20,
            ),
            SizedBox(
              width: 200,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HowtoPage(title: "How to Play Incan Gold")),
                  );
                },
                child: Text(
                  "遊び方",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
