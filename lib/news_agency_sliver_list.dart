import 'package:briefing/model/news_agency.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsAgencySliverList extends StatefulWidget {
  @override
  _NewsAgencySliverListState createState() => _NewsAgencySliverListState();
}

class _NewsAgencySliverListState extends State<NewsAgencySliverList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        newsAgencyList.values.map<Widget>((NewsAgency agency) {
          return agencyListTile(agency);
        }).toList(),
      ),
    );
  }

  Container agencyListTile(NewsAgency agency) {
    _onTapStarIcon() {
      setState(() {
        if (agency.starred) {
          agency.starred = false;
        } else {
          agency.starred = true;
        }
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: ListTile(
        leading: Container(
          width: 56.0,
          height: 36.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2.0),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: agency.iconUrl != null && agency.iconUrl.isNotEmpty
                  ? CachedNetworkImageProvider(
                      agency.iconUrl,
                    )
                  : AssetImage('assets/images/loading.png'),
            ),
          ),
        ),
        title: Text(
          agency.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Free"),
        trailing: GestureDetector(
          onTap: _onTapStarIcon,
          child: Container(
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
        onTap: () async {
          if (await canLaunch(agency.url)) {
            launch(agency.url);
          }
        },
      ),
    );
  }
}
