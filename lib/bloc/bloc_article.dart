import 'dart:async';

import 'package:briefing/bloc/bloc_provider.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/util/rate_limiter.dart';
import 'package:rxdart/rxdart.dart';

class ArticleListBloc extends BlocBase {
  RateLimiter rateLimit = getRateLimiter;
  final menuSubject = BehaviorSubject.seeded(Menu.local);
  final _articleListSubject = BehaviorSubject<List<Article>>();
  final _articleCategorySubject = BehaviorSubject.seeded('All');
  List<Article> _articleList = <Article>[];

  Stream<List<Article>> get articleListObservable => _articleListSubject.stream;

  Stream<String> get categoryObservable => _articleCategorySubject.stream;

  Sink<String> get categorySink => _articleCategorySubject.sink;

  ArticleListBloc() {
    _articleListSubject.add(_articleList);

    categoryListener();
  }

  categoryListener() {
    categoryObservable.listen((category) async {
      print('categoryObservable.listen($category)');
      await _fetchDataAndPushToStream(category: categories[category]);
    });
  }

  refresh() async {
    print(':::refresh:::');
    var key = await categoryObservable.last;
    await rateLimit.reset(key);
    await _fetchDataAndPushToStream();
  }

  Future<void> _fetchDataAndPushToStream({category}) async {
    await _loadFromDatabase(category: category);
    if (_articleList.isEmpty || await shouldFetch(category)) {
      await _fetchFromNetwork(category: category);
    }
  }

  sendToStream(List<Article> articles) {
    _articleList.clear();
    _articleList.addAll(articles);
    _articleListSubject.sink.add(_articleList);
  }

  @override
  dispose() {
    _articleListSubject.close();
    _articleCategorySubject.close();
    menuSubject.close();
  }

  Future<void> _loadFromDatabase({String category}) async {
    try {
      var localData = await RepositoryArticle.getAllArticleByCategory(category);

      if (localData.isNotEmpty) {
        sendToStream(localData);
      } else {
        sendErrorMessage('No $category articles');
      }
    } catch (e) {
      print('=== _loadFromDb $e');
    }
  }

  Future<void> _fetchFromNetwork({country = 'us', category}) async {
    var articles =
        await RepositoryArticle.getArticleListFromNetwork(country, category);
    if (articles.isNotEmpty) {
      try {
        await RepositoryArticle.insertArticleList(articles, category: category);
      } catch (error) {
        print('DB Error ${error.toString()}');
      }
      await _loadFromDatabase(category: category);
    }
  }

  Future<bool> shouldFetch(key) async {
    return await rateLimit.shouldFetch(key);
  }

  void sendErrorMessage([String message = "Can't connect to the internet!"]) {
    print('sendErrorMessage');
    _articleListSubject.addError(BriefingError(message));
    _articleList.clear();
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
