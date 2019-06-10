import 'package:briefing/briefing_sliver_list.dart';
import 'package:briefing/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:briefing/widget/main_sliverappbar.dart';
import 'package:briefing/channel_sliver_list.dart';

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
  static var briefingSliver = BriefingSliverList();
  static var newsstandSliver = ChannelSliverList();
  var _pages = {
    "Briefing": briefingSliver,
    "Newsstands": newsstandSliver,
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarDividerColor: Colors.grey,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            MainSliverAppBar(title: _pages.keys.elementAt(_selectedIndex)),
            _pages.values.elementAt(_selectedIndex)
          ],
        ),
        floatingActionButton: _selectedIndex == 1
            ? FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {},
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 12.0,
          shape: _selectedIndex == 1 ? CircularNotchedRectangle() : null,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                              textTheme: Theme.of(context).textTheme.copyWith(
                                  subhead: Theme.of(context)
                                      .textTheme
                                      .subhead
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                      ))),
                          child: Container(
                            height: 150.0,
                            decoration: new BoxDecoration(
                              color: Colors.white,

                              // shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                              ),
                            ),
                            child: Drawer(
                              child: Wrap(
                                children: ListTile.divideTiles(
                                    color: Colors.yellow,
                                    context: context,
                                    tiles: [
                                      ListTile(
                                        leading: Icon(Icons.view_list),
                                        title: Text('Headlines'),
                                        onTap: () {
                                          _onItemTapped(0);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.library_books),
                                        title: Text('Newsstand'),
                                        onTap: () {
                                          _onItemTapped(1);
                                        },
                                      ),
                                    ]).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })
            ],
          ),
        ),
//        bottomNavigationBar: Theme(
//          data: Theme.of(context).copyWith(
//            canvasColor: Colors.white,
//            primaryColor: Colors.blue[700],
////            textTheme: Theme.of(context).textTheme.copyWith(
////                caption: TextStyle(
////                    fontSize: 16,
////                    fontWeight: FontWeight.w500,
////                    color: Colors.grey[700])),
//          ),
//          child: BottomNavigationBar(
//              items: <BottomNavigationBarItem>[
//                BottomNavigationBarItem(
//                  icon: Icon(Icons.view_headline),
//                  title: Text('Headlines'),
//                ),
////                BottomNavigationBarItem(
////                  icon: Icon(Icons.collections_bookmark),
////                  title: Text('Saved'),
////                ),
//                BottomNavigationBarItem(
//                  icon: Icon(Icons.filter_none),
//                  title: Text('Newsstand'),
//                ),
//              ],
//              currentIndex: _selectedIndex,
//              // fixedColor: Colors.blue[800],
//              onTap: _onItemTapped,
//              type: BottomNavigationBarType.fixed),
//        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }
}
