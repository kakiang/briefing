import 'package:flutter/material.dart';

class BottomSheetMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: IconButton(
                padding: EdgeInsets.all(4.0),
                icon: Icon(Icons.account_circle, size: 48.0),
                onPressed: () {},
              ),
              title: Text(
                'Username',
                style: textStyle,
              ),
              subtitle: Text("username@gmail.com"),
              onTap: () {}),
          Divider(),
          ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {}),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Feedback'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
