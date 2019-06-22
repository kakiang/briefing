import 'package:briefing/model/article.dart';
import 'package:briefing/model/channel.dart';
import 'package:briefing/model/database/database.dart';

class RepositoryArticle {
  static Future<void> insertArticle(Article article) async {
    return await DBProvider.db.insertArticle(article);
//    DBProvider.databaseLog(fName: 'insertArticle', result: res);
  }

  static Future<void> insertArticleList(List<Article> articles) async {
    return await DBProvider.db.insertArticleList(articles);
//    DBProvider.databaseLog(fName: 'insertArticleList', result: res);
  }

  static Future<List<Article>> getAllArticle(
      [bool favoriteChannel = true]) async {
    return await DBProvider.db.getAllArticle(favoriteChannel);
//    DBProvider.databaseLog(fName: 'getAllArticle', result: list);
//    return list;
  }
}

class RepositoryChannel {
  static Future<List<Channel>> getAllChannel() async {
    return await DBProvider.db.getAllChannel();
//    DBProvider.databaseLog(fName: 'getAllChannel', result: list);
//    return list;
  }

  static Future<List<Channel>> getAllFavoriteChannel() async {
    return await DBProvider.db.getAllFavoriteChannel();
//    DBProvider.databaseLog(fName: 'getAllFavoriteChannel', result: list);
//    return list;
  }

  static Future<void> insertChannel(Channel channel) async {
    return await DBProvider.db.insertChannel(channel);
//    DBProvider.databaseLog(fName: 'insertChannel', result: res);
  }

  static Future<void> updateChannel(Channel channel) async {
    return await DBProvider.db.updateChannel(channel);
//    DBProvider.databaseLog(fName: 'updateChannel', result: res);
  }
}
