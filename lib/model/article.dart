import 'package:intl/intl.dart';

class Article {
  num id;
  final String title;
  final String description;
  final String link;
  final String publishedAt;
  final String author;
  final String source;
  final String content;
  final String imageUrl;
  bool bookmarked = false;

  Article(
      {this.id,
      this.title,
      this.description,
      this.link,
      this.publishedAt,
      this.author,
      this.source,
      this.content,
      this.imageUrl,
      this.bookmarked});

  factory Article.fromMap(Map<String, dynamic> data, {network = false}) {
    return Article(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      link: data['link'],
      publishedAt: data['publishedAt'],
      author: data['author'],
      source: network ? data['source']['name'] : data['source'],
      content: data['content'],
      imageUrl: data['urlToImage'],
      bookmarked: (data['bookmarked'] ?? false) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'publishedAt': publishedAt,
      'author': author,
      'source': source,
      'content': content,
      'urlToImage': imageUrl,
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

  bool get isValid => title != null && title.length > 3 && link != null;
}

var newsapi = '''
{
  "source": {
  "id": "business-insider",
  "name": "Business Insider"
  },
  "author": "Rebecca Aydin",
  "title": "Mark Zuckerberg, Tim Cook, and more tech CEOs share favorite books - Business Insider",
  "description": "Zuckerberg recommends a novel about who really invented the lightbulb, and Sheryl Sandberg recommends Melinda Gates' book on female empowerment.",
  "url": "https://www.businessinsider.com/mark-zuckerberg-tim-cook-sheryl-sandberg-favorite-books-2019-8",
  "urlToImage": "https://amp.businessinsider.com/images/5d44669e100a2431aa055304-2732-1366.jpg",
  "publishedAt": "2019-08-04T13:05:44Z",
  "content": "When a young Stanford neurosurgeon is diagnosed with lung cancer, he sets out to write a memoir about mortality, memory, family, medicine, literature, philosophy, and religion. It's a tear-jerker, with an epilogue written by his wife Dr. Lucy Kalanithi, who s… [+93 chars]"
}
''';
