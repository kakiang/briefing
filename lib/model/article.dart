import 'package:intl/intl.dart';

class Article {
  num id;
  final String title;
  final String description;
  final String url;
  final String publishedAt;
  final String author;
  final String source;
  final String content;
  final String imageUrl;
  final String category;
  bool bookmarked = false;

  Article(
      {this.id,
      this.title,
      this.description,
      this.url,
      this.publishedAt,
      this.author,
      this.source,
      this.content,
      this.imageUrl,
      this.category,
      this.bookmarked});

  factory Article.fromMap(Map<String, dynamic> data, {network = false}) {
    return Article(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      url: data['url'],
      publishedAt: data['publishedAt'],
      author: data['author'],
      source: network ? data['source']['name'] : data['source'],
      content: data['content'],
      imageUrl: data['urlToImage'],
      category: data['category'] ?? '',
      bookmarked: (data['bookmarked'] ?? false) == 1,
    );
  }

  Map<String, dynamic> toMap({category}) {
    return {
      'title': title,
      'description': description,
      'url': url,
      'publishedAt': publishedAt,
      'author': author,
      'source': source,
      'content': content,
      'urlToImage': imageUrl,
      'category': category ?? this.category,
      'bookmarked': bookmarked,
    };
  }

  String get timeAgo {
    var formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
//    var formatter = DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

    DateTime parsedDate = formatter.parse(publishedAt);
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

    DateTime parsedDate = formatter.parse(publishedAt);
    Duration duration = DateTime.now().difference(parsedDate);
    if (duration.inHours < 24) {
      return true;
    }
    return false;
  }

  bool get isValid => title != null && title.length > 3 && url != null;
}

const categories = [
  'All',
  'Business',
  'Entertainment',
  'Health',
  'Science',
  'Sports',
  'Technology'
];
