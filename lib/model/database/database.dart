import 'dart:async';
import 'dart:io';

import 'package:briefing/model/article.dart';
import 'package:briefing/model/channel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  init() async {
    await database;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "briefing.db");
    return await openDatabase(path, version: 1, onCreate: populateDb);
  }

  void populateDb(Database db, int version) async {
    var createChannel = "CREATE TABLE channels"
        "(id INTEGER PRIMARY KEY autoincrement,"
        "title TEXT,"
        "link TEXT,"
        "link_rss TEXT,"
        "icon_url TEXT,"
        "last_build_date TEXT,"
        "language TEXT,"
        "favorite BIT,"
        "UNIQUE(link_rss));";

    var createArticle = "CREATE TABLE articles"
        "(id INTEGER PRIMARY KEY autoincrement, "
        "title TEXT,"
        "description TEXT,"
        "link TEXT,"
        "categories TEXT,"
        "guid TEXT,"
        "pub_date TEXT,"
        "author TEXT,"
        "comments TEXT,"
        "url_source TEXT,"
        "content TEXT,"
        "media_thumbnails TEXT,"
        "enclosure TEXT,"
        "bookmarked BIT,"
        "channel_id INTEGER,"
        "FOREIGN KEY(channel_id) REFERENCES channels(id),"
        "UNIQUE(link));";

//    var fk = "ALTER TABLE articles "
//        "add FOREIGN KEY (channel_id) REFERENCES channels(id);";
    //    await db.execute('$fk');

    await db.transaction((txn) async {
      await txn.execute('$createChannel');
      await txn.execute('$createArticle');

      channelList.values.forEach((channel) async {
        var res = await txn.rawInsert(
            "INSERT INTO channels (id,title,link,link_rss,icon_url,"
            "last_build_date,language,favorite)"
            " VALUES (NULL,?,?,?,?,?,?,?)",
            [
              channel.title,
              channel.link,
              channel.linkRss,
              channel.iconUrl,
              channel.lastBuildDate,
              channel.language,
              channel.favorite
            ]);
        print('channel $res inserted');
      });
    });

    databaseLog(fName: 'populateDb', sql: '$createChannel\n$createArticle');
  }

  Future<int> insertChannel({Channel channel, bool raw = true}) async {
    final db = await database;
    var res;
    if (raw) {
      res = await db.rawInsert(
          "INSERT INTO channels (id,title,link,link_rss,icon_url,"
          "last_build_date,language,favorite)"
          " VALUES (NULL,?,?,?,?,?,?,?)",
          [
            channel.title,
            channel.link,
            channel.linkRss,
            channel.iconUrl,
            channel.lastBuildDate,
            channel.language,
            channel.favorite
          ]);
    } else {
      res = await db.insert(
        'channels',
        channel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    return res;
  }

  Future<List<Channel>> getAllFavoriteChannel() async {
    final db = await database;
    var res = await db.query("channels", where: "favorite = ?", whereArgs: [1]);
    return res.isNotEmpty ? res.map((c) => Channel.fromMap(c)).toList() : [];
  }

  Future<List<Channel>> getAllChannel() async {
    final db = await database;
    var res = await db.query("channels");
    return res.isNotEmpty ? res.map((c) => Channel.fromMap(c)).toList() : [];
  }

  Future<Map<String, dynamic>> getModelMap(String table, int id) async {
    final db = await database;
    var results = await db.query(table, where: 'id=?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : Map();
  }

  Future<int> updateChannel(Channel channel) async {
    final db = await database;
    var res = await db.update("channels", channel.toMap(),
        where: "id = ?",
        whereArgs: [channel.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    databaseLog(fName: 'updateChannel', result: res);
    return res;
  }

  Future<int> deleteChannel(int id) async {
    final db = await database;
    var res = db.delete("channels", where: "id = ?", whereArgs: [id]);
    databaseLog(fName: 'updateChannel', result: res);
    return res;
  }

  Future<int> deleteAllChannels() async {
    final db = await database;
    return db.rawDelete("Delete0 from channels");
  }

  Future<int> insertArticle({Article article, bool raw = true}) async {
    final db = await database;
    var res;
    if (raw) {
      res = db.rawInsert(
          "INSERT INTO articles (id,title,description,link,categories,guid,"
          "pub_date,author,comments,url_source,content,media_thumbnails,"
          "enclosure,bookmarked,channel_id)"
          " VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            article.title,
            article.description,
            article.link,
            article.categories.join(';'),
            article.guid,
            article.pubDate,
            article.author,
            article.comments,
            article.source,
            article.content,
            article.mediaThumbnails.join(';'),
            article.enclosure,
            article.bookmarked,
            article.channel.id
          ]);
    } else {
      res = await db.insert(
        'articles',
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return res;
  }

  Future<int> insertArticleList(List<Article> articles) async {
    print('=== DBProvider.insertArticleList ===');
    final db = await database;
    var res;
    await db.transaction((txn) async {
      articles.forEach((article) async {
        res = await txn.insert(
          'articles',
          article.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    });
    return res;
  }

  Future<List<Article>> getAllArticle([bool favoriteChannel = true]) async {
    final db = await database;
    var sql =
        "SELECT a.*, c.title as c_title,c.link as c_link,c.link_rss,c.icon_url,"
        "c.last_build_date,c.language, c.favorite "
        "FROM articles a, channels c "
        "WHERE a.channel_id=c.id ${favoriteChannel ? 'AND c.favorite=1' : ''} LIMIT 20";

    List<Map> res = await db.rawQuery(sql);

    return res.isNotEmpty ? res.map((a) => Article.fromMap(a)).toList() : [];
  }

  Future<Article> getArticle(int id) async {
    final db = await database;
    var res = await db.query("articles", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Article.fromMap(res.first) : null;
  }

  Future<int> updateArticle(Article article) async {
    final db = await database;
    var res = await db.update("articles", article.toMap(),
        where: "id = ?", whereArgs: [article.id]);
    return res;
  }

  Future<int> deleteArticle(int id) async {
    final db = await database;
    return db.delete("articles", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllArticle() async {
    final db = await database;
    return db.rawDelete("DELETE FROM articles");
  }

  Future close() async => db.close();

  static void databaseLog({String fName, String sql, result}) {
    print('=== DBProvider.$fName ===');
    if (sql != null) print(sql);
    if (result != null) print(result);
  }
}

List<Article> prepareArticles(List<Map> list) {
  return list.map((a) => Article.fromMap(a)).toList();
}

//Map c = {
//  'id': a['id'],
//  'title': a['title'],
//  'link': a['link'],
//  'lastBuildDate': a['last_build_date'],
//  'language': a['language'],
//  'linkRss': a['link_rss'],
//  'iconUrl': a['icon_url'],
//  'favorite': a['favorite'] == 1
//};
