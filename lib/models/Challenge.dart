class Challenge {

  String title;
  String challenge;
  String number;

  Challenge(this.title, this.challenge, this.number);

  factory Challenge.fromJson(dynamic json) {
    return Challenge(json['title'] as String, json['challenge'] as String, json['number'] as String);
  }
}