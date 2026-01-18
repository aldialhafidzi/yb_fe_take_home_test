import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article.dart';
import 'package:yb_fe_take_home_test/shared/services/articles_services.dart';
import 'package:yb_fe_take_home_test/shared/services/bookmark_services.dart';
import 'package:yb_fe_take_home_test/shared/utils/formater.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Future<void> shareToWhatsApp(String message) async {
  final url = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch WhatsApp';
  }
}

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

class DetailPage extends StatefulWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ArticlesServices newsService = ArticlesServices();

  late Future<List<Article>> detailArticles;

  @override
  void initState() {
    super.initState();
    detailArticles = newsService.fetchArticles(
      widget.title.substring(0, 10),
      '1',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        shadowColor: whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () async {
              try {
                List<Article> articles =
                    await detailArticles; // tunggu Future selesai
                for (var article in articles) {
                  String title = article.title;
                  String url = article.url;
                  shareToWhatsApp('$title: $url');
                }
              } catch (e) {
                print('Error: $e');
              }
            },
          ),
          IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 379),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: FutureBuilder<List<Article>>(
                  future: detailArticles,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No articles found'));
                    }

                    final article = snapshot.data![0];
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  openUrl(article.url);
                                  print(article.url);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                article.imageUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.sourceName,
                                            style: linkMediumTextStyle,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            FormaterUtils.timeAgo(
                                              article.publishedAt,
                                            ),
                                            style: smallTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              AspectRatio(
                                aspectRatio: 1.5,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                    image: DecorationImage(
                                      image: NetworkImage(article.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: Text('Travel', style: xSmallTextStyle),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  article.title,
                                  style: mediumTextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  article.content,
                                  style: mediumTextStyle.copyWith(
                                    color: grayscaleBodyTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),

      // Floating bottom menu
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: whiteColor,
        color: whiteColor,
        padding: EdgeInsets.all(0),
        child: Center(
          child: Container(
            height: 76,
            constraints: BoxConstraints(maxWidth: 379),
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 2, color: greenColor)),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // <--- penting
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite, color: errorDarkColor),
                            SizedBox(width: 4),
                            Text('24.5K', style: mediumTextStyle),
                          ],
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Icon(Icons.sms_outlined),
                            SizedBox(width: 4),
                            Text('1.5K', style: mediumTextStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    try {
                      List<Article> articles = await detailArticles;
                      for (var article in articles) {
                        // pastikan semua field bukan null
                        final safeArticle = Article(
                          title: article.title,
                          description: article.description,
                          sourceName: article.sourceName,
                          image: article.image,
                          publishedAt: article.publishedAt,
                          url: article.url,
                          imageUrl: article.imageUrl,
                          content: article.content,
                        );
                        await BookmarkService.addBookmark(safeArticle);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${articles.length} article(s) bookmarked!',
                          ),
                        ),
                      );
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.bookmark, color: primaryDefaultColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
