import 'package:briefing/model/article.dart';
import 'package:briefing/service/database.dart';
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
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        child: Wrap(children: <Widget>[
          ListTile(
            leading: Icon(Icons.share, size: 28.0),
            title: Text('Share'),
            onTap: () {
              Share.share('check out ${widget.article.url}');
            },
          ),
          ListTile(
            leading: Icon(
              widget.article.bookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              size: 28.0,
            ),
            title: Text(widget.article.bookmarked ? 'Bookmarked' : 'Bookmark'),
            onTap: () async {
              setState(() {
                widget.article.bookmarked = !widget.article.bookmarked;
              });

              int id = await DatabaseService.db.updateArticle(widget.article);
              print('Article $id updated');
              Navigator.of(context).pop();
            },
          ),
        ]),
      ),
    );
  }
}
