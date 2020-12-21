class Song {

  String title;
  String artist;
  String lyric;
  String solution;

  Song(this.title, this.artist, this.lyric, this.solution);

  factory Song.fromJson(dynamic json) {
    return Song(json['title'] as String, json['artist'] as String, json['lyric'] as String, json['solution'] as String);
  }
}