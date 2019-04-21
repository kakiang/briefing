import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 0.0,
      child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
//                  Text("Top 5 stories right now",
//                      style: Theme.of(context).textTheme.body1),
              IconButton(
                icon: Icon(
                  Icons.wb_sunny,
                  size: 36.0,
                  color: Colors.yellow,
                ),
                onPressed: () {},
              )
            ],
          ),
          // Center(
          //   child: Padding(
          //     padding: EdgeInsets.all(5.0),
          //     child: Text(r"$ " "95,940.00",
          //         style: TextStyle(color: Colors.white, fontSize: 24.0)),
          //   ),
          // ),
        ],
      )),
    );
  }
}
