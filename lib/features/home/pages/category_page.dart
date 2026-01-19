import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article.dart';
import 'package:yb_fe_take_home_test/shared/services/articles_services.dart';
import 'package:yb_fe_take_home_test/shared/widgets/card_article_large.dart';
import 'package:yb_fe_take_home_test/shared/widgets/custom_buttom_app_bar.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ArticlesServices newsService = ArticlesServices();

  late Future<List<Article>> latestArticles;

  @override
  void initState() {
    super.initState();
    latestArticles = newsService.fetchTopArticles(widget.category);
  }

  @override
  Widget build(BuildContext context) {
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
                child: FutureBuilder<List<Article>>(
                  future: latestArticles,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No articles found'));
                    }

                    final articles = snapshot.data!;
                    return Column(
                      children: articles.map((article) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: CardArticleLarge(
                            title: article.title,
                            description: article.description,
                            subtitle:
                                widget.category[0].toUpperCase() +
                                widget.category.substring(1),
                            source: article.sourceName,
                            imageURL: article.imageUrl,
                            date: article.publishedAt,
                          ),
                        );
                      }).toList(),
                    );
                  },
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
