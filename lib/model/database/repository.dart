import 'package:briefing/model/article.dart';
import 'package:briefing/model/channel.dart';
import 'package:briefing/model/database/database.dart';

class RepositoryArticle {
  static Future<void> insertArticle({Article article, bool raw = true}) async {
    var res = await DBProvider.db.insertArticle(article: article, raw: raw);
    DBProvider.databaseLog(fName: 'insertArticle', result: res);
  }

  static Future<void> insertArticleList(List<Article> articles) async {
    var res = await DBProvider.db.insertArticleList(articles);
    DBProvider.databaseLog(fName: 'insertArticleList', result: res);
  }

  static Future<List<Article>> getAllArticle(
      [bool favoriteChannel = true]) async {
    var list = await DBProvider.db.getAllArticle(favoriteChannel);
    DBProvider.databaseLog(fName: 'getAllArticle', result: list);
    return list;
  }
}

class RepositoryChannel {
  static Future<List<Channel>> getAllChannel() async {
    var list = await DBProvider.db.getAllChannel();
    DBProvider.databaseLog(fName: 'getAllChannel', result: list);
    return list;
  }

  static Future<List<Channel>> getAllFavoriteChannel() async {
    var list = await DBProvider.db.getAllFavoriteChannel();
    DBProvider.databaseLog(fName: 'getAllFavoriteChannel', result: list);
    return list;
  }

  static Future<void> insertChannel({Channel channel, bool raw = true}) async {
    var res = await DBProvider.db.insertChannel(channel: channel, raw: raw);
    DBProvider.databaseLog(fName: 'insertChannel', result: res);
  }

  static Future<void> updateChannel(Channel channel) async {
    var res = await DBProvider.db.updateChannel(channel);
    DBProvider.databaseLog(fName: 'updateChannel', result: res);
  }
}
