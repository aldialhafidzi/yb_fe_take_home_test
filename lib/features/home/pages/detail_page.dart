import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/models/article.dart';
import 'package:yb_fe_take_home_test/shared/models/article_query.dart';
import 'package:yb_fe_take_home_test/shared/services/bookmark_services.dart';
import 'package:yb_fe_take_home_test/shared/utils/formater.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yb_fe_take_home_test/features/home/provider/home_articles_provider.dart';

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

class DetailPage extends ConsumerStatefulWidget {
  final String title;

  const DetailPage({super.key, required this.title});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final query = ArticleQuery(
      q: widget.title
          .split(' ')
          .take(2)
          .join(' ')
          .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ''),
      limit: 1,
      page: 1,
    );
    final results = ref.watch(homeArticlesProvider(query));

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
                    context.go('/login');
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.share_outlined),
                  onPressed: () async {
                    try {
                      String title = results.articles[0].title;
                      String url = results.articles[0].url;
                      shareToWhatsApp('$title: $url');
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                ),
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
            minHeight: MediaQuery.of(context).size.height - 150,
          ),
          child: IntrinsicHeight(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 450),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    if (results.articles.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                openUrl(results.articles[0].url);
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
                                              'https://gnews-proxy-test.vercel.app/api/image?url=${results.articles[0].imageUrl}',
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
                                          results.articles[0].sourceName,
                                          style: linkMediumTextStyle,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          FormaterUtils.timeAgo(
                                            results.articles[0].publishedAt,
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
                                    image: NetworkImage(
                                      'https://gnews-proxy-test.vercel.app/api/image?url=${results.articles[0].imageUrl}',
                                    ),
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
                                results.articles[0].title,
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
                                results.articles[0].content,
                                style: mediumTextStyle.copyWith(
                                  color: grayscaleBodyTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (results.isLoading)
                      const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      ),

                    if (results.isError)
                      SizedBox(
                        height: 250,
                        child: Center(
                          child: Text('Error: Failed to fetch articles'),
                        ),
                      ),

                    if (!results.hasMore)
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

      // Floating bottom menu
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: whiteColor,
        color: whiteColor,
        padding: EdgeInsets.all(0),
        child: Center(
          child: Container(
            height: 76,
            constraints: BoxConstraints(maxWidth: 450),
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
                      final safeArticle = Article(
                        title: results.articles[0].title,
                        description: results.articles[0].description,
                        sourceName: results.articles[0].sourceName,
                        image: results.articles[0].image,
                        publishedAt: results.articles[0].publishedAt,
                        url: results.articles[0].url,
                        imageUrl: results.articles[0].imageUrl,
                        content: results.articles[0].content,
                      );

                      await BookmarkService.addBookmark(safeArticle);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('1 article bookmarked!')),
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
