import 'package:briefing/model/article_rss.dart';
import 'package:flutter/material.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/article_title_section.dart';

class BriefingCard extends StatefulWidget {
  final ArticleRss article;
  static const double height = 300.0;

  const BriefingCard({Key key, this.article}) : super(key: key);

  @override
  BriefingCardState createState() {
    return new BriefingCardState();
  }
}

class BriefingCardState extends State<BriefingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
      child: Column(
        children: <Widget>[
          ArticleTitleSection(article: widget.article),
          ArticleBottomSection(article: widget.article),
        ],
      ),
    );
  }
}
