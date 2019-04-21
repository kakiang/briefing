import 'package:briefing/model/article.dart';
import 'package:briefing/webview.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
//import 'package:connectivity/connectivity.dart';

class BriefingCard extends StatefulWidget {
  final Article article;
  static const double height = 300.0;

  const BriefingCard({Key key, this.article}) : super(key: key);

  @override
  BriefingCardState createState() {
    return new BriefingCardState();
  }
}

class BriefingCardState extends State<BriefingCard> {
  // This is the builder method that creates a new page.
//  var subscription;
//
//  initState() {
//    super.initState();
//
//    subscription = (Connectivity()
//        .onConnectivityChanged
//        .listen((ConnectivityResult result) {
//      print("connection status changed $result");
//    }));
//  }

//  dispose() {
//    super.dispose();
//    subscription.cancel();
//  }

  showArticleWebView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ArticleWebView(widget.article);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _modalBottomSheetMenu() {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return new Container(
              color: Colors.transparent,
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
                        leading: new Icon(Icons.bookmark_border),
                        title: new Text('Save for later'),
                        onTap: () {
                          // showArticleWebView();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.share),
                      title: new Text('Share'),
                      onTap: () {
                        Share.share("check out ${widget.article.link}");
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    Container buttonSection = Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.article.dateTime,
              style: Theme.of(context).textTheme.subtitle),
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

    Container titleSection = Container(
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
                              'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif' ??
                                  '',
                            ),
                          ),
                        ),
                      ),
//                      Icon(
//                        Icons.assignment,
//                        semanticLabel: "news agency icon",
//                      ),
                    ),
                    Text(
                      widget.article.agency,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 4.0),
                  child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      title: Text(
                        widget.article.title,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
//                      subtitle: Padding(
//                        padding: const EdgeInsets.only(top: 4.0),
//                        child: Text(widget.article.description),
//                      ),
                      onTap: () {
                        showArticleWebView();
                      }),
                )
              ],
            ),
          ),
          thumbnail,
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          titleSection,
          buttonSection,
        ],
      ),
    );
  }

  Widget get thumbnail {
    var articleThumbnail = Container(
      margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
      width: 92.0,
      height: 92.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        // border: Border.all(style: BorderStyle.solid, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.grey[200],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.article.thumbnail ?? ''),
//                image: AssetImage(
//                  widget.article.assetName,
//                ),
        ),
      ),
    );
    var placeholder = Container(
//      margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
//      width: 92.0,
//      height: 92.0,
//      decoration: BoxDecoration(
//        color: Colors.grey,
//        shape: BoxShape.rectangle,
//        // border: Border.all(style: BorderStyle.solid, width: 2.0),
//        borderRadius: BorderRadius.circular(4.0),
//      ),
        );
    // This is an animated widget built into flutter.
    return AnimatedCrossFade(
      // You pass it the starting widget and the ending widget.
      firstChild: placeholder,
      secondChild: articleThumbnail,
      // Then, you pass it a ternary that should be based on your state
      //
      // If renderUrl is null tell the widget to use the placeholder,
      // otherwise use the dogAvatar.

      crossFadeState: widget.article.thumbnail == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      // Finally, pass in the amount of time the fade should take.
      duration: Duration(milliseconds: 1000),
    );
  }
}
