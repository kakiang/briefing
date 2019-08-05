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
          "url TEXT,"
          "publishedAt TEXT,"
          "author TEXT,"
          "source TEXT,"
          "content TEXT,"
          "urlToImage TEXT,"
          "category TEXT,"
          "bookmarked BIT,"
          "UNIQUE(url));";

      await db.transaction((txn) async {
        await txn.execute('$articleTable');

        print('DBProvider.await populateDb end (txn)');
      });
    });
  }

  Future<int> insertArticle(Article article) async {
    final db = await database;
    var res;
    res = await db.insert('articles', article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<int> insertArticleList(List<Article> articles, {category}) async {
    print('=== DBProvider.insertArticleList start ===');
    final db = await database;
    var res;
    await db.transaction((txn) async {
      articles.forEach((article) async {
        res = await txn.insert(
          'articles',
          article.toMap(category: category),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    });
    print('article $res inserted');
    return res;
  }

  Future<List<Article>> getAllArticle() async {
    final db = await database;
    List<Map> res = await db.query("articles", orderBy: "publishedAt DESC");
    return res.isNotEmpty ? await compute(prepareArticles, res) : [];
  }

  Future<List<Article>> getAllArticleByCategory(category) async {
    final db = await database;
    List<Map> res = await db.query("articles",
        where: "category = ?",
        orderBy: "publishedAt DESC",
        whereArgs: [category]);
    return res.isNotEmpty ? await compute(prepareArticles, res) : [];
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
}

List<Article> prepareArticles(List<Map> list) {
  return list.map((a) => Article.fromMap(a)).toList();
}
