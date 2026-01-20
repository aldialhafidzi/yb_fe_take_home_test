import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/features/home/provider/home_articles_provider.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_large.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_small.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_buttom_app_bar.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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

  Timer? _debounce;
  String _keyword = 'Indonesia';

  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _keyword = value.isEmpty ? 'Indonesia' : value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ArticleQuery(q: _keyword);
    final queryTop = ArticleQuery(category: selectedCategory);

    final latest = ref.watch(homeArticlesProvider(query));
    final top = ref.watch(homeTopArticlesProvider(queryTop));

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
                            context.go('/articles/technology');
                          },
                          child: Text('See All', style: smallTextStyle),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (latest.articles.isNotEmpty)
                      CardArticleLarge(
                        title: latest.articles[0].title,
                        description: latest.articles[0].description,
                        subtitle: 'General',
                        source: latest.articles[0].sourceName,
                        imageURL: latest.articles[0].imageUrl,
                        date: latest.articles[0].publishedAt,
                      ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Text(
                            'Top Headlines',
                            style: linkMediumTextStyle,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            context.go('/articles/$selectedCategory');
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

                    ...top.articles
                        .skip(1)
                        .map(
                          (article) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CardArticleSmall(
                              title: article.title,
                              subtitle: 'General',
                              source: article.sourceName,
                              imageURL: article.imageUrl,
                              date: article.publishedAt,
                            ),
                          ),
                        ),

                    if (top.isLoading)
                      const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      ),

                    // if (top.isError)
                    //   SizedBox(
                    //     height: 250,
                    //     child: Center(
                    //       child: Text('Error: Failed to fetch articles'),
                    //     ),
                    //   ),
                    if (!top.hasMore)
                      const SizedBox(
                        height: 250,
                        child: Center(child: Text('No articles found')),
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
