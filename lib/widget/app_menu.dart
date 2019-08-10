import 'package:flutter/material.dart';

class BottomSheetMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0))),
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: IconButton(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    icon: Icon(Icons.account_circle, size: 48.0),
                    onPressed: () {}),
                title: Text('Username',
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontWeight: FontWeight.w500)),
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
                onTap: () {}),
            ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Feedback'),
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
