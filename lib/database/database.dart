import 'dart:async';
import 'dart:io';

import 'package:briefing/model/article.dart';
import 'package:briefing/model/channel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final String className = 'DBProvider';
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "briefing.db");
    return await openDatabase(path, version: 1, onCreate: populateDb);
  }

  void populateDb(Database db, int version) async {
    print('++++++$className ***populateDb***');
    var createChannel = "CREATE TABLE channels"
        "(id INTEGER PRIMARY KEY autoincrement,"
        "title TEXT,"
        "link TEXT,"
        "link_rss TEXT,"
        "icon_url TEXT,"
        "last_build_date TEXT,"
        "language TEXT,"
        "starred BIT);";

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
        "channel_id INTEGER REFERENCES channels(id));";

//    var fk = "ALTER TABLE articles "
//        "add FOREIGN KEY (channel_id) REFERENCES channels(id);";

    await db.execute('$createChannel');
    await db.execute('$createArticle');
    channelList.values.forEach((channel) async {
      var res = await insertChannel(channel);
      print('channel $res inserted');
    });
//    await db.execute('$fk');
  }

  Future<int> insertChannelMap(Channel channel) async {
    final db = await database;
    return await db.insert(
      'channels',
      channel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertChannel(Channel channel) async {
    print('$className ***insertChannel***');
    final db = await database;
    return await db.rawInsert(
        "INSERT INTO channels (id,title,link,link_rss,icon_url,"
        "last_build_date,language,starred)"
        " VALUES (NULL,?,?,?,?,?,?,?)",
        [
          channel.title,
          channel.link,
          channel.linkRss,
          channel.iconUrl,
          channel.lastBuildDate,
          channel.language,
          channel.starred
        ]);
  }

  Future<int> insertArticleMap(Article article) async {
    print('++++++$className insertArticleMap');
    final db = await database;
    return await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertArticle(Article article) async {
    final db = await database;

    return await db.rawInsert(
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
  }

  Future<List<Article>> getAllArticle() async {
    print('++++++$className getAllArticles');
    final db = await database;
    var res = await db.query("articles");
    List<Article> list;
    if (res.isNotEmpty) {
      print('results length ${res.length}');
      final futures = res.map((m) async {
        Map<String, dynamic> map = Map<String, dynamic>.from(m);
        var channelMap = await getChannelMapById(m['channel_id']);
        map.update('channel_id', (val) => channelMap);
        return Article.fromMap(map);
      }).toList();
      list = await Future.wait(futures);
    } else {
      list = [];
    }
    return list;
  }

  Future<Article> getArticleById(int id) async {
    final db = await database;
    var res = await db.query("articles", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Article.fromMap(res.first) : null;
  }

  Future<List<Article>> getAllArticlesByChannel(Channel channel) async {
    final db = await database;
    var res = await db
        .query("articles", where: "channel_id = ?", whereArgs: [channel.id]);
    List<Article> list =
        res.isNotEmpty ? res.map((c) => Article.fromMap(c)).toList() : [];
    return list;
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

  Future<int> deleteAllArticles() async {
    final db = await database;
    return db.rawDelete("Delete from articles");
  }

  Future<List<Channel>> getAllChannel() async {
    final db = await database;
    var res = await db.query("channels");
    List<Channel> list =
        res.isNotEmpty ? res.map((c) => Channel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Channel>> getAllStarredChannel() async {
    final db = await database;
    var res = await db.query("channels", where: "starred = ?", whereArgs: [1]);
    List<Channel> list =
        res.isNotEmpty ? res.map((c) => Channel.fromMap(c)).toList() : [];
    return list;
  }

  Future<Channel> getChannelByLink(String linkRss) async {
    final db = await database;
    var results = await db.query('channels',
        columns: ['id'], where: 'link_rss=?', whereArgs: [linkRss]);
    return results.isNotEmpty ? Channel.fromMap(results.first) : null;
  }

  Future<Channel> getChannelById(int id) async {
    final db = await database;
    var results = await db.query('channels', where: 'id=?', whereArgs: [id]);
    return results.isNotEmpty ? Channel.fromMap(results.first) : null;
  }

  Future<Map<String, dynamic>> getChannelMapById(int id) async {
    final db = await database;
    var results = await db.query('channels', where: 'id=?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : Map();
  }

  Future<int> updateChannel(Channel channel) async {
    final db = await database;
    var res = await db.update("channels", channel.toMap(),
        where: "id = ?",
        whereArgs: [channel.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<int> deleteChannel(int id) async {
    final db = await database;
    return db.delete("channels", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllChannels() async {
    final db = await database;
    return db.rawDelete("Delete0 from channels");
  }

  Future close() async => db.close();
}
