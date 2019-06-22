final channelJson = '''
    [
  {
    "title": "Google News - Local",
    "link_rss": "https://news.google.com/rss",
    "icon_url":"https://i1.feedspot.com/4722524.jpg?t=1503317278",
    "favorite":1
  },
  {
    "title":"Google News - Science",
    "link_rss":"https://news.google.com/news/rss/headlines/section/topic/SCIENCE",
    "icon_url":"https://i1.feedspot.com/4722524.jpg?t=1503317278",
    "favorite":1
  },
  {
    "title": "BBC News - Afrique",
    "link_rss": "http://feeds.bbci.co.uk/news/world/africa/rss.xml",
    "favorite":1
  },
  {
    "title": "Jeune Afrique",
    "link_rss": "http://www.jeuneafrique.com/feed/",
    "favorite":1
  },
    {
    "title": "The Washington Times",
    "link_rss": "http://www.washingtontimes.com/rss/headlines/news/world"
  },
  {
    "title": "France 24",
    "link_rss": "http://www.france24.com/en/top-stories/rss",
    "favorite":1
  },
  {
    "title": "Yahoo News",
    "link_rss": "https://www.yahoo.com/news/world/rss"
  },
  {
    "title": "AllAfrica",
    "link_rss":"https://allafrica.com/tools/headlines/rdf/business/headlines.rdf",
    "icon_url": "https://allafrica.com/static/images/structure/aa-logo.png",
    "favorite":1
  },
  {
    "title": "The Guardian",
    "link_rss": "https://www.theguardian.com/world/rss"
  },
  {
    "title": "Africa Intelligence",
    "link_rss": "http://feeds.feedburner.com/AfricaEnergyIntelligence",
    "icon_url": "https://www.africaintelligence.com/img/logo-site.png",
    "favorite":1
  },
  {
    "title": "RFI - Afrique",
    "link_rss": "http://www.rfi.fr/afrique/rss/",
    "favorite":1
  }
]
    ''';
var cha = '''
    
  {
    "title": "Global News",
    "link_rss": "http://globalnews.ca/world/feed"
  },
    {
    "title": "NDTV",
    "link_rss": "http://feeds.feedburner.com/ndtvnews-world-news"
  },
  {
    "title": "RT News",
    "link_rss": "https://www.rt.com/rss/news"
  },
  {
    "title": "The Independent",
    "link_rss": "http://www.independent.co.uk/news/world/rss"
  },
  {
    "title": "National Public Radio",
    "link_rss": "http://www.npr.org/rss/rss.php?id=1004"    
  },
  {
    "title": "Daily Express",
    "link_rss": "http://feeds.feedburner.com/daily-express-world-news",
    "favorite":1
  },
  {
    "title": "CNBC",
    "link_rss": "https://www.cnbc.com/id/100727362/device/rss/rss.html"
  },
  {
    "title": "Daily Mirror",
    "link_rss": "http://www.mirror.co.uk/news/world-news/rss.xml",
    "favorite":1
  },
  {
    "title": "CBC",
    "link_rss": "http://www.cbc.ca/cmlink/rss-world"
  },
  {
    "title": "CTV News",
    "link_rss": "http://www.ctvnews.ca/rss/world/ctvnews-ca-world-public-rss-1.822289"
  },
  {
    "title": "The Washington Times",
    "link_rss": "http://www.washingtontimes.com/rss/headlines/news/world"
  },
  {
    "title": "France 24",
    "link_rss": "http://www.france24.com/en/top-stories/rss"
  },
  {
    "title": "Daily Telegraph",
    "link_rss": "http://www.dailytelegraph.com.au/news/world/rss"
  },
  {
    "title": "CBN News",
    "link_rss": "http://www1.cbn.com/cbnnews/world/feed"
  },
  {
    "title": "Today Online",
    "link_rss": "http://www.todayonline.com/feed/world"
  },
  {
    "title": "Christian Science Monitor",
    "link_rss": "http://rss.csmonitor.com/feeds/world"
  },
  {
    "title": "Public Radio International",
    "link_rss": "https://www.pri.org/stories/feed/everything"
  },
    {
    "title": "Reuters",
    "link_rss": "http://feeds.reuters.com/Reuters/worldNews",
    "favorite":1
  },
    ''';

class Channel {
  int id;
  String title;
  String link;
  String linkRss;
  String iconUrl;
  String lastBuildDate;
  String language;
  bool favorite;

  Channel(
      {this.id,
      this.title,
      this.link,
      this.lastBuildDate,
      this.language,
      this.linkRss,
      this.iconUrl,
      this.favorite});

  factory Channel.fromMap(Map<String, dynamic> data) {
    return Channel(
        id: data['id'],
        title: data['title'],
        link: data['link'],
        lastBuildDate: data['last_build_date'],
        language: data['language'],
        linkRss: data['link_rss'],
        iconUrl: data['icon_url'],
        favorite: data['favorite'] == 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'link': link,
      'last_build_date': lastBuildDate,
      'language': language,
      'link_rss': linkRss,
      'icon_url': iconUrl,
      'favorite': favorite,
    };
  }

  @override
  String toString() {
    return 'Channel{title: $title, favorite: $favorite}';
  }
}
