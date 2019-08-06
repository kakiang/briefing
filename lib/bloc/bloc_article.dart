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
    categoryListener();
  }

  Future<void> _fetchDataAndPushToStream({category}) async {
    await _loadFromDatabase(category: category);
    if (await shouldFetch(category)) {
      await _fetchFromNetwork(category: category);
    }
  }

  categoryListener() {
    categoryObservable.listen((category) async {
      await _fetchDataAndPushToStream(category: categories[category]);
    });
  }

  refresh() async {
    print(':::refresh:::');
    await _fetchDataAndPushToStream();
  }

  sendToStream(List<Article> articles) {
    print(':::sendToStream::::');
    _articleList.clear();
    _articleList.addAll(articles);
    _articleListSubject.sink.add(_articleList);
  }

  @override
  dispose() {
    _articleListSubject.close();
    _articleCategorySubject.close();
  }

  Future<void> _loadFromDatabase({String category}) async {
    print('BlocArticle._loadFromDb starts');
    try {
      print('->await RepositoryArticle.getAllArticle starts');
      var localData = category != null || category.isEmpty
          ? await RepositoryArticle.getAllArticleByCategory(category)
          : await RepositoryArticle.getArticleFromDatabase();
      print('->await RepositoryArticle.getAllArticle done');
      print('->RepositoryArticle.getAllArticle isEmpty: ${localData.isEmpty}');

      if (localData.isNotEmpty) {
        sendToStream(localData);
      } else {
        sendErrorMessage('No article');
      }
    } catch (e) {
      print('=== _loadFromDb $e');
    }
    print('BlocArticle._loadFromDb end');
  }

  Future<void> _fetchFromNetwork({country = 'us', category}) async {
    print('BlocArticle.fetchFromNetwork start');

    var articles =
        await RepositoryArticle.getArticlesFromNetwork(country, category);
    if (articles.isNotEmpty) {
      try {
        await RepositoryArticle.insertArticleList(articles, category: category);
      } catch (error) {
        print('DB Error ${error.toString()}');
      }
      await _loadFromDatabase(category: category);
    } else {
      sendErrorMessage('No articles');
    }
  }

  Future<bool> shouldFetch(key) async {
    return await rateLimit.shouldFetch(key);
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
