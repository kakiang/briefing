import 'package:flutter/material.dart';
import 'package:briefing/model/article.dart';
import 'package:share/share.dart';

class BottomSheetArticleMenu extends StatelessWidget {
  final Article article;

  const BottomSheetArticleMenu({Key key, @required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      // color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          // shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
          ),
        ),
        child: new Wrap(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.share),
              title: new Text('Share'),
              onTap: () {
                Share.share("check out ${article.link}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
