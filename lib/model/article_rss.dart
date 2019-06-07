import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

class ArticleRss extends RssItem implements Comparable {
  String _agency;

  String _agencyIcon;

  ArticleRss(title, description, link, categories, guid, pubDate, author,
      comments, source, content, media, enclosure, dc, this._agency)
      : super(
            title: title,
            description: description,
            link: link,
            categories: categories,
            guid: guid,
            pubDate: pubDate,
            author: author,
            comments: comments,
            source: source,
            content: content,
            media: media,
            enclosure: enclosure,
            dc: dc) {
    this._agency = _agency;
    this._agencyIcon = _agencyIcon;
  }

  ArticleRss.fromParent(RssItem item, this._agency, this._agencyIcon)
      : super(
            title: item.title,
            description: item.description,
            link: item.link,
            categories: item.categories,
            guid: item.guid,
            pubDate: item.pubDate,
            author: item.author,
            comments: item.comments,
            source: item.source,
            content: item.content,
            media: item.media,
            enclosure: item.enclosure,
            dc: item.dc) {
    this._agency = _agency;
    this._agencyIcon = _agencyIcon;
  }

  bool isNew() {
    var formatter = new DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

    DateTime parsedDate = formatter.parse(pubDate);
    Duration duration = DateTime.now().difference(parsedDate);
    if (duration.inHours < 24) {
      return true;
    }
    return false;
  }

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

  get thumbnail {
    if (media?.thumbnails != null &&
        media.thumbnails.isNotEmpty &&
        media.thumbnails?.first != null &&
        media.thumbnails?.first != null &&
        media.thumbnails.first.url.isNotEmpty) {
      return media.thumbnails.first.url;
    } else if (enclosure?.url != null) {
      return enclosure.url;
    }
    return agencyIcon;
  }

  bool get isValid => title != null && title.isNotEmpty && link != null;

  get agency => _agency;

  set agency(String value) {
    _agency = value;
  }

  get agencyIcon => _agencyIcon;

  @override
  int compareTo(other) {
    return null;
  }

@override
  String toString() {
    return "ArticleRSS{title:$title, link:$link}\n";
  }

}
