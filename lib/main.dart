import 'package:briefing/bookmarked_article_list.dart';
import 'package:briefing/briefing_sliver_list.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/theme/theme.dart';
import 'package:briefing/widget/main_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  int _selectedIndex = 0;
  final menus = [Menu.local, Menu.headlines, Menu.favorites, Menu.agencies];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget getScreen() {
      if (menus[_selectedIndex] == Menu.favorites) {
        return BookmarkArticleList();
      }
      if (menus[_selectedIndex] == Menu.local ||
          menus[_selectedIndex] == Menu.headlines) {
        return BriefingSliverList(menu: menus[_selectedIndex]);
      }
      return SliverList(
          delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Center(
            child: Text('Agencies(sources) comming soon...',
                style: TextStyle(fontSize: 22)),
          ),
        )
      ]));
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Theme.of(context).primaryColor,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: CustomScrollView(
            slivers: <Widget>[
              MainSliverAppBar(title: 'Briefing'),
              getScreen(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).primaryColor,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.cyan[100],
                    offset: Offset(-2.0, 2.0),
                    blurRadius: 2.0,
                    spreadRadius: 2.0)
              ]),
              height: 72.0,
              child: BottomNavigationBar(
                selectedItemColor: Theme.of(context).accentColor,
                currentIndex: _selectedIndex,
                onTap: (val) => _onItemTapped(val),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).primaryColor,
                selectedFontSize: 18.0,
                unselectedFontSize: 17.0,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.local_library), title: Text('Local')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.language), title: Text('Headlines')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_border),
                      title: Text('Favorites')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.filter_none), title: Text('Agencies'))
                ],
                elevation: 5.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
//    Navigator.pop(context);
  }
}
