import 'dart:async';

import 'package:briefing/briefing_sliver_list.dart';
import 'package:briefing/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:briefing/widget/main_sliverappbar.dart';
import 'package:briefing/news_agency_sliver_list.dart';

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      // systemNavigationBarColor: Colors.white,
      // systemNavigationBarIconBrightness: Brightness.dark
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      title: 'Briefing',
      theme: buildAppTheme(),
      home: MyHomePage(title: 'Briefing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  var _pages = {
    "Briefing" : BriefingSliverList(),
    "Headlines": BriefingSliverList(),//testing purpose
    "Favorites": BriefingSliverList(),//testing purpose
    "Newsstands":NewsAgencySliverList(),
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: new RefreshIndicator(
        displacement: 65.0,
        color: Colors.blue[800],
        backgroundColor: Colors.white,
        onRefresh: () async {
          // less elegant and more expedient and, I hope, momentarily
          // solution to the problem that the current context doesn't
          // contain a Scaffold.
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Refresh feature to be implemented')),
          );
          await new Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: <Widget>[
            MainSliverAppBar(title: _pages.keys.elementAt(_selectedIndex)),
            _pages.values.elementAt(_selectedIndex)
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
          primaryColor: Colors.blue[700],
          textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey[700])),
        ),
        child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline,
                  ),
                  title: Text('For you')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_bulleted),
                  title: Text('Headlines')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border), title: Text('Favorites')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.filter_none), title: Text('Newsstand')),
            ],
            currentIndex: _selectedIndex,
            // fixedColor: Colors.blue[800],
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class rssfeed {
  // RSS feed
  RssFeed devFeed() {
    var client = new http.Client();
    client
        .get("http://feeds.bbci.co.uk/news/world/africa/rss.xml")
        .then((response) {
      return response.body;
    }).then((bodyString) {
      var channel = new RssFeed.parse(bodyString);
      print(channel);
      return channel;
    });
  }

  // Atom feed
  RssFeed vergeFeed() {
    var client = new http.Client();
    client.get("https://www.theverge.com/rss/index.xml").then((response) {
      return response.body;
    }).then((bodyString) {
      var feed = new AtomFeed.parse(bodyString);
      print(feed);
      return feed;
    });
  }
}