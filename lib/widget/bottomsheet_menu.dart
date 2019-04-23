import 'package:flutter/material.dart';

class BottomSheetMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).iconTheme.color;
    return new Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
        decoration: new BoxDecoration(
          color: Colors.white,

          // shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
          ),
        ),
        child: Wrap(
          children: <Widget>[
            new ListTile(
                leading: IconButton(
                  padding: EdgeInsets.all(4.0),
                  icon: Icon(
                    Icons.account_circle,
                    size: 48.0,
                    color: color,
                  ),
                  onPressed: () {},
                ),
                title: new Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // color: color,
                  ),
                ),
                subtitle: Text("username@gmail.com"),
                onTap: () {}),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider()),
            new ListTile(
                leading: new Icon(Icons.notifications, color: color),
                title: new Text('Notifications'),
                onTap: () {
                }),
            new ListTile(
              leading: new Icon(Icons.settings, color: color),
              title: new Text('Settings'),
              onTap: () {},
            ),
            new ListTile(
              leading: new Icon(Icons.help, color: color),
              title: new Text('Help & Feedback'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
