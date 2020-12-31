import 'package:flutter/material.dart';

class Game {

  String title;
  Widget game;
  List<GameTag> tags;
  Color color1;
  Color color2;

  Game(this.title, this.game, this.tags, this.color1, this.color2);

  hasTag(GameTag tag){
    if(tags.contains(tag)){
      return true;
    }
    return false;
  }

}

enum GameTag {drinkingGame, teamGame}