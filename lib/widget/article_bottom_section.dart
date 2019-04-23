import 'package:flutter/material.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/widget/bottomsheet_article_menu.dart';

class ArticleBottomSection extends StatelessWidget {
  final Article article;

  const ArticleBottomSection({Key key, @required this.article}) : super(key: key);
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
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(article.dateTime, style: Theme.of(context).textTheme.subtitle),
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
