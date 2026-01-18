class Article {
  final String title;
  final String description;
  final String content;
  final String sourceName;
  final String image;
  final String publishedAt;
  final String url;
  final String imageUrl;

  Article({
    required this.title,
    required this.description,
    required this.content,
    required this.sourceName,
    required this.image,
    required this.publishedAt,
    required this.url,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'content': content,
    'sourceName': sourceName,
    'image': image,
    'publishedAt': publishedAt,
    'url': url,
    'imageUrl': imageUrl,
  };

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    content: json['content'] ?? '',
    sourceName: json['sourceName'] ?? json['source']['name'] ?? '',
    image: json['image'] ?? '',
    publishedAt: json['publishedAt'] ?? '',
    url: json['url'] ?? '',
    imageUrl: json['image'] ?? '',
  );
}
