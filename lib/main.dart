import 'package:briefing/briefing_sliver_list.dart';
import 'package:briefing/news_agency_list.dart';
import 'package:briefing/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:briefing/briefing.dart';
// import 'package:briefing/weather_card.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showSemanticsDebugger: true,
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
  SliverAppBar _sliverAppBar() {
    return SliverAppBar(
      elevation: 0.0,
      // iconTheme: IconThemeData().copyWith(color: Colors.blue),
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
      title: Text(
        widget.title,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.account_circle,
            size: 28.0,
          ),
          onPressed: () {
            _modalMenu();
          },
        ),
        // InkWell(
        //   child: Container(
        //     width: 28.0,
        //     height: 28.0,
        //     decoration: BoxDecoration(
        //       border: Border.all(width: 1.0),
        //       shape: BoxShape.circle,
        //       image: DecorationImage(
        //         fit: BoxFit.cover,
        //         image: ExactAssetImage(
        //           "assets/images/dogceo/dog1.jpg",
        //         ),
        //       ),
        //     ),
        //   ),
        //   onTap: () {
        //     _modalMenu();
        //   },
        // ),
        // IconButton(
        //   padding: EdgeInsets.all(4.0),
        //   icon: Image.asset(
        //     "assets/images/dogceo/dog1.jpg",
        //     width: 28.0,
        //     height: 28.0,
        //   ),
        //   onPressed: () {
        //     _modalMenu();
        //   },
        // ),

//        SizedBox(
//          width: 16.0,
//        ),
      ],
    );
  }

  menuPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NewsAgencyListPage();
        },
      ),
    );
  }

  InkResponse _buildButtonColumn({Color color, IconData icon, String label}) {
    return InkResponse(
      onTap: () {
        menuPage();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            // color: color,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                // color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _modalMenu() {
    Color color = Theme.of(context).iconTheme.color;
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
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
                      //  new Icon(

                      //   Icons.account_circle,
                      //   size: 42.0,
                      // ),
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
                        // showArticleWebView();
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await new Future.delayed(const Duration(seconds: 1));
          // TODO: update data
        },
        child: CustomScrollView(
          slivers: <Widget>[
            _sliverAppBar(),
            BriefingSilverList(),
          ],
        ),
      ),
      // body: Container(
      //   child: Column(
      //     children: <Widget>[
      //       WeatherCard(),
      //       Expanded(child: Briefing()),
      //     ],
      //   ),
      //   ),
      bottomNavigationBar: Container(
        // padding: EdgeInsets.only(top: 0.0),
        height: 65.0,
        child: BottomAppBar(
          elevation: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButtonColumn(icon: Icons.person_outline, label: 'For you'),
              _buildButtonColumn(
                  icon: Icons.format_list_bulleted, label: 'Headlines'),
              _buildButtonColumn(
                  icon: Icons.bookmark_border, label: 'Favorites'),
              _buildButtonColumn(icon: Icons.filter_none, label: 'Newsagency'),
            ],
          ),
        ),
      ),
    );
  }
}
