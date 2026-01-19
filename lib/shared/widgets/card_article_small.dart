import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/utils/formater.dart';

class CardArticleSmall extends StatelessWidget {
  final String title;
  final String subtitle;
  final String source;
  final String imageURL;
  final String date;

  const CardArticleSmall({
    super.key,
    required this.title,
    required this.subtitle,
    required this.source,
    this.imageURL = '',
    this.date = '',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/articles/detail/$title');
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://gnews-proxy-test.vercel.app/api/image?url=$imageURL',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitle, style: xSmallTextStyle),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 264,
                      child: Text(title, style: mediumTextStyle, maxLines: 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://gnews-proxy-test.vercel.app/api/image?url=$imageURL',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 60),
                                  child: Text(
                                    source,
                                    style: linkXSmallTextStyle,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time_outlined, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  FormaterUtils.timeAgo(date),
                                  style: xSmallTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(child: Icon(Icons.more_horiz_outlined)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
