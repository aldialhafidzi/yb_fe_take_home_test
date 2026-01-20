import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_large.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_buttom_app_bar.dart';
import 'package:yb_fe_take_home_test/features/home/provider/home_articles_provider.dart';

class CategoryPage extends ConsumerStatefulWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final notifier = ref.read(
        homeTopArticlesProvider(
          ArticleQuery(category: widget.category),
        ).notifier,
      );

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _debounce = Timer(const Duration(milliseconds: 500), () {
          _debounce?.cancel();

          notifier.loadMore();
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryTop = ArticleQuery(category: widget.category);
    final top = ref.watch(homeTopArticlesProvider(queryTop));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        shadowColor: whiteColor,
        elevation: 0,
        title: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Spacer(),
                Text(
                  widget.category[0].toUpperCase() +
                      widget.category.substring(1),
                  style: linkMediumTextStyle,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 450),
          child: ListView(
            controller: _scrollController,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    ...top.articles
                        .skip(1)
                        .map(
                          (article) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CardArticleLarge(
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

                    if (top.isError)
                      SizedBox(
                        height: 250,
                        child: Center(
                          child: Text('Error: Failed to fetch articles'),
                        ),
                      ),

                    if (!top.hasMore)
                      const SizedBox(
                        height: 250,
                        child: Center(child: Text('No articles found')),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButtomAppBar(),
    );
  }
}
