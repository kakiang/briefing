import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/article_title_section.dart';

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
          ArticleTitleSection(article: widget.article),
          ArticleBottomSection(article: widget.article),
          Divider()
        ],
      ),
    );
  }
}
