import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article.dart';
import 'package:yb_fe_take_home_test/shared/services/articles_services.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_large.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_small.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_buttom_app_bar.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ArticlesServices newsService = ArticlesServices();

  late Future<List<Article>> trendingArticles;
  late Future<List<Article>> latestArticles;

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

  @override
  void initState() {
    super.initState();
    trendingArticles = newsService.fetchTopArticles('general');
    latestArticles = newsService.fetchTopArticles(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
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
                        labelText: '',
                        clearableText: true,
                        prefixIcon: Icon(Icons.search_outlined),
                        suffixIcon: Icon(Icons.tune_outlined),
                        hintText: 'Search..',
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Text('Trending', style: linkMediumTextStyle),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            context.go('/articles/technology');
                          },
                          child: Text('See All', style: smallTextStyle),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    FutureBuilder<List<Article>>(
                      future: trendingArticles,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            height: 250,
                            child: Center(
                              child: Text('Error: ${snapshot.error}'),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const SizedBox(
                            height: 250,
                            child: Center(child: Text('No articles found')),
                          );
                        }

                        final article = snapshot.data![0];

                        return SizedBox(
                          child: CardArticleLarge(
                            title: article.title,
                            description: article.description,
                            subtitle: 'General',
                            source: article.sourceName,
                            imageURL: article.imageUrl,
                            date: article.publishedAt,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Text('Latest', style: linkMediumTextStyle),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            context.go('/articles/general');
                          },
                          child: Text('See All', style: smallTextStyle),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: categories.map((cat) {
                              final bool isSelected =
                                  cat['category'] == selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isSelected
                                            ? primaryDarkModeColor
                                            : transparentColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    child: Text(
                                      cat['title']!,
                                      style: mediumTextStyle.copyWith(
                                        color: isSelected
                                            ? Colors.black
                                            : grayscaleBodyTextColor,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = cat['category']!;
                                        latestArticles = newsService
                                            .fetchTopArticles(selectedCategory);
                                      });
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder<List<Article>>(
                      future: latestArticles,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            height: 250,
                            child: Center(
                              child: Text('Error: ${snapshot.error}'),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const SizedBox(
                            height: 250,
                            child: Center(child: Text('No articles found')),
                          );
                        }

                        final articles = snapshot.data!;
                        return Column(
                          children: articles.map((article) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: CardArticleSmall(
                                title: article.title,
                                subtitle:
                                    selectedCategory[0].toUpperCase() +
                                    selectedCategory.substring(1),
                                source: article.sourceName,
                                imageURL: article.imageUrl,
                                date: article.publishedAt,
                              ),
                            );
                          }).toList(),
                        );
                      },
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
