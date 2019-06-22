import 'dart:async';

import 'package:briefing/bloc/bloc_provider.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/model/channel.dart';
import 'package:briefing/model/database/repository.dart';
import 'package:briefing/util/rate_limiter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:webfeed/webfeed.dart';

class ArticleListBloc extends BlocBase {
  RateLimiter rateLimit = getRateLimiter;
  final _articleListSubject = BehaviorSubject<List<Article>>();
  List<Article> _articleList = <Article>[];

  ArticleListBloc() {
    _articleListSubject.add(_articleList);
    _init();
  }

  Future<void> _init() async {
    await _loadFromDb();
    if (shouldFetch()) {
      await _fetchFromNetwork();
    }
  }

  Stream<List<Article>> get articleListObservable => _articleListSubject.stream;

  refresh() async {
    print(':::refresh:::');
    _articleListSubject.add(_articleList);
    await _fetchFromNetwork();
  }

  @override
  dispose() {
    _articleListSubject.close();
  }

  Future<void> _loadFromDb() async {
    print('BlocArticle._loadFromDb starts');
    try {
      print('->await RepositoryArticle.getAllArticle starts');
      var localData = await RepositoryArticle.getAllArticle();
      print('->await RepositoryArticle.getAllArticle done');
      print('->RepositoryArticle.getAllArticle isEmpty: ${localData.isEmpty}');
      if (localData.isNotEmpty) {
        _articleList.clear();
        _articleList.addAll(localData);
        _articleListSubject.add(_articleList);
      } else {
        sendErrorMessage('No article in DB');
      }
    } catch (e) {
      print('=== _loadFromDb $e');
    }
    print('BlocArticle._loadFromDb end');
  }

  Future<void> _fetchFromNetwork() async {
    print('BlocArticle.fetchFromNetwork start');
    List<Channel> channels = await RepositoryChannel.getAllFavoriteChannel();

    if (channels.isNotEmpty) {
      List<Article> articles = await _fetchAllChannels(channels);

      if (articles.isNotEmpty) {
        await saveResult(articles);
        await _loadFromDb();
      } else {
        if (_articleList.isEmpty) sendErrorMessage('No article');
      }
    } else {
      if (_articleList.isEmpty) sendErrorMessage('No channel');
    }
  }

  Future<List<Article>> _fetchAllChannels(List<Channel> channels) async {
    List<Article> articles = [];
    try {
      var futures =
          channels.map((channel) async => await _fetchRssFeed(channel));
      final result = await Future.wait(futures);
      print('_fetchAllChannels result.length ${result?.length}');
      if (result != null && result.length > 0) {
        articles = await compute(prepareItems, result);
      }
    } catch (e) {
      print('=== _fetchAllChannels Error $e');
      sendErrorMessage('fetchAllChannels Error $e');
    }
    print('Future.wait length: ${articles?.length}');
    return articles;
  }

  Future<List<Article>> _fetchRssFeed(Channel channel) async {
    print('=== _fetchRssFeed === link:${channel?.linkRss}');
    List<Article> articles = [];

    try {
      final response = await http.get(channel.linkRss);
      if (response.statusCode == 200) {
        var rssFeed = RssFeed.parse(response.body);

        List<RssItem> items = rssFeed?.items;
        items.forEach((rssItem) {
          articles.add(Article.fromRssItem(rssItem, channel));
        });
      } else {
        print('Http Error ${response.statusCode} ${channel.linkRss}');
      }
    } catch (e) {
      print('=== _fetchRssFeed Error ${e.toString()}');
    }
    return articles;
  }

  saveResult(List<Article> articles) async {
    await RepositoryArticle.insertArticleList(articles);
  }

  bool shouldFetch() {
    if (rateLimit.shouldFetch('ArticleList')) {
      return true;
    }
    return false;
  }

//  Future<bool> shouldFetch() async {
//    var connectivityResult = await (Connectivity().checkConnectivity());
//    if (!(connectivityResult == ConnectivityResult.none) &&
//        (rateLimit.shouldFetch('ArticleList'))) {
//      return true;
//    }
//    return false;
//  }

  void sendErrorMessage([String message = "Can't connect to the internet!"]) {
    print('sendErrorMessage');
    if (_articleList.isEmpty)
      _articleListSubject.addError(BriefingError(message));
  }
}

List<Article> prepareItems(List<List<Article>> result) {
  List<Article> articles = [];
  result.where((list) => list != null).forEach((list) {
    print('===prepareItems_fetchAllChannels list.isEmpty ${list?.isEmpty}');
    articles.addAll(list.where((article) => article.isNew()));
  });
  return articles;
}

class BriefingError extends Error {
  final String message;

  BriefingError(this.message);

  @override
  String toString() {
    return '$message';
  }
}
