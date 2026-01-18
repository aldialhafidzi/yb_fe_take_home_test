import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article.dart';
import 'package:yb_fe_take_home_test/shared/services/articles_services.dart';
import 'package:yb_fe_take_home_test/shared/services/bookmark_services.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_small.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';

Widget buildMenuItem(
  IconData icon,
  String label,
  String url,
  BuildContext context,
) {
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    onTap: () {
      context.go(url);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 4),
        Text(label, style: smallTextStyle),
      ],
    ),
  );
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final ArticlesServices newsService = ArticlesServices();

  String selectedCategory = 'general';

  late Future<List<Article>> bookmarks;

  @override
  void initState() {
    super.initState();
    bookmarks = BookmarkService.getBookmarks();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bookmark',
                      style: mediumBoldTextStyle.copyWith(color: Colors.black),
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
                    FutureBuilder<List<Article>>(
                      future: bookmarks,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 250,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No articles found'));
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
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: whiteColor,
        color: whiteColor,
        padding: EdgeInsets.all(0),
        child: Center(
          child: Container(
            height: 76,
            constraints: BoxConstraints(maxWidth: 450),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 2, color: greenColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // <--- penting
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildMenuItem(Icons.home_outlined, 'Home', '/home', context),
                buildMenuItem(
                  Icons.explore_outlined,
                  'Explore',
                  '/explore',
                  context,
                ),
                buildMenuItem(
                  Icons.bookmark_outline,
                  'Bookmark',
                  '/bookmark',
                  context,
                ),
                buildMenuItem(
                  Icons.account_circle_outlined,
                  'Profile',
                  '/profile',
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
