import 'package:briefing/model/channel.dart';
import 'package:briefing/model/database/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelSliverList extends StatefulWidget {
  @override
  _ChannelSliverListState createState() => _ChannelSliverListState();
}

class _ChannelSliverListState extends State<ChannelSliverList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        FutureBuilder(
            future: DBProvider.db.getAllChannel(),
            initialData: [],
            builder: (context, snapshot) {
              return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    print('${snapshot.data[index]}');
                    return channelListTile(snapshot.data[index], index);
                  });
            })
      ]),
    );
  }

  Container channelListTile(Channel channel, int index) {
    _onTapStarIcon() async {
      setState(() {
        channel.favorite = !channel.favorite;
      });

      int id = await DBProvider.db.updateChannel(channel);
      print('Channel $id updated');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
//        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        leading: Container(
          width: 48.0,
          height: 36.0,
          decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[100]),
              borderRadius: BorderRadius.circular(3.0)),
          child: CachedNetworkImage(
            imageUrl: channel.iconUrl ?? '',
            imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3.0),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill)),
                  padding: EdgeInsets.only(right: 4.0),
                ),
            placeholder: (context, url) => Icon(Icons.image),
          ),
        ),
        title: Text(
          channel.title,
          style: Theme.of(context).textTheme.subhead.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text("${index + 1}. Available"),
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
              channel.favorite ? Icons.star : Icons.star_border,
              color: channel.favorite
                  ? Theme.of(context).accentIconTheme.color
                  : Theme.of(context).iconTheme.color,
            ),
          ),
        ),
        onTap: () async {
          if (await canLaunch(channel.link)) {
            launch(channel.link);
          }
        },
      ),
    );
  }
}
