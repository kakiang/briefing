import 'package:briefing/database/database.dart';
import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class BottomSheetArticleMenu extends StatefulWidget {
  final Article article;

  const BottomSheetArticleMenu({Key key, @required this.article})
      : super(key: key);

  @override
  _BottomSheetArticleMenuState createState() => _BottomSheetArticleMenuState();
}

class _BottomSheetArticleMenuState extends State<BottomSheetArticleMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          // shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
          ),
        ),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Share.share('check out ${widget.article.link}');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(widget.article.bookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border),
              title: Text('Bookmark'),
              onTap: () async {
                setState(() {
                  if (widget.article.bookmarked) {
                    widget.article.bookmarked = false;
                  } else {
                    widget.article.bookmarked = true;
                  }
                });

                int id = await DBProvider.db.updateArticle(widget.article);
                print('Article $id updated');
              },
            ),
          ],
        ),
      ),
    );
  }
}
