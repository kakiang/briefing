import 'package:flutter/material.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/webview.dart';

class BriefingSliverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(articleList
          .where((article) => article.isValid)
          .map<Widget>((Article article) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: InkWell(
            child: Column(
              children: <Widget>[
                BriefingCard(article: article),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ArticleWebView(article);
                  },
                ),
              );
            },
          ),
        );
      }).toList()),
    );
  }
}
