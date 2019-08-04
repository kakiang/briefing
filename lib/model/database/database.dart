import 'dart:async';
import 'dart:io';

import 'package:briefing/model/article.dart';
import 'package:flutter/foundation.dart';
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

      var articleTable = "CREATE TABLE articles"
          "(id INTEGER PRIMARY KEY autoincrement, "
          "title TEXT,"
          "description TEXT,"
          "link TEXT,"
          "publishedAt TEXT,"
          "author TEXT,"
          "source TEXT,"
          "content TEXT,"
          "urlToImage TEXT,"
          "bookmarked BIT,"
          "UNIQUE(link));";

      await db.transaction((txn) async {
        await txn.execute('$articleTable');

        print('DBProvider.await populateDb end (txn)');
      });
    });
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

//  Future<List<Article>> getAllArticle([bool favoriteChannel = true]) async {
//    print('DBProvider.getAllArticle start');
//    final db = await database;
//    var sql =
//        "SELECT a.*, c.title as c_title, c.link as c_link, c.link_rss, c.icon_url,"
//        "c.last_build_date,c.language, c.favorite "
//        "FROM articles a, channels c "
//        "WHERE a.channel_id=c.id ${favoriteChannel ? 'AND c.favorite=1' : ''} "
//        "ORDER BY a.pub_date DESC";
//    List<Map> res = await db.rawQuery(sql);
//    return res.isNotEmpty ? res.map((a) => Article.fromMap(a)).toList() : [];
//  }

  Future<List<Article>> getAllArticle() async {
    final db = await database;
    List<Map> res = await db.query("articles", orderBy: "publishedAt DESC");
    return res.isNotEmpty ? await compute(prepareArticles, res) : [];
//    res.map((a) => Article.fromMap(a)).toList()
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
