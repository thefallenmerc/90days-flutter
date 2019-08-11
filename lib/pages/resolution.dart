import 'package:days90/models/resolution.dart';
import 'package:days90/pages/add_resolution.dart';
import 'package:days90/widgets/resolution_card.dart';
import 'package:days90/widgets/resolution_decision_row.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main_model.dart';

class ResolutionPage extends StatefulWidget {
  final int currentProduct;
  ResolutionPage(this.currentProduct);

  @override
  State createState() {
    return _ResolutionPageState();
  }
}

class _ResolutionPageState extends State<ResolutionPage> {
  String title = 'Detail';

  Widget _getStatus(Resolution currentResolution) {
    String text;
    MaterialColor color;
    switch (currentResolution.completed) {
      case 1:
        text = 'Incomplete';
        color = Colors.blue;
        break;
      case 2:
        text = 'Completed';
        color = Colors.green;
        break;
      default:
        text = 'Failed';
        color = Colors.red;
    }

    return Row(
      children: <Widget>[
        Text('Status:'),
        SizedBox(
          width: 5.0,
        ),
        Text(
          text,
          style: TextStyle(color: color),
        )
      ],
    );
  }

  Widget _buildDecisionRow(
      BuildContext context, MainModel model, Resolution currentResolution) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.check,
            color: Colors.green,
          ),
          onPressed: () {
            model.updateResolution(context, widget.currentProduct,
                currentResolution.id, {"completed": "2"});
          },
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            model.updateResolution(context, widget.currentProduct,
                currentResolution.id, {"completed": "3"});
          },
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return AddResolutionPage();
            }));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            model.deleteResolution(
                context, widget.currentProduct, currentResolution.id);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context2) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            final Resolution currentResolution =
                model.resolutionList[widget.currentProduct];
            model.setSelectedResolutionIndex = widget.currentProduct;
            title = currentResolution.title.toUpperCase();
            return SingleChildScrollView(
                child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                width: double.infinity,
                child: Hero(
                  tag: 'resolutionCard' + widget.currentProduct.toString(),
                  child: ResolutionCard(model, widget.currentProduct),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              model.isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                      padding: EdgeInsets.all(10.0),
                    )
                  : ResolutionDecisionRow(
                      model, widget.currentProduct, currentResolution)
            ]));
          },
        ));
  }
}
