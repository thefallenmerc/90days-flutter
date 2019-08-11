import 'package:flutter/material.dart';

class PerformanceCard extends StatelessWidget {
  final int count;
  final String subText;
  final MaterialColor color;

  PerformanceCard(this.count, this.subText, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
          width: (MediaQuery.of(context).size.width / 4) - 13.0,
          // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                count.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 45.0, color: color),
                textAlign: TextAlign.center,
              ),
              Text(
                subText,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
