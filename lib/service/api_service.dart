import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:briefing/model/article.dart';
import 'package:xml/xml.dart';

const base_url = 'https://newsapi.org/v2';
const api_key = '11cd66d3a6994c108e7fb7d92cee5e12';
const local_news_url = 'https://news.google.com/rss';

String getUrl(String country, String category) {
  var url = '$base_url/top-headlines?page=1';
  if (country != null && country.isNotEmpty) {
    url += '&country=$country';
  }
  if (category != null && category.isNotEmpty) {
    url += '&category=$category';
  }
  return url += '&apiKey=$api_key';
}

class ApiService {
  static Future<List<Article>> getArticlesFromNetwork(country, category) async {
    var articles = [];
    try {
      final response = await http.get(getUrl(country, category));
      if (response.statusCode == 200) {
        articles = await compute(parseArticles, response.body);
      }
    } catch (e) {
      print('=== API::getArticlesFromNetwork Error ${e.toString()}');
    }
    return articles;
  }

  static Future<List<Article>> getLocalNewsFromNetwork() async {
    var articles = [];
    try {
      final response = await http.get(local_news_url);
      if (response.statusCode == 200) {
        articles = await compute(parseArticlesXml, response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return articles;
  }
}

List<Article> parseArticles(String responseBody) {
  var articles = [];
  final parsed = json.decode(responseBody);
  if (parsed['totalResults'] > 0) {
    articles = List<Article>.from(parsed['articles']
        .map((article) => Article.fromMap(article, network: true)));
  }
  return articles;
}

List<Article> parseArticlesXml(String responseBody) {
  var document = xml.parse(responseBody);

  var channelElement = document.findAllElements("channel")?.first;
  var source = findElementOrNull(channelElement, 'title')?.text;

  return channelElement.findAllElements('item').map((element) {
    var title = findElementOrNull(element, 'title')?.text;
    var description = findElementOrNull(element, "description")?.text;
    var source2 = element.findElements("source").first.getAttribute('url');
    var link = findElementOrNull(element, "link")?.text;
//    var category =
//        element.findElements("category").first.getAttribute('domain');
    var pubDate = findElementOrNull(element, "pubDate")?.text;
    var author = findElementOrNull(element, "author")?.text;
    var image =
        findElementOrNull(element, "enclosure")?.getAttribute("url") ?? null;

    return Article(
        title: title,
        category: 'local',
        author: author,
        content: description,
        imageUrl: image,
        publishedAt: pubDate,
        url: link,
        source: source2?.replaceAll('https://www.', '') ?? '',
        description: description);
  }).toList();
}

XmlElement findElementOrNull(XmlElement element, String name) {
  try {
    return element.findAllElements(name).first;
  } on StateError {
    return null;
  }
}
