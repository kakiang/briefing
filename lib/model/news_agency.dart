final newsAgencyList = {
  "Africa Intelligence": NewsAgency(
      name: "Africa Intelligence",
      url: "https://www.africaintelligence.com/",
      rss: "http://feeds.feedburner.com/AfricaEnergyIntelligence",
      iconUrl: 'https://www.africaintelligence.com/img/logo-site.png',
      starred: false),
  "AllAfrica.com": NewsAgency(
      name: "AllAfrica.com",
      url: "https://allafrica.com",
      rss: "https://allafrica.com/tools/headlines/rdf/business/headlines.rdf",
      iconUrl: 'https://allafrica.com/static/images/structure/aa-logo.png',
      starred: false),
  "BBC World News": NewsAgency(
      name: "BBC World News",
      url: "bbc.co.uk",
      rss: "http://feeds.bbci.co.uk/news/world/rss.xml",
      iconUrl: 'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif',
      starred: true),
  "BBC technology news": NewsAgency(
      name: "BBC technology news",
      url: "bbc.co.uk",
      rss: 'http://feeds.bbci.co.uk/news/technology/rss.xml',
      iconUrl: 'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif',
      starred: false),
  "Africanews": NewsAgency(
      name: "Africanews",
      url: "http://www.africanews.com/",
      rss: "http://www.africanews.com/feed/rss",
      // iconUrl:
      //     'https://www.businessforafricaforum.com/wp-content/uploads/2017/11/Africanews_logo_coul_370x270-400x300.png',
      iconUrl: 'https://allafrica.com/static/images/structure/aa-logo.png',
      starred: true),
};

class NewsAgency {
  final int id;
  final String name;
  final String url;
  final String rss;
  final String iconUrl;
  bool starred;

  NewsAgency(
      {this.id, this.name, this.url, this.rss, this.iconUrl, this.starred});
}
