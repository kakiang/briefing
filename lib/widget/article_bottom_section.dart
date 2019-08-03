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

    Widget categoryWidget(String val) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: Colors.white
//            color: HSVColor.fromAHSV(
//                    1.0,
//                    ((360.0 * (val.hashCode & 0xffff) / (1 << 15)) % 360.0),
//                    0.4,
//                    0.90)
//                .toColor()
            ),
        child: Text(val, style: Theme.of(context).textTheme.subtitle),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(article.timeAgo, style: Theme.of(context).textTheme.subtitle)
            ],
          ),
          InkWell(
            child: Icon(Icons.more_vert),
            onTap: () {
              _modalBottomSheetMenu();
            },
          ),
        ],
      ),
    );
  }
}
