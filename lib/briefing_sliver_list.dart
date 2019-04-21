import 'package:flutter/material.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/briefing_card.dart';
// import 'package:url_launcher/url_launcher.dart';

class BriefingSilverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate:
          SliverChildListDelegate(articleList.map<Widget>((Article article) {
        return Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
          child: InkWell(
            child: Column(
              children: <Widget>[
                BriefingCard(article: article),
                Divider(),
              ],
            ),
            onTap: () {
              // if (await canLaunch(article.link)) {
              //   launch(article.link);
              // }
            },
          ),
        );
      }).toList()),
    );
  }
}
