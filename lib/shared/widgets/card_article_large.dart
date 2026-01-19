import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_fe_take_home_test/core/theme/app_theme.dart';
import 'package:yb_fe_take_home_test/shared/utils/formater.dart';

class CardArticleLarge extends StatelessWidget {
  final String title;
  final String subtitle;
  final String source;
  final String imageURL;
  final String date;
  final String description;

  const CardArticleLarge({
    super.key,
    required this.title,
    required this.subtitle,
    required this.source,
    this.imageURL = '',
    this.date = '',
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/articles/detail/$title');
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.9,
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
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(subtitle, style: xSmallTextStyle),
            ),
            SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                style: mediumTextStyle.copyWith(color: Colors.black),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                description,
                style: xSmallTextStyle.copyWith(color: grayscaleBodyTextColor),
                maxLines: 2,
              ),
            ),
            SizedBox(height: 4),
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
                          constraints: BoxConstraints(maxWidth: 70),
                          child: Text(
                            source,
                            style: linkXSmallTextStyle,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, size: 18),
                        SizedBox(width: 4),
                        Text(
                          FormaterUtils.timeAgo(date),
                          style: smallTextStyle,
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
    );
  }
}
