import 'package:briefing/model/news_agency.dart';
import 'package:flutter/material.dart';

class NewsAgencyListPage extends StatefulWidget {
  @override
  _NewsAgencyListPageState createState() => _NewsAgencyListPageState();
}

class _NewsAgencyListPageState extends State<NewsAgencyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "News Agencies",
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  semanticLabel: 'search',
                ),
                onPressed: () {
                  print('Search menu');
                },
              ),
            ],
            elevation: 0.5,
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              newsAgencyList.map<Widget>((NewsAgency agency) {
                return agencyListTile(agency);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container agencyListTile(NewsAgency agency) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: Container(
          width: 42.0,
          height: 42.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(0.5),
            image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(
                agency.iconUrl ?? '',
              ),
            ),
          ),
        ),
        title: Text(
          agency.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Free"),
        trailing: Container(
          alignment: Alignment.center,
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 0.7, color: Colors.grey[300]),
          ),
          child: Icon(
            agency.starred ? Icons.star : Icons.star_border,
            color: agency.starred
                ? Colors.blue
                : Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
