class Challenge {

  String title;
  String challenge;
  String number;
  int drinks;
  bool isPersonalChallenge;
  int duration;
  String doneText;

  Challenge(this.title, this.challenge, this.number, this.drinks, this.isPersonalChallenge, this.duration, this.doneText);

  factory Challenge.fromJson(dynamic json) {
    return Challenge(
        json['title'] as String,
        json['challenge'] as String,
        json['number'] as String,
        json['drinks'] as int,
        json['isPersonalChallenge'] as bool,
        json['duration'] as int,
        json['doneText'] as String);
  }
}