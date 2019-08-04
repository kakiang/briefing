import 'package:briefing/model/article.dart';
import 'package:briefing/widget/article_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class ArticleTitleSection extends StatelessWidget {
  final Article article;

  const ArticleTitleSection({Key key, @required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
//                CachedNetworkImage(
//                  imageUrl: article.imageUrl ?? '',
//                  imageBuilder: (context, imageProvider) => Container(
//                    width: 28.0,
//                    height: 18.0,
//                    decoration: BoxDecoration(
//                        shape: BoxShape.rectangle,
//                        border: Border.all(color: Colors.grey[300]),
//                        borderRadius: BorderRadius.circular(3.0),
//                        image: DecorationImage(
//                            image: imageProvider, fit: BoxFit.fill)),
//                    margin: EdgeInsets.only(right: 8.0),
//                  ),
//                  placeholder: (context, url) => Container(),
//                  errorWidget: (context, url, error) => Container(),
//                ),
                Icon(Icons.web),
                SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    article.source,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
              ]),
              Container(
                  padding: EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 4.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    title: Text(article.title,
                        softWrap: true,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    onTap: () {
                      _launchURL(context, article.link);
                    },
                  ))
            ],
          ),
        ),
        ArticleThumbnail(article: article),
      ],
    );
  }

  void _launchURL(BuildContext context, String link) async {
    try {
      await launch(
        link,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
