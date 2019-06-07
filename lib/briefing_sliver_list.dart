import 'dart:async';

import 'package:briefing/bloc_article_list.dart';
import 'package:flutter/material.dart';

// import 'package:briefing/model/article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/webview.dart';
import 'package:webfeed/webfeed.dart';

class BriefingSliverList extends StatefulWidget {
  const BriefingSliverList({Key key}) : super(key: key);

  @override
  _BriefingSliverListState createState() => _BriefingSliverListState();
}

class _BriefingSliverListState extends State<BriefingSliverList> {
  final ArticleListBloc _bloc = ArticleListBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

//  RefreshIndicator(
//  color: Colors.blue[800],
//  backgroundColor: Colors.white,
//  onRefresh: () async {
//  // less elegant and more expedient and, I hope, momentarily
//  // solution to the problem that the current context doesn't
//  // contain a Scaffold.
//  _scaffoldKey.currentState.showSnackBar(
//  SnackBar(content: Text('Refresh feature to be implemented')),
//  );
//  await new Future.delayed(const Duration(seconds: 1));
//},

  @override
  Widget build(BuildContext context) {
    Widget loadingInfo(String message) {
      return Container(
        height: 48.0,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        StreamBuilder<List<RssItem>>(
            stream: _bloc.rssItemList,
            initialData: List(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                debugPrint("main:hasData ${snapshot.data.length}");
                return ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          child: Column(
                            children: <Widget>[
                              BriefingCard(article: snapshot.data[index]),
//                              if (index + 1 < snapshot.data.length) Divider()
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ArticleWebView(snapshot.data[index]);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                debugPrint("main:hasError");
                return loadingInfo("Can't connect to the internet, try again.");
              } else {
                debugPrint(
                    "LinearProgressIndicator state: ${snapshot.connectionState}");
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ),
                );
              }
            }),
      ]),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final Stream<bool> _isLoading;

  const LoadingWidget(this._isLoading);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _isLoading,
      initialData: true,
      builder: (context, snapshot) {
        debugPrint("_bloc.isLoading: ${snapshot.data}");
        return snapshot.data
            ? Center(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
