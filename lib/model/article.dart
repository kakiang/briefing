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
  final List<String> mediaUrl;
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
      this.mediaUrl,
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
      mediaUrl: data['media_url'].toString().split(';'),
      content: data['content'],
      mediaThumbnails: data['media_thumbnails'].toString().split(';'),
      enclosure: data['enclosure'],
      channel: Channel.fromMap({
        'id': data['channel_id'],
        'title': data['c_title'],
        'link': data['c_link'],
        'last_build_date': data['last_build_date'],
        'language': data['language'],
        'link_rss': data['link_rss'],
        'icon_url': data['icon_url'],
        'favorite': data['favorite'] == 1,
      }),
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
      'media_url': mediaUrl?.join(';'),
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
//        mediaUrl = item.media?.contents?.first?.url,
        mediaUrl = item.media.contents.isNotEmpty
            ? item.media.contents.map((cont) => cont.url).toList()
            : [],
        content = item.content?.value,
        mediaThumbnails =
            item.media.thumbnails.map((thumbnail) => thumbnail.url).toList(),
        enclosure = item.enclosure?.url,
        channel = channel,
        bookmarked = false;

  String get timeAgo {
    var formatter = DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

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
    var formatter = DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

    DateTime parsedDate = formatter.parse(pubDate);
    Duration duration = DateTime.now().difference(parsedDate);
    if (duration.inHours < 36) {
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
    } else if (mediaThumbnails != null &&
        mediaThumbnails.isNotEmpty &&
        mediaThumbnails.first.isNotEmpty) {
      return mediaThumbnails.first;
    } else if (mediaUrl != null &&
        mediaUrl.isNotEmpty &&
        mediaUrl.first.isNotEmpty) {
      return mediaUrl.first;
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
