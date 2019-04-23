import 'package:flutter/material.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/webview.dart';
import 'package:briefing/widget/article_thumbnail.dart';

class ArticleTitleSection extends StatelessWidget {
   final Article article;

  const ArticleTitleSection({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      showArticleWebView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ArticleWebView(article);
        },
      ),
    );
  }

    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 18.0,
                      height: 14.0,
                      color: Colors.grey[200],
                      margin: EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              article.agency.iconUrl ?? ''
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text( article.agency.name),
                  ]
                ),
                Container(
                  padding: EdgeInsets.only(top: 4.0),
                  child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      title: Text(
                        article.title,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis),
                      onTap: () {
                        showArticleWebView();
                      }),
                )
              ],
            ),
          ),
          ArticleThumbnail(article: article),
        ],
      ),
    );
  }
}