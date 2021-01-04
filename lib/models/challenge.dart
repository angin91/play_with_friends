class Challenge {

  String title;
  String challenge;
  String number;
  int drinks;
  bool isPersonalChallenge;

  Challenge(this.title, this.challenge, this.number, this.drinks, this.isPersonalChallenge);

  factory Challenge.fromJson(dynamic json) {
    return Challenge(json['title'] as String, json['challenge'] as String, json['number'] as String, json['drinks'] as int, json['isPersonalChallenge'] as bool);
  }
}