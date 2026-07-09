/// Pure Dart model for DownloadedBayan — stored locally via SharedPreferences.
/// `audio` now holds the flat `audioUrl` string from the .NET API directly
/// (previously a JSON-encoded JSON:API `{id, storage, metadata}` attachment
/// map that had to be decoded back into a Map at display time).
class DownloadedBayan {
  int id;
  String? bayanId;
  String? title;
  String? excerpt;
  String? location;
  String? audio;
  String? speaker;
  String? publishedAt;
  DateTime? createdAt;

  DownloadedBayan({
    this.id = 0,
    this.bayanId,
    this.title,
    this.excerpt,
    this.location,
    this.audio,
    this.speaker,
    this.publishedAt,
    this.createdAt,
  });

  factory DownloadedBayan.fromJson(Map<String, dynamic> json) {
    return DownloadedBayan(
      id: json['id'] ?? 0,
      bayanId: json['bayanId'],
      title: json['title'],
      excerpt: json['excerpt'],
      location: json['location'],
      audio: json['audio'],
      speaker: json['speaker'],
      publishedAt: json['publishedAt'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bayanId': bayanId,
        'title': title,
        'excerpt': excerpt,
        'location': location,
        'audio': audio,
        'speaker': speaker,
        'publishedAt': publishedAt,
        'createdAt': createdAt?.toIso8601String(),
      };
}
