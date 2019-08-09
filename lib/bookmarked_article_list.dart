import 'dart:async';

import 'package:briefing/bloc/bloc_article.dart';
import 'package:briefing/bloc/bloc_bookmark_article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';

class BookmarkArticleList extends StatefulWidget {
  const BookmarkArticleList({Key key}) : super(key: key);

  @override
  _BookmarkArticleListState createState() => _BookmarkArticleListState();
}

class _BookmarkArticleListState extends State<BookmarkArticleList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  BookmarkArticleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BookmarkArticleListBloc();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
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
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                displacement: 5.0,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                child: snapshot.hasData && snapshot.data.length > 0
                    ? ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 18.0),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return BriefingCard(
                              article: snapshot.data.elementAt(index));
                        })
                    : snapshot.hasError
                        ? Center(
                            child: ErrorWidget(message: ['${snapshot.error}']))
                        : Center(
                            child: Container(
                                margin: EdgeInsets.all(16.0),
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator()),
                          ),
              );
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
      margin: EdgeInsets.only(top: 92.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.cloud_off, size: 55.0),
          Text('Woops...',
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center),
          Text(message.join('\n'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontWeight: FontWeight.w600)),
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
                  margin: EdgeInsets.only(top: 92.0),
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
