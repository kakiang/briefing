import 'package:flutter/material.dart';
import 'package:briefing/widget/bottomsheet_menu.dart';

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
      elevation: 0.0,
      floating: true,
      snap: true,
      // brightness: Brightness.light,
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
        IconButton(
          icon: Icon(Icons.account_circle, size: 32.0),
          onPressed: () {
            _modalMenu();
          },
        ),
      ],
    );
  }
}
