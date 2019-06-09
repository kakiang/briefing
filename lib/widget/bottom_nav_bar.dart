import 'package:flutter/material.dart';
import 'package:briefing/channel_sliver_list.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InkWell _buildButtonColumn(
        {Color color, IconData icon, String label, int id}) {
      return InkWell(
        splashColor: Colors.blue[300],
        radius: 505.0,
        // borderRadius: BorderRadius.circular(5.0),
        customBorder: StadiumBorder(side: BorderSide(width: 5.0)),
        onTap: () {
          if (id == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ChannelSliverList();
                },
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(icon),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  label,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 65.0,
      child: BottomAppBar(
        elevation: 3.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildButtonColumn(icon: Icons.person_outline, label: 'For you'),
            _buildButtonColumn(
                icon: Icons.format_list_bulleted, label: 'Headlines'),
            _buildButtonColumn(icon: Icons.bookmark_border, label: 'Favorites'),
            _buildButtonColumn(
                icon: Icons.filter_none, label: 'Newsagency', id: 3),
          ],
        ),
      ),
    );
  }
}
