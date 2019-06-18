import 'dart:async';

import 'package:briefing/model/article.dart';
import 'package:briefing/model/channel.dart';
import 'package:briefing/model/database/repository.dart';
import 'package:briefing/util/rate_limiter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:webfeed/webfeed.dart';

class ArticleListBloc {
  RateLimiter<String> rateLimit = RateLimiter(2);
  final _articleListSubject = BehaviorSubject<List<Article>>();
//  HashSet<Article> _articleList = HashSet();
  List<Article> _articleList = <Article>[];

  ArticleListBloc() {
    _articleListSubject.add(_articleList);
    _loadFromDb();

    if (rateLimit.shouldFetch('ArticleList')) {
      _fetchFromNetwork();
    }
  }

  Stream<List<Article>> get articleListObservable => _articleListSubject.stream;

  dispose() {
    _articleListSubject.close();
  }

  Future<void> _loadFromDb() async {
    try {
      var localData = await RepositoryArticle.getAllArticle();
      print('localData isEmpty: ${localData.isEmpty}');
      if (localData.isNotEmpty) {
        _articleList.clear();
        _articleList.addAll(localData);
        _articleListSubject.sink.add(_articleList);
      }
    } catch (e) {
      print('=== _loadFromDb $e');
    }
  }

  Future<void> _fetchFromNetwork() async {
    List<Channel> channels = await RepositoryChannel.getAllFavoriteChannel();

    if (channels.isNotEmpty) {
      List<Article> articles = await _fetchAllChannels(channels);

      if (articles.isNotEmpty) {
//        _articleList.addAll(articles);
//        _articleListSubject.add(_articleList);
        await saveResult(articles);
        await _loadFromDb();
      } else {
        sendErrorMessage();
      }
    }
  }

  Future<List<Article>> _fetchAllChannels(List<Channel> channels) async {
    List<Article> articles = [];
    try {
      var futures = channels.map((channel) => _fetchRssFeed(channel));
      final result = await Future.wait(futures);
      print('_fetchAllChannels result.isEmpty ${result?.isEmpty}');
      if (result != null && result.length > 0) {
        articles = await compute(prepareItems, result);
      }
    } catch (e) {
      print('=== _fetchAllChannels Error $e');
      sendErrorMessage();
    }
    print('Future.wait length: ${articles?.length}');
    return articles;
  }

  Future<List<Article>> _fetchRssFeed(Channel channel) async {
    print('=== _fetchRssFeed === ${channel.link} ${channel.lastBuildDate} ===');
    List<Article> articles = [];

    try {
      final response = await http.get(channel.linkRss);
      if (response.statusCode == 200) {
        var rssFeed = RssFeed.parse(response.body);

        List<RssItem> items = rssFeed.items;
        items.forEach((rssItem) {
          articles.add(Article.fromRssItem(rssItem, channel));
        });
      } else {
        print('Http Error ${response.statusCode} ${channel.linkRss}');
      }
    } catch (e) {
      print('=== _fetchRssFeed Error $e');
    }
    return articles;
  }

  saveResult(List<Article> articles) async {
    await RepositoryArticle.insertArticleList(articles);
  }

  void sendErrorMessage() {
    print('!!!send error');
    if (_articleList.isEmpty)
      _articleListSubject
          .addError(BriefingError("Can't connect to the internet!"));
  }
}

List<Article> prepareItems(List<List<Article>> result) {
  List<Article> articles = [];
  result.forEach((list) {
    print('===prepareItems_fetchAllChannels list.isEmpty ${list.isEmpty}');
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
