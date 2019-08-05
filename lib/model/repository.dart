import 'dart:convert';

import 'package:briefing/model/article.dart';
import 'package:briefing/model/database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const base_url = 'https://newsapi.org/v2';
const api_key = '11cd66d3a6994c108e7fb7d92cee5e12';

String getUrl(country, category) =>
    '$base_url/top-headlines?country=$country&category=$category&page=1&apiKey=$api_key';

class RepositoryArticle {
  static Future<void> insertArticle(Article article) async {
    return await DBProvider.db.insertArticle(article);
  }

  static Future<void> insertArticleList(List<Article> articles,
      {category}) async {
    return await DBProvider.db.insertArticleList(articles, category: category);
  }

  static Future<List<Article>> getArticlesFromDatabase() async {
    return await DBProvider.db.getAllArticle();
  }

  static Future<List<Article>> getAllArticleByCategory(category) async {
    return await DBProvider.db.getAllArticleByCategory(category);
  }

  static Future<List<Article>> getArticlesFromNetwork(country, category) async {
    print('BlocArticle.fetchFromNetwork start');
    var articles = [];
    try {
      final response = await http.get(getUrl(country, category));
      if (response.statusCode == 200) {
        articles = await compute(parseArticlesList, response.body);
      }
    } catch (e) {
      print('=== _fetchFromNetwork Error ${e.toString()}');
    }
    return articles;
  }
}

List<Article> parseArticlesList(String responseBody) {
  final parsed = json.decode(responseBody);
  if (parsed['totalResults'] > 0) {
    var articles = List<Article>.from(parsed['articles']
        .map((article) => Article.fromMap(article, network: true)));
    return articles;
  }
  return [];
}
