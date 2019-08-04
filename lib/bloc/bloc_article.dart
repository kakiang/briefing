import 'dart:async';
import 'dart:convert';

import 'package:briefing/bloc/bloc_provider.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/model/database/repository.dart';
import 'package:briefing/util/rate_limiter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

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

    try {
      final response = await http.get(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=11cd66d3a6994c108e7fb7d92cee5e12');
      if (response.statusCode == 200) {
        var articles = await compute(parseArticlesList, response.body);
        if (articles.isNotEmpty) {
          try {
            await saveResult(articles);
          } catch (error) {
            print('DB Error ${error.statusCode}');
          }
          await _loadFromDb();
        } else {
          sendErrorMessage('No articles');
        }
      } else {
        print('Http Error ${response.statusCode}');
      }
    } catch (e) {
      print('=== _fetchFromNetwork Error ${e.toString()}');
    }
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

  void sendErrorMessage([String message = "Can't connect to the internet!"]) {
    print('sendErrorMessage');
    if (_articleList.isEmpty)
      _articleListSubject.addError(BriefingError(message));
  }
}

class BriefingError extends Error {
  final String message;

  BriefingError(this.message);

  @override
  String toString() {
    return '$message';
  }
}

List<Article> parseArticlesList(String responseBody) {
  final parsed = json.decode(responseBody);
  if (parsed['totalResults'] > 0) {
    var articles = List<Article>.from(parsed['articles']
        .map((article) => Article.fromMap(article, network: true)));
    return articles;
  }
  return [];
}
