import 'package:flutter/material.dart';
import 'package:briefing/model/article.dart';

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
      margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
      width: 92.0,
      height: 92.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        // border: Border.all(style: BorderStyle.solid, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.grey[200],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.article.thumbnail ?? ''),
        ),
      ),
    );

    // // This is an animated widget built into flutter.
    // return AnimatedCrossFade(
    //   // You pass it the starting widget and the ending widget.
    //   firstChild: placeholder,
    //   secondChild: articleThumbnail,
    //   // Then, you pass it a ternary that should be based on your state
    //   //
    //   // If renderUrl is null tell the widget to use the placeholder,
    //   // otherwise use the dogAvatar.

    //   crossFadeState: widget.article.thumbnail == null
    //       ? CrossFadeState.showFirst
    //       : CrossFadeState.showSecond,
    //   // Finally, pass in the amount of time the fade should take.
    //   duration: Duration(milliseconds: 1000),
    // );
  }

//   var articleThumbnail = Container(
//     margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
//     width: 92.0,
//     height: 92.0,
//     decoration: BoxDecoration(
//       shape: BoxShape.rectangle,
//       // border: Border.all(style: BorderStyle.solid, width: 2.0),
//       borderRadius: BorderRadius.circular(4.0),
//       color: Colors.grey[200],
//       image: DecorationImage(
//         fit: BoxFit.cover,
//         image: NetworkImage(widget.article.thumbnail ?? ''),
//       ),
//     ),
//   );
//   var placeholder = Container(
// //      margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
// //      width: 92.0,
// //      height: 92.0,
// //      decoration: BoxDecoration(
// //        color: Colors.grey,
// //        shape: BoxShape.rectangle,
// //        // border: Border.all(style: BorderStyle.solid, width: 2.0),
// //        borderRadius: BorderRadius.circular(4.0),
// //      ),
//       );
}
