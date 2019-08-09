import 'dart:async';

import 'package:briefing/bloc/bloc_article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';

class BriefingSliverList extends StatefulWidget {
  final Menu menu;

  const BriefingSliverList({Key key, this.menu}) : super(key: key);

  @override
  _BriefingSliverListState createState() => _BriefingSliverListState();
}

class _BriefingSliverListState extends State<BriefingSliverList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ArticleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ArticleListBloc();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  Future<void> _onRefresh() async {
//    await _bloc.refresh()
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.menuSubject.sink.add(widget.menu);
    if (widget.menu != null && widget.menu == Menu.local) {
      _bloc.categorySink.add('local');
    } else {
      _bloc.categorySink.add('All');
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        if (widget.menu == Menu.headlines)
          StreamBuilder<String>(
              stream: _bloc.categoryObservable,
              builder: (context, snapshot) {
                return Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  elevation: 1.0,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.0),
                    height: 30.0,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: categories.keys
                          .where((category) => category != 'local')
                          .map(
                            (category) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                  selectedColor: Theme.of(context).accentColor,
                                  label: Text(category),
                                  selected: snapshot.data == category,
                                  onSelected: (val) {
                                    _refreshIndicatorKey.currentState.show();
                                    _bloc.categorySink.add(category);
                                  }),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              }),
        StreamBuilder<List<Article>>(
            stream: _bloc.articleListObservable,
            initialData: List(),
            builder: (context, snapshot) {
              debugPrint("!!!snapshot state: ${snapshot.connectionState}!!!");
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
                        },
                      )
                    : snapshot.hasError
                        ? Center(
                            child: GestureDetector(
                              onTap: _onRefresh,
                              child:
                                  ErrorWidget(message: ['${snapshot.error}']),
                            ),
                          )
                        : Center(
                            child: Container(
                              margin: EdgeInsets.all(16.0),
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            ),
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
//      margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.cloud_off, size: 55.0),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Woops...',
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center)),
          Text(
            message.join('\n'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.w600),
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
