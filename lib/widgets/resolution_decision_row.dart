import 'package:days90/models/resolution.dart';
import 'package:days90/pages/add_resolution.dart';
import 'package:days90/scoped_models/main_model.dart';
import 'package:flutter/material.dart';

class ResolutionDecisionRow extends StatelessWidget {
  final MainModel model;
  final int currentProduct;
  final Resolution currentResolution;
  ResolutionDecisionRow(
      this.model, this.currentProduct, this.currentResolution);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.check,
            color: Colors.green,
          ),
          onPressed: () {
            model.updateResolution(context, currentProduct,
                currentResolution.id, {"completed": "2"});
          },
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            model.updateResolution(context, currentProduct,
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
                context, currentProduct, currentResolution.id);
          },
        ),
      ],
    );
  }
}
