import 'package:briefing/widget/app_menu.dart';
import 'package:flutter/material.dart';

class MainSliverAppBar extends StatelessWidget {
  final String title;

  const MainSliverAppBar({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void _modalMenu() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomSheetMenu();
        },
      );
    }

    return SliverAppBar(
      elevation: 1.0,
      pinned: true,
      forceElevated: true,
      leading: IconButton(
        icon: Icon(
          Icons.search,
          semanticLabel: 'search',
        ),
        onPressed: () {
          print('Search menu');
        },
      ),
      centerTitle: true,
      title: Text(title),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 6.0),
          child: IconButton(
            icon: Icon(Icons.account_circle, size: 32.0),
            onPressed: () {
              _modalMenu();
            },
          ),
        ),
      ],
    );
  }
}
