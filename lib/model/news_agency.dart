final newsAgencyList = [
  NewsAgency(
      name: "African News Agency",
      url: "https://www.africannewsagency.com/",
      iconUrl: 'https://www.enca.com/sites/default/files/3600130208.jpg',
      starred: true),
  NewsAgency(
      name: "AllAfrica.com",
      url: "https://allafrica.com",
      iconUrl: 'https://allafrica.com/static/images/structure/aa-logo.png',
      starred: true),
  NewsAgency(
      name: "BBC News",
      url: "bbc.co.uk",
      iconUrl: 'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif',
      starred: true),
  NewsAgency(
      name: "VOA News",
      url: "https://www.voanews.com",
      iconUrl:
          'https://www.voanews.com/Content/responsive/VOA/en-US/img/logo.png',
      starred: true),
  NewsAgency(
      name: "RFI",
      url: "http://www.rfi.fr/",
      iconUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Rfi_logo.svg/65px-Rfi_logo.svg.png",
//      iconUrl: 'http://en.rfi.fr/bundles/aefhermesrfi/img/logo_rfi_big.png',
      starred: false),
  NewsAgency(
      id: 1,
      name: "CNN",
      url: "http://www.cnn.com/",
      iconUrl:
          'http://cdn.cnn.com/cnn/.e1mo/img/4.0/logos/logo_cnn_badge_2up.png',
      starred: true),
  NewsAgency(
      name: "Africanews",
      url: "http://www.africanews.com/",
      iconUrl:
          'https://www.businessforafricaforum.com/wp-content/uploads/2017/11/Africanews_logo_coul_370x270-400x300.png',
      starred: true),
];

class NewsAgency {
  final int id;
  final String name;
  final String url;
  final String iconUrl;
  bool starred;

  NewsAgency({this.id, this.name, this.url, this.iconUrl, this.starred});

  
}
