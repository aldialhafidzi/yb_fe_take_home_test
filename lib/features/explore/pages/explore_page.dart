import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/features/explore/provider/expore_articles_provider.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_large.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_small.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_buttom_app_bar.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;
  String _keyword = 'Bali';

  final TextEditingController _searchController = TextEditingController();

  int page = 1;
  bool isLoading = false;
  bool isError = false;
  bool hasMore = true;

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _keyword = value.isEmpty ? 'Bali' : value);
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

    _scrollController.addListener(() {
      final notifier = ref.read(
        exploreArticlesProvider(ArticleQuery(q: _keyword)).notifier,
      );

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        notifier.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ArticleQuery(q: _keyword);
    final state = ref.watch(exploreArticlesProvider(query));

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
                          if (state.articles.isNotEmpty)
                            CardArticleLarge(
                              title: state.articles[0].title,
                              description: state.articles[0].description,
                              subtitle: 'General',
                              source: state.articles[0].sourceName,
                              imageURL: state.articles[0].imageUrl,
                              date: state.articles[0].publishedAt,
                            ),
                          SizedBox(height: 16),
                          ...state.articles
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

                          if (state.isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            ),

                          // if (state.isError)
                          //   SizedBox(
                          //     height: 250,
                          //     child: Center(
                          //       child: Text('Error: Failed to fetch articles'),
                          //     ),
                          //   ),
                          
                          if (!state.hasMore)
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
