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
          Text(
            "インカの黄金の遊び方を書く",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    ));
  }
}
