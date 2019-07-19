import 'package:days90/models/resolution.dart';
import 'package:days90/scoped_models/main_model.dart';
import 'package:flutter/material.dart';
import '../pages/resolution.dart';

class ResolutionCard extends StatelessWidget {
  final MainModel model;
  final int index;

  ResolutionCard(this.model, this.index);

  _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              child: Text('Delete'),
              onPressed: () {},
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    model.selectedResolutionIndex = index;
    Resolution resolution = model.resolutionList[index];
    Color bgColor = resolution.completed == 1
        ? Colors.blue
        : resolution.completed == 2 ? Colors.green : Colors.red;

    return Card(
      color: bgColor,
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                resolution.title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                resolution.description,
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('Deadline: ' + resolution.deadline,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ResolutionPage(index);
          }));
        },
        onLongPress: () {
          _showBottomSheet(context, index);
        },
      ),
    );
  }
}
