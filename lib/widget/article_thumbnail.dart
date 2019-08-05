import 'package:briefing/model/article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleThumbnail extends StatefulWidget {
  final Article article;

  const ArticleThumbnail({Key key, @required this.article}) : super(key: key);
  @override
  _ArticleThumbnailState createState() => _ArticleThumbnailState();
}

class _ArticleThumbnailState extends State<ArticleThumbnail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
          imageUrl: widget.article.imageUrl,
          imageBuilder: (context, imageProvider) => Container(
                width: 92.0,
                height: 92.0,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => Container()),
    );
  }
}
