import 'dart:async';

import 'package:briefing/bloc/bloc_provider.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/model/repository.dart';
import 'package:briefing/util/rate_limiter.dart';
import 'package:rxdart/rxdart.dart';

class ArticleListBloc extends BlocBase {
  RateLimiter rateLimit = getRateLimiter;
  final _articleListSubject = BehaviorSubject<List<Article>>();
  final _articleCategorySubject = BehaviorSubject.seeded('All');
  List<Article> _articleList = <Article>[];

  Stream<List<Article>> get articleListObservable => _articleListSubject.stream;

  Stream<String> get categoryObservable => _articleCategorySubject.stream;

  Sink<String> get categorySink => _articleCategorySubject.sink;

  ArticleListBloc() {
    _articleListSubject.add(_articleList);
    _init();
    categoryListener();
  }

  Future<void> _init() async {
    await _loadFromDb();
    if (shouldFetch('ArticleList')) {
      await _fetchFromNetwork();
    }
  }

  categoryListener() {
    categoryObservable.listen((category) async {
      if (category.toLowerCase().startsWith('all')) {
        _init();
      } else {
        await _loadFromDb(category: category.toLowerCase());
        if (shouldFetch(category)) {
          await _fetchFromNetwork(category: category.toLowerCase());
        }
      }
    });
  }

  refresh() async {
    print(':::refresh:::');
    _articleListSubject.sink.add(_articleList);
    await _fetchFromNetwork();
  }

  pipe(List<Article> articles) {
    print(':::pipe::::');
    _articleList.clear();
    _articleList.addAll(articles);
    _articleListSubject.sink.add(_articleList);
  }

  @override
  dispose() {
    _articleListSubject.close();
    _articleCategorySubject.close();
  }

  Future<void> _loadFromDb({category}) async {
    print('BlocArticle._loadFromDb starts');
    try {
      print('->await RepositoryArticle.getAllArticle starts');
      var localData = category != null
          ? await RepositoryArticle.getAllArticleByCategory(category)
          : await RepositoryArticle.getArticlesFromDatabase();
      print('->await RepositoryArticle.getAllArticle done');
      print('->RepositoryArticle.getAllArticle isEmpty: ${localData.isEmpty}');

      if (localData.isNotEmpty) {
        pipe(localData);
      } else {
        sendErrorMessage('No article in DB');
      }
    } catch (e) {
      print('=== _loadFromDb $e');
    }
    print('BlocArticle._loadFromDb end');
  }

  Future<void> _fetchFromNetwork({country = 'us', category = 'general'}) async {
    print('BlocArticle.fetchFromNetwork start');

    var articles =
        await RepositoryArticle.getArticlesFromNetwork(country, category);
    if (articles.isNotEmpty) {
      try {
        await RepositoryArticle.insertArticleList(articles);
      } catch (error) {
        print('DB Error ${error.statusCode}');
      }
      await _loadFromDb();
    } else {
      sendErrorMessage('No articles');
    }
  }

  bool shouldFetch(key) {
    if (rateLimit.shouldFetch(key)) {
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
