import 'dart:async';

import 'package:briefing/bloc/bloc_article.dart';
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
  ArticleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ArticleListBloc();
  }

  Future<void> _onRefresh() async {
    _bloc.refresh();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                return GestureDetector(
                  onTap: _onRefresh,
                  child: ErrorWidget(
                    message: [
                      '${snapshot.error}',
                      'Keep calm, and tap to retry',
                    ],
                  ),
                );
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

class ErrorWidget extends StatelessWidget {
  final List<String> message;

  const ErrorWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset('assets/images/no_internet.png'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Woops, something went wrong...',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Libre_Franklin'),
            ),
          ),
          Text(
            message.join('\n'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17.0, fontFamily: 'Libre_Franklin'),
          ),
        ],
      ),
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
