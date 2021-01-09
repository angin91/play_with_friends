import 'package:flutter/material.dart';

class CodenamesInfo {

  String word;
  CodenamesTag team;

  CodenamesInfo(this.word, this.team);

  Color getColor(){
    if(team == CodenamesTag.red){
      return Colors.red;
    }else if(team == CodenamesTag.blue){
      return Colors.blue;
    }else if(team == CodenamesTag.assassin){
      return Colors.grey;
    }else {
      return Colors.white;
    }
  }
}

enum CodenamesTag {red, blue, assassin, none}