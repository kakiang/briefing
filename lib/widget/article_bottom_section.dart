import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';
import 'package:briefing/widget/bottomsheet_article_menu.dart';

class ArticleBottomSection extends StatelessWidget {
  final Article article;

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
          Text(
            article.timeAgo,
            style: TextStyle(fontFamily: 'Libre_Franklin', fontSize: 12.0),
          ),
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
