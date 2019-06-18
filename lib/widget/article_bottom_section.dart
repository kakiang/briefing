import 'package:briefing/model/article.dart';
import 'package:briefing/widget/bottomsheet_article_menu.dart';
import 'package:flutter/material.dart';

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

    Widget categoryWidget() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: HSVColor.fromAHSV(
                    1.0,
                    ((360.0 *
                            (article.categories.first.hashCode & 0xffff) /
                            (1 << 15)) %
                        360.0),
                    0.4,
                    0.90)
                .toColor()),
        child: Text(
          article.categories.first,
          style: TextStyle(
            fontFamily: 'Libre_Franklin',
            fontSize: 12.0,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                article.timeAgo,
                style: TextStyle(fontFamily: 'Libre_Franklin', fontSize: 12.0),
              ),
              if (article.categories != null &&
                  article.categories.length > 0 &&
                  article.categories.first.isNotEmpty)
                categoryWidget()
            ],
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
