// import 'dart:async';

import 'dart:async';

import 'package:briefing/model/article_rss.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatefulWidget {
  final ArticleRss article;

  ArticleWebView(this.article);

  @override
  _ArticleWebViewState createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: <Widget>[
    //       SliverAppBar(
    //           brightness: Brightness.light,
    //           elevation: 1.0,
    //           floating: true,
    //           snap: true,
    //           title: Text(
    //             widget.article.title,
    //             style: TextStyle(fontSize: 18.0),
    //           )),
    //       WebView(
    //         initialUrl: widget.article.link,
    //         javascriptMode: JavascriptMode.unrestricted,
    //         onWebViewCreated: (WebViewController controller) {
    //           _controller.complete(controller);
    //         },
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(),
        elevation: 1.0,
        title: Text(
          widget.article.agency,
        ),
      ),
      body: WebView(
        initialUrl: widget.article.link,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
