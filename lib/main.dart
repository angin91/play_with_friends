import 'package:flutter/material.dart';
import 'package:play_with_friends/games/AlphabetGameStartPage.dart';
import 'package:play_with_friends/games/GuessWhoStartPage.dart';
import 'package:play_with_friends/games/SingALongStartPage.dart';
import 'SelecteGamePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectGamePage(title: 'Play With Friends'),
//      home: GuessWhoStartPage(),
//      home: AlphabetGameStartPage(),
//      home: SingALongStartPage(),
    );
  }
}

