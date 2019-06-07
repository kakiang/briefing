import 'package:briefing/model/article_rss.dart';
import 'package:flutter/material.dart';
import 'package:briefing/widget/bottomsheet_article_menu.dart';

class ArticleBottomSection extends StatelessWidget {
  final ArticleRss article;

  const ArticleBottomSection({Key key, @required this.article})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    void _modalBottomSheetMenu() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomSheetArticleMenu(article: article);
        },
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(article.timeAgo, style: Theme.of(context).textTheme.subtitle),
          InkWell(
            child: Icon(
              Icons.more_vert,
              color: Colors.grey[600],
            ),
            onTap: () {
              _modalBottomSheetMenu();
            },
          ),
        ],
      ),
    );
  }
}
