import 'package:briefing/model/article.dart';
import 'package:briefing/service/api_service.dart';
import 'package:briefing/service/database.dart';

class RepositoryCommon {
  static close() {
    DatabaseService.db.close();
  }

  static Future<int> getValue(String id) async {
    return await DatabaseService.db.getValue(id);
  }

  static Future<int> insertMetadata(String id) async {
    return await DatabaseService.db.insertMetadata(id);
  }

  static Future deleteMetadata(String id) async {
    return await DatabaseService.db.deleteMetadata(id);
  }
}

class RepositoryArticle {
  //DatabaseService
  static Future<void> insertArticle(Article article) async {
    return await DatabaseService.db.insertArticle(article);
  }

  static Future<void> insertArticleList(List<Article> articles,
      {category}) async {
    return await DatabaseService.db
        .insertArticleList(articles, category: category);
  }

  static Future<List<Article>> getBookmarkedArticles() async {
    return await DatabaseService.db.getBookmarkedArticles();
  }

  static Future<List<Article>> _getArticleFromDatabase() async {
    return await DatabaseService.db.getAllArticle();
  }

  static Future<List<Article>> getAllArticleByCategory(String category) async {
    if (category != null && category.isNotEmpty) {
      return await DatabaseService.db.getAllArticleByCategory(category);
    }
    return await _getArticleFromDatabase();
  }

  //ApiService
  static Future<List<Article>> getArticleListFromNetwork(
      String country, String category) async {
    if (category != null && category == 'local') {
      return getLocalNewsFromNetwork();
    }
    return ApiService.getArticlesFromNetwork(country, category);
  }

  static Future<List<Article>> getLocalNewsFromNetwork() async {
    return ApiService.getLocalNewsFromNetwork();
  }
}
