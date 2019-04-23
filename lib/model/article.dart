import 'package:intl/intl.dart';
import 'package:briefing/model/news_agency.dart';

class Article {
  final String id;
  final String author;
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final String subject;
  final String urlImage;
  final String assetName;
  final String thumbnail;
  final NewsAgency agency;

  const Article(
      {this.id,
      this.author,
      this.title,
      this.description,
      this.link,
      this.pubDate,
      this.subject,
      this.urlImage,
      this.assetName,
      this.thumbnail,
      this.agency});

  String get dateTime {
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

  bool get isValid => title != null  && title.length > 3 && link != null && agency!=null;
}

final articleList = [
  const Article(
    title: "FC Bayern Opens 1st African Soccer School in Ethiopia",
    description:
        "German champion football club Bayern Munich has signed an agreement to open its first soccer school in Africa, locating it in Addis Ababa, Ethiopia.",
    link:
        "https://www.voanews.com/a/fc-bayern-opens-1st-african-soccer-school-in-ethiopia/4887383.html",
    agency: NewsAgency(
        name: "VOA News",
        iconUrl:
            'https://www.voanews.com/Content/responsive/VOA/en-US/img/logo.png'),
    pubDate: "Mon, 22 Apr 2019 23:40:49 GMT",
    thumbnail:
        "https://gdb.voanews.com/E7426D54-D96D-40CC-9761-00B4C47B81C4_cx0_cy5_cw0_w800_h450.jpg",
  ),
  const Article(
      title: "'Giant lion' fossil found in Kenya museum drawer",
      description:
          "The bones of the huge creature belong to a new species which roamed east Africa 20 million years ago.",
      link: "https://www.bbc.co.uk/news/world-africa-47976205",
      agency: NewsAgency(name: "BBC News - Africa", iconUrl:'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Thu, 18 Apr 2019 09:42:47 GMT",
      thumbnail:
          "http://c.files.bbci.co.uk/959B/production/_106499283_mammal.jpg"),
  const Article(
      title: "UN: Malawi is 1st Nation to Use Malaria Vaccine to Help Kids",
      description:
          'The World Health Organization says Malawi has become the first country to begin immunizing'
          ' children against malaria, using the only licensed vaccine to protect against the mosquito-spread disease',
      link:
          "https://www.voanews.com/a/un-malawi-is-1st-nation-to-use-malaria-vaccine-to-help-kids/4887594.html",
      agency: NewsAgency(
          name: "VOA News",
          iconUrl:
              'https://www.voanews.com/Content/responsive/VOA/en-US/img/logo.png'),
      pubDate: "Tue, 23 Apr 2019 08:50:25 GMT",
      thumbnail:
          "https://gdb.voanews.com/54EF1C53-51B7-41C1-B5C4-EAB567AC68DA_w800_h450.jpg"),
  const Article(
      title: "World's Best Teacher Peter Tabichi on how he reached the top",
      description:
          "Peter Tabichi from Kenya, who was named World's Best Teacher, shares what makes him stand out and what he hopes for teachers in Africa",
      link: "https://www.bbc.co.uk/news/world-africa-47969838",
      agency: NewsAgency(name: "BBC News - Africa", iconUrl:'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Thu, 18 Apr 2019 08:39:08 GMT",
      thumbnail:
          "http://c.files.bbci.co.uk/31FF/production/_106499721_p076v42d.jpg"),
  const Article(
    title: "Naima Mohamud on the man behind Somalia's free ambulances",
    description:
        "Aamin Ambulance service has become well known for being the first on the scene after a militant attack",
    link: "https://www.bbc.co.uk/news/world-africa-47880548",
    agency: NewsAgency(name: "BBC News - Africa", iconUrl:'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
    pubDate: "Sun, 14 Apr 2019 23:24:07 GMT",
    thumbnail:
        "http://c.files.bbci.co.uk/B47C/production/_106440264_2047c0b9-6295-4f4d-afcd-35aa0a474c14.jpg",
  ),
  const Article(
      title: "Cycling heaven: The African capital with 'no traffic",
      description:
          "How Asmara in Eritrea unintentionally became a cycling paradise.",
      link: "https://www.bbc.co.uk/news/world-africa-47709673",
      agency: NewsAgency(name: "BBC News - Africa", iconUrl:'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Wed, 27 Mar 2019 00:06:03 GMT",
      thumbnail:
          "http://c.files.bbci.co.uk/13B26/production/_106187608_fb1c2a2b-50e3-4cd2-87fa-4d63cc952d38.jpg"),
  const Article(
      title: "Will AI kill developing world growth?",
      description:
          "Automation could wipe out many jobs in developing countries, says globalisation expert Ian Goldin.",
      link: "https://www.bbc.co.uk/news/business-47852589",
      agency: NewsAgency(name: "BBC News - Africa", iconUrl:'https://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif'),
      pubDate: "Wed, 17 Apr 2019 23:08:04 GMT",
      thumbnail:
          "http://c.files.bbci.co.uk/12887/production/_106411957_gettyimages-1132636819.jpg"),
];
