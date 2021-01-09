import 'package:flutter/material.dart';
import 'selecte_game_page.dart';
import 'package:play_with_friends/games/codenames.dart';
import 'package:play_with_friends/games/sing_a_long.dart';
import 'package:play_with_friends/games/guesswho/guess_who_choose_category.dart';

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
        fontFamily: "Space Grotesk",
        primarySwatch: createMaterialColor(const Color.fromRGBO(241, 233, 218, 1)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),
     home: SelectGamePage(title: 'Play With Friends'),
     // home: Codenames(),
     // home: GuessWhoChooseCategory(),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}

