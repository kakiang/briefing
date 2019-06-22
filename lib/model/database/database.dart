import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:briefing/model/article.dart';
import 'package:briefing/model/channel.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:webfeed/webfeed.dart';

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

  Future<Database> initDB() async {
    print('DBProvider.initDB() start');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "briefing.db");
    var db = await openDatabase(path, version: 1, onCreate: populateDb);
    print('DBProvider.initDB() end');
    return db;
  }

  populateDb(Database db, int version) async {
    await Future(() async {
      print('  DBProvider.await populateDb start');
      var channelTable = "CREATE TABLE channels"
          "(id INTEGER PRIMARY KEY autoincrement,"
          "title TEXT,"
          "link TEXT,"
          "link_rss TEXT,"
          "icon_url TEXT,"
          "last_build_date TEXT,"
          "language TEXT,"
          "favorite BIT,"
          "UNIQUE(link_rss));";

      var articleTable = "CREATE TABLE articles"
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
          "media_url TEXT,"
          "content TEXT,"
          "media_thumbnails TEXT,"
          "enclosure TEXT,"
          "bookmarked BIT,"
          "channel_id INTEGER,"
          "FOREIGN KEY(channel_id) REFERENCES channels(id),"
          "UNIQUE(link));";

      await db.transaction((txn) async {
        await txn.execute('$channelTable');
        await txn.execute('$articleTable');

        print('DBProvider.await populateDb end (txn)');
      });
      await initChannels(db);
    });
  }

  initChannels(Database db) async {
    List rss = jsonDecode(channelJson);

    print('DBProvider.initChannels start [rss.length ${rss.length}]');
    for (int i = 0; i < rss.length; i++) {
      Channel channel = Channel.fromMap(rss[i]);
//    }
//    rss.forEach((f) async {
//      Channel channel = Channel.fromMap(f);
      print('   onCreate channel $channel');

      try {
        final response = await http.get(channel.linkRss);
        if (response.statusCode == 200) {
          var rssFeed = RssFeed.parse(response.body);

          channel.link = rssFeed.link;
          channel.lastBuildDate = rssFeed.lastBuildDate;
          channel.language = rssFeed.language;
          channel.iconUrl = rssFeed.image?.url ?? channel.iconUrl;
          if (channel.link != null) {
            await db.transaction((txn) async {
              var cid = await txn.rawInsert(
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
              print('   channel $cid $channel inserted');
              var channelMap = await txn.query("channels",
                  where: "id = ? and favorite=1", whereArgs: [cid]);
              Channel channelById = channelMap.isNotEmpty
                  ? Channel.fromMap(channelMap.first)
                  : null;
              if (channelById != null) {
                List<RssItem> items = rssFeed.items;

                items.forEach((rssItem) async {
                  Article article = Article.fromRssItem(rssItem, channelById);
                  if (article.isNew()) {
                    var aid = await txn.insert(
                      'articles',
                      article.toMap(),
                      conflictAlgorithm: ConflictAlgorithm.replace,
                    );
                    print('   article $aid inserted');
                  }
                });
              }
            });
          }
        }
      } catch (e) {
        print('initchannele Error $e');
      }
    }
    print('DBProvider.initChannels end');
  }

  Future<int> insertChannel(Channel channel) async {
    final db = await database;
    var res;
    res = await db.insert(
      'channels',
      channel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return res;
  }

  Future<List<Channel>> getAllFavoriteChannel() async {
    final db = await database;
    var res = await db.query("channels", where: "favorite = ?", whereArgs: [1]);
    return res.isNotEmpty ? res.map((c) => Channel.fromMap(c)).toList() : [];
  }

  Future<Channel> getChannelBy(int id) async {
    final db = await database;
    var res = await db.query("channels", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Channel.fromMap(res.first) : null;
  }

  Future<List<Channel>> getAllChannel() async {
    final db = await database;
    var res = await db.query("channels", orderBy: "favorite DESC");
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
    return res;
  }

  Future<int> deleteChannel(int id) async {
    final db = await database;
    var res = db.delete("channels", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllChannels() async {
    final db = await database;
    return db.rawDelete("Delete from channels");
  }

  Future<int> insertArticle(Article article) async {
    final db = await database;
    var res;
    res = await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res;
  }

  Future<int> insertArticleList(List<Article> articles) async {
    print('=== DBProvider.insertArticleList start ===');
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
    print('article $res inserted');
    return res;
  }

  Future<List<Article>> getAllArticle([bool favoriteChannel = true]) async {
    print('DBProvider.getAllArticle start');
    final db = await database;
    var sql =
        "SELECT a.*, c.title as c_title, c.link as c_link, c.link_rss, c.icon_url,"
        "c.last_build_date,c.language, c.favorite "
        "FROM articles a, channels c "
        "WHERE a.channel_id=c.id ${favoriteChannel ? 'AND c.favorite=1' : ''} "
        "ORDER BY a.pub_date DESC";
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
    print('DBProvider.deleteAllArticle start');
    final db = await database;
    return db.rawDelete("DELETE FROM articles");
  }

  Future close() async => db.close();

  static void databaseLog({String fName, String sql, result}) {
    print('Log::: DBProvider.$fName end');
    if (sql != null) print('sql: $sql');
    if (result != null) print('result $result');
  }
}

List<Article> prepareArticles(List<Map> list) {
  return list.map((a) => Article.fromMap(a)).toList();
}
