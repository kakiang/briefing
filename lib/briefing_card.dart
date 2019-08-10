import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/article_title_section.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class BriefingCard extends StatefulWidget {
  final Article article;

  const BriefingCard({Key key, this.article}) : super(key: key);

  @override
  BriefingCardState createState() {
    return BriefingCardState();
  }
}

class BriefingCardState extends State<BriefingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
      child: Column(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(20.0),
            child: ArticleTitleSection(article: widget.article),
            onTap: () {
              _launchURL(context, widget.article.url);
            },
          ),
          ArticleBottomSection(article: widget.article),
        ],
      ),
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
