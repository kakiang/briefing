import 'dart:async';

import 'package:briefing/bloc_article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/webview.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    Widget errorWidget(String message) {
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.warning,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontFamily: 'Libre_Franklin'),
              ),
            ),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        StreamBuilder<List<Article>>(
            stream: _bloc.articleListObservable,
            initialData: List(),
            builder: (context, snapshot) {
              debugPrint("!!!snapshot state: ${snapshot.connectionState}!!!");
              if (snapshot.hasData && snapshot.data.length > 0) {
                return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
//                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: InkWell(
                          child: Column(
                            children: <Widget>[
                              BriefingCard(
                                  article: snapshot.data.elementAt(index)),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ArticleWebView(
                                      snapshot.data.elementAt(index));
                                },
                              ),
                            );
                          },
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                debugPrint("!!!snapshot error ${snapshot.error.toString()}");
                return errorWidget("${snapshot.error}");
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
//                      backgroundColor: Colors.white,
//                      valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
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
