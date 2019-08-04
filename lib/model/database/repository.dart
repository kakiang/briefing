import 'package:briefing/model/article.dart';
import 'package:briefing/model/database/database.dart';

class RepositoryArticle {
  static Future<void> insertArticle(Article article) async {
    return await DBProvider.db.insertArticle(article);
  }

  static Future<void> insertArticleList(List<Article> articles) async {
    return await DBProvider.db.insertArticleList(articles);
  }

  static Future<List<Article>> getAllArticle() async {
    return await DBProvider.db.getAllArticle();
  }
}
