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
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    print('${snapshot.data[index]}');
                    return channelListTile(snapshot.data[index]);
                  });
            })
      ]),
    );
  }

  Container channelListTile(Channel channel) {
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
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        leading: Container(
          width: 64.0,
          height: 42.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(color: Colors.black12, width: 0.2)),
          child: CachedNetworkImage(
            imageUrl: channel.iconUrl ?? '',
            imageBuilder: (context, imageProvider) => Container(
                  width: 56.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3.0),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill)),
                  padding: EdgeInsets.only(right: 4.0),
                ),
            placeholder: (context, url) => Icon(Icons.image),
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          channel.title,
        ),
        subtitle: Text("Available"),
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
