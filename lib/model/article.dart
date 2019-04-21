import 'package:intl/intl.dart';

class Article {
  final String id;
  final String agency;
  final String author;
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final String subject;
  final String urlImage;
  final String assetName;
  final String thumbnail;

  const Article(
      {this.id,
      this.agency,
      this.author,
      this.title,
      this.description,
      this.link,
      this.pubDate,
      this.subject,
      this.urlImage,
      this.assetName,
      this.thumbnail});

  String get dateTime {
    var formatter = new DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

    DateTime parsedDate = formatter.parse(pubDate);
    Duration duration = DateTime.now().difference(parsedDate);

    if (duration.inDays > 7 || duration.isNegative) {
      return DateFormat.MMMMd().format(parsedDate);
    } else if (duration.inDays >= 1 && duration.inDays <= 7) {
      return "${duration.inDays} days ago";
    } else if (duration.inHours >= 1) {
      return "${duration.inHours} hours ago";
    } else {
      return "${duration.inMinutes} minutes ago";
    }
  }

  bool get isValid => title != null && link != null && title.length > 3;
}

final articleList = [
  const Article(
    title: "Sudan crisis: Cash hoard found at al-Bashir's home",
    description:
        "Rights groups fear the referendum, which was organised in just a few days, won't be free or fair",
    link: "https://www.bbc.co.uk/news/world-middle-east-47974724",
    agency: "BBC News - Africa",
    pubDate: "Sat, 20 Apr 2019 18:45:55 GMT",
    assetName: "assets/images/dogceo/dog1.jpg",
    thumbnail:
        "http://c.files.bbci.co.uk/182B0/production/_106529989_053495046-1.jpg",
  ),
  const Article(
      title: "'Giant lion' fossil found in Kenya museum drawer",
      description:
          "The bones of the huge creature belong to a new species which roamed east Africa 20 million years ago.",
      link: "https://www.bbc.co.uk/news/world-africa-47976205",
      agency: "BBC News - Africa",
      pubDate: "Thu, 18 Apr 2019 09:42:47 GMT",
      assetName: "assets/images/dogceo/dog1.jpg",
      thumbnail:
          "http://c.files.bbci.co.uk/959B/production/_106499283_mammal.jpg"),
  const Article(
      title: "Naomi Campbell on racism and African fashion",
      description:
          'The British supermodel says she was told a photo campaign would not be used because of the "colour of [her] skin',
      link: "https://www.bbc.co.uk/news/world-africa-47989838",
      agency: "BBC News - Africa",
      pubDate: "Fri, 19 Apr 2019 16:24:10 GMT",
      assetName: "assets/images/dogceo/dog2.jpg",
      thumbnail:
          "http://c.files.bbci.co.uk/FF20/production/_106521356_p076z7h0.jpg"),
  const Article(
      title: "World's Best Teacher Peter Tabichi on how he reached the top",
      description:
          "Peter Tabichi from Kenya, who was named World's Best Teacher, shares what makes him stand out and what he hopes for teachers in Africa",
      link: "https://www.bbc.co.uk/news/world-africa-47969838",
      agency: "BBC News - Africa",
      pubDate: "Thu, 18 Apr 2019 08:39:08 GMT",
      assetName: "assets/images/dogceo/dog3.jpg",
      thumbnail:
          "http://c.files.bbci.co.uk/31FF/production/_106499721_p076v42d.jpg"),
  const Article(
    title: "Naima Mohamud on the man behind Somalia's free ambulances",
    description:
        "Aamin Ambulance service has become well known for being the first on the scene after a militant attack",
    link: "https://www.bbc.co.uk/news/world-africa-47880548",
    agency: "BBC News - Africa",
    pubDate: "Sun, 14 Apr 2019 23:24:07 GMT",
    assetName: "assets/images/dogceo/dog4.jpg",
    thumbnail:
        "http://c.files.bbci.co.uk/B47C/production/_106440264_2047c0b9-6295-4f4d-afcd-35aa0a474c14.jpg",
  ),
  const Article(
      title: "Cycling heaven: The African capital with 'no traffic",
      description:
          "How Asmara in Eritrea unintentionally became a cycling paradise.",
      link: "https://www.bbc.co.uk/news/world-africa-47709673",
      agency: "BBC News - Africa",
      pubDate: "Wed, 27 Mar 2019 00:06:03 GMT",
      assetName: "assets/images/dogceo/dog5.jpg",
      thumbnail:
          "http://c.files.bbci.co.uk/13B26/production/_106187608_fb1c2a2b-50e3-4cd2-87fa-4d63cc952d38.jpg"),
  const Article(
      title: "Will AI kill developing world growth?",
      description:
          "Automation could wipe out many jobs in developing countries, says globalisation expert Ian Goldin.",
      link: "https://www.bbc.co.uk/news/business-47852589",
      agency: "BBC News - Africa",
      pubDate: "Wed, 17 Apr 2019 23:08:04 GMT",
      assetName: "assets/images/dogceo/dog6.jpg",
      thumbnail:
          "http://c.files.bbci.co.uk/12887/production/_106411957_gettyimages-1132636819.jpg"),
];
