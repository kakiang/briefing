import 'package:briefing/model/channel.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

class Article {
  int id;
  final String title;
  final String description;
  final String link;
  final List<String> categories;
  final String guid;
  final String pubDate;
  final String author;
  final String comments;
  final String source;
  final String content;
  final List<String> mediaThumbnails;
  final String enclosure;
  final Channel channel;
  bool bookmarked;

  Article(
      {this.id,
      this.title,
      this.description,
      this.link,
      this.categories,
      this.guid,
      this.pubDate,
      this.author,
      this.comments,
      this.source,
      this.content,
      this.mediaThumbnails,
      this.enclosure,
      this.channel,
      this.bookmarked});

  factory Article.fromMap(Map<String, dynamic> data) {
    return Article(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      link: data['link'],
      categories: data['categories'].toString().split(';'),
      guid: data['guid'],
      pubDate: data['pub_date'],
      author: data['author'],
      comments: data['comments'],
      source: data['url_source'],
      content: data['content'],
      mediaThumbnails: data['media_thumbnails'].toString().split(';'),
      enclosure: data['enclosure'],
      channel: Channel.fromMap(
        data['channel_id'],
      ),
      bookmarked: data['bookmarked'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'categories': categories?.join(';'),
      'guid': guid,
      'pub_date': pubDate,
      'author': author,
      'comments': comments,
      'url_source': source,
      'content': content,
      'media_thumbnails': mediaThumbnails?.join(';'),
      'enclosure': enclosure,
      'channel_id': channel.id,
      'bookmarked': bookmarked,
    };
  }

  Article.fromRssItem(RssItem item, Channel channel)
      : title = item.title,
        description = item.description,
        link = item.link,
        categories = item.categories.map((cat) => cat.value).toList(),
        guid = item.guid,
        pubDate = item.pubDate,
        author = item.author,
        comments = item.comments,
        source = item.source?.url,
        content = item.content?.value,
        mediaThumbnails =
            item.media.thumbnails.map((thumbnail) => thumbnail.url).toList(),
        enclosure = item.enclosure?.url,
        channel = channel,
        bookmarked = false;

  String get timeAgo {
    var formatter = new DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

    DateTime parsedDate = formatter.parse(pubDate);
    Duration duration = DateTime.now().difference(parsedDate);

    if (duration.inDays > 7 || duration.isNegative) {
      return DateFormat.MMMMd().format(parsedDate);
    } else if (duration.inDays >= 1 && duration.inDays <= 7) {
      return duration.inDays == 1 ? "1 day ago" : "${duration.inDays} days ago";
    } else if (duration.inHours >= 1) {
      return duration.inHours == 1
          ? "1 hour ago"
          : "${duration.inHours} hours ago";
    } else {
      return duration.inMinutes == 1
          ? "1 minute ago"
          : "${duration.inMinutes} minutes ago";
    }
  }

  bool isNew() {
    var formatter = new DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

    DateTime parsedDate = formatter.parse(pubDate);
    Duration duration = DateTime.now().difference(parsedDate);
    if (duration.inHours < 48) {
      print('new ${duration.inHours}');
      return true;
    }
//    print('old ${duration.inHours}');
    return false;
  }

  set channel(Channel channel) {
    this.channel = channel;
  }

  get thumbnail {
    if (enclosure != null) {
      return enclosure;
    } else if (mediaThumbnails != null && mediaThumbnails.isNotEmpty) {
      return mediaThumbnails.first;
    }
    return null;
  }

  bool get isValid =>
      title != null && title.length > 3 && link != null && channel != null;

  @override
  String toString() {
    return "Article{id:$id,channel:$channel}\n";
  }
}

final articleList = [
  Article(
    title: "FC Bayern Opens 1st African Soccer School in Ethiopia",
    description: """
    German champion football club Bayern Munich has signed an 
    agreement to open its first soccer school in Africa, locating 
    it in Addis Ababa, Ethiopia.
    """,
    link:
        "https://www.voanews.com/a/fc-bayern-opens-1st-african-soccer-school-in-ethiopia/4887383.html",
    channel: Channel(
        title: "VOA News",
        iconUrl:
            'https://www.voanews.com/Content/responsive/VOA/en-US/img/logo.png'),
    pubDate: "Mon, 22 Apr 2019 23:40:49 GMT",
    enclosure:
        "https://gdb.voanews.com/E7426D54-D96D-40CC-9761-00B4C47B81C4_cx0_cy5_cw0_w800_h450.jpg",
  ),
  Article(
      title: "'Giant lion' fossil found in Kenya museum drawer",
      description:
          "The bones of the huge creature belong to a new species which roamed east Africa 20 million years ago.",
      link: "https://www.bbc.co.uk/news/world-africa-47976205",
      channel: Channel(
          title: "BBC News - Africa",
          iconUrl:
              'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Thu, 18 Apr 2019 09:42:47 GMT",
      enclosure:
          "http://c.files.bbci.co.uk/959B/production/_106499283_mammal.jpg"),
  Article(
      title: "UN: Malawi is 1st Nation to Use Malaria Vaccine to Help Kids",
      description:
          'The World Health Organization says Malawi has become the first country to begin immunizing'
          ' children against malaria, using the only licensed vaccine to protect against the mosquito-spread disease',
      link:
          "https://www.voanews.com/a/un-malawi-is-1st-nation-to-use-malaria-vaccine-to-help-kids/4887594.html",
      channel: Channel(
          title: "VOA News",
          iconUrl:
              'https://www.voanews.com/Content/responsive/VOA/en-US/img/logo.png'),
      pubDate: "Tue, 23 Apr 2019 08:50:25 GMT",
      enclosure:
          "https://gdb.voanews.com/54EF1C53-51B7-41C1-B5C4-EAB567AC68DA_w800_h450.jpg"),
  Article(
      title: "World's Best Teacher Peter Tabichi on how he reached the top",
      description:
          "Peter Tabichi from Kenya, who was named World's Best Teacher, shares what makes him stand out and what he hopes for teachers in Africa",
      link: "https://www.bbc.co.uk/news/world-africa-47969838",
      channel: Channel(
          title: "BBC News - Africa",
          iconUrl:
              'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Thu, 18 Apr 2019 08:39:08 GMT",
      enclosure:
          "http://c.files.bbci.co.uk/31FF/production/_106499721_p076v42d.jpg"),
  Article(
    title: "Naima Mohamud on the man behind Somalia's free ambulances",
    description:
        "Aamin Ambulance service has become well known for being the first on the scene after a militant attack",
    link: "https://www.bbc.co.uk/news/world-africa-47880548",
    channel: Channel(
        title: "BBC News - Africa",
        iconUrl:
            'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
    pubDate: "Sun, 14 Apr 2019 23:24:07 GMT",
    enclosure:
        "http://c.files.bbci.co.uk/B47C/production/_106440264_2047c0b9-6295-4f4d-afcd-35aa0a474c14.jpg",
  ),
  Article(
      title: "Cycling heaven: The African capital with 'no traffic",
      description:
          "How Asmara in Eritrea unintentionally became a cycling paradise.",
      link: "https://www.bbc.co.uk/news/world-africa-47709673",
      channel: Channel(
          title: "BBC News - Africa",
          iconUrl:
              'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Wed, 27 Mar 2019 00:06:03 GMT",
      enclosure:
          "http://c.files.bbci.co.uk/13B26/production/_106187608_fb1c2a2b-50e3-4cd2-87fa-4d63cc952d38.jpg"),
  Article(
      title: "Will AI kill developing world growth?",
      description:
          "Automation could wipe out many jobs in developing countries, says globalisation expert Ian Goldin.",
      link: "https://www.bbc.co.uk/news/business-47852589",
      channel: Channel(
          title: "BBC News - Africa",
          iconUrl:
              'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Wed, 17 Apr 2019 23:08:04 GMT",
      enclosure:
          "http://c.files.bbci.co.uk/12887/production/_106411957_gettyimages-1132636819.jpg"),
];
