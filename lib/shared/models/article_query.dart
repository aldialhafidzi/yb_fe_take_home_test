class ArticleQuery {
  final int page;
  final int limit;
  final String? q;
  final String? category;

  const ArticleQuery({
    this.page = 1,
    this.limit = 10,
    this.q,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
      if (q != null && q!.isNotEmpty) 'q': q,
      if (category != null) 'category': category,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleQuery &&
        page == other.page &&
        limit == other.limit &&
        q == other.q &&
        category == other.category;
  }

  @override
  int get hashCode =>
      page.hashCode ^ limit.hashCode ^ q.hashCode ^ category.hashCode;
}
