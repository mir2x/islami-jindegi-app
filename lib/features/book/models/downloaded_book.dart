/// Pure Dart model for DownloadedBook — stored locally via SharedPreferences.
class DownloadedBook {
  int id;
  String? bookId;
  String? title;
  String? excerpt;
  String? publisher;
  String? price;
  String? image;
  String? document;
  String? authors;
  String? publishedAt;
  DateTime? createdAt;

  DownloadedBook({
    this.id = 0,
    this.bookId,
    this.title,
    this.excerpt,
    this.publisher,
    this.price,
    this.image,
    this.document,
    this.authors,
    this.publishedAt,
    this.createdAt,
  });

  factory DownloadedBook.fromJson(Map<String, dynamic> json) {
    return DownloadedBook(
      id: json['id'] ?? 0,
      bookId: json['bookId'],
      title: json['title'],
      excerpt: json['excerpt'],
      publisher: json['publisher'],
      price: json['price'],
      image: json['image'],
      document: json['document'],
      authors: json['authors'],
      publishedAt: json['publishedAt'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'title': title,
        'excerpt': excerpt,
        'publisher': publisher,
        'price': price,
        'image': image,
        'document': document,
        'authors': authors,
        'publishedAt': publishedAt,
        'createdAt': createdAt?.toIso8601String(),
      };
}
