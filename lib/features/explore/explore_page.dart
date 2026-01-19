import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article.dart';
import 'package:yb_fe_take_home_test/shared/services/articles_services.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_large.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_small.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_buttom_app_bar.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ArticlesServices newsService = ArticlesServices();
  final ScrollController _scrollController = ScrollController();

  late Future<List<Article>> latestArticles;
  List<Article> articles = [];

  String selectedCategory = 'general';

  final List<Map<String, String>> categories = [
    {'title': 'General', 'category': 'general'},
    {'title': 'World', 'category': 'world'},
    {'title': 'Nation', 'category': 'nation'},
    {'title': 'Business', 'category': 'business'},
    {'title': 'Technology', 'category': 'technology'},
    {'title': 'Entertainment', 'category': 'entertainment'},
    {'title': 'Sports', 'category': 'sports'},
    {'title': 'Science', 'category': 'science'},
    {'title': 'Health', 'category': 'health'},
  ];

  final TextEditingController _searchController = TextEditingController();

  int page = 1;
  bool isLoading = false;
  bool isError = false;
  bool hasMore = true;

  // ignore: unused_field
  String? _keyword = '';
  Timer? _debounce;

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _keyword = value;
      });

      if (value != '') {
        latestArticles = newsService.fetchArticles(value, 11, page);
      } else {
        latestArticles = newsService.fetchArticles('Bali', 11, page);
      }
    });
  }

  void _onScroll() {
    print(
      '_scrollController.position.pixels ${_scrollController.position.pixels}',
    );
    print(
      '_scrollController.position.maxScrollExtent ${_scrollController.position.maxScrollExtent}',
    );

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore) {
      _fetchMore();
    }
  }

  Future<void> _fetchInitial() async {
    setState(() => isLoading = true);

    try {
      final result = await newsService.fetchArticles('Bali', 11, page);
      setState(() {
        articles = result;
        page++;
        hasMore = result.isNotEmpty;
        isError = false;
      });
    } catch (e) {
      print('[_fetchInitial]: ${e.toString()}');
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMore() async {
    setState(() => isLoading = true);

    final result = await newsService.fetchArticles('Bali', 11, page);

    setState(() {
      articles.addAll(result);
      page++;
      isLoading = false;

      if (result.isEmpty) hasMore = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 100,
          ),
          child: IntrinsicHeight(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 450),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: EdgeInsets.all(0),
                              backgroundColor: whiteColor,
                            ),
                            child: Icon(
                              Icons.notifications_active_outlined,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      child: TextFieldInput(
                        controller: _searchController,
                        labelText: '',
                        clearableText: true,
                        prefixIcon: Icon(Icons.search_outlined),
                        suffixIcon: Icon(Icons.tune_outlined),
                        hintText: 'Search..',
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Explore', style: linkMediumTextStyle)],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 450,
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          if (articles.isNotEmpty)
                            CardArticleLarge(
                              title: articles[0].title,
                              description: articles[0].description,
                              subtitle: 'General',
                              source: articles[0].sourceName,
                              imageURL: articles[0].imageUrl,
                              date: articles[0].publishedAt,
                            ),
                          SizedBox(height: 16),
                          ...articles.skip(1).map((article) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CardArticleSmall(
                                title: article.title,
                                subtitle: selectedCategory,
                                source: article.sourceName,
                                imageURL: article.imageUrl,
                                date: article.publishedAt,
                              ),
                            );
                          }),

                          if (isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            ),

                          if (isError)
                            SizedBox(
                              height: 250,
                              child: Center(
                                child: Text('Error: Failed to fetch articles'),
                              ),
                            ),

                          if (!hasMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('No more articles'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomButtomAppBar(),
    );
  }
}
