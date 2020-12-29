class DeckCard {

  String card;
  String task;
  String description;
  String url;

  DeckCard(this.card, this.task, this.description, this.url);

  factory DeckCard.fromJson(dynamic json) {
    return DeckCard(json['card'] as String, json['task'] as String, json['description'] as String, json['url'] as String);
  }
}