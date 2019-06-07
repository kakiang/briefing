import 'dart:async';

import 'package:briefing/model/article_rss.dart';
import 'package:briefing/model/news_agency.dart';
import 'package:rxdart/rxdart.dart';

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class ArticleListBloc {
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(true);

  final _rssItemListSubject = PublishSubject<List<ArticleRss>>();
  List<ArticleRss> _rssItemList = <ArticleRss>[];

  ArticleListBloc() {
    print("ArticleListBloc");
    _rssItemListSubject.add(_rssItemList);
    _updateRssItemList();
  }

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  Stream<List<ArticleRss>> get rssItemList => _rssItemListSubject.stream;

  dispose() {
    _isLoadingSubject.close();
    _rssItemListSubject.close();
  }

  _updateRssItemList() async {
    print("_updateRssItemList");
    newsAgencyList.values
        .where((agency) => agency.starred)
        .forEach((agency) async {
      print("${agency.toString()}");
      var tmp = await _fetchRssItem(agency.rss);
      _rssItemList.addAll(tmp);
      _rssItemListSubject.add(_rssItemList);
      print("$_rssItemList");
    });
  }

  Future<List<ArticleRss>> _fetchRssItem(String url) async {
    print("_fetchRssItem");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var channel = RssFeed.parse(response.body);
      List<RssItem> items = channel.items;
      List<ArticleRss> articles = [];

      items.forEach((f) {
        articles
            .add(ArticleRss.fromParent(f, channel.title, channel.image?.url));
      });
      print('channel.title==: ${channel.title.toString()}');
      return articles;
      // return compute(prepareItems, response.body);
    } else {
      print('Http Error ${response.statusCode} $url');
      return [];
    }
  }

  Future<List<ArticleRss>> _fetchArticleList() async {
    var newsAgencyListStarred = newsAgencyList.values.where((ag) => ag.starred);
    var allFutureArticleList =
        newsAgencyListStarred.map((ag) => _fetchRssItem(ag.rss));
    final allArticleRssList = await Future.wait(allFutureArticleList);
    print('Future.wait length: ${allArticleRssList.length}');
    List<ArticleRss> articleRssList = <ArticleRss>[];
    allArticleRssList.forEach((list) {
      print('list.isEmpty ${list.isEmpty}');
      articleRssList.addAll(list.where((item) => item.isNew()));
    });
    print('articleRssList length: ${articleRssList.length}');
    return articleRssList;
  }

  List<ArticleRss> prepareItems(String responseBody) {
    var channel = RssFeed.parse(responseBody);
    List<RssItem> items = channel.items;
    List<ArticleRss> articles = [];

    items.forEach((f) {
      articles.add(ArticleRss.fromParent(f, channel.title, channel.image?.url));
    });
    return articles;
  }
}
