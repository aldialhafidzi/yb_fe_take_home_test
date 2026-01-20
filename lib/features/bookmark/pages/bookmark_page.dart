import 'package:flutter/material.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article.dart';
import 'package:yb_fe_take_home_test/shared/services/bookmark_services.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_small.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_buttom_app_bar.dart';
import 'package:yb_fe_take_home_test/shared/widgets/text_field_input.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
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
      bottomNavigationBar: CustomButtomAppBar(),
    );
  }
}
