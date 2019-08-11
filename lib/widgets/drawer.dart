import 'package:days90/pages/add_resolution.dart';
import 'package:days90/pages/user_profile.dart';
import 'package:days90/scoped_models/main_model.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  final MainModel _model;
  SideDrawer(this._model);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('90 Days'),
          ),
          ListTile(
            title: Text('Add Resolution'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AddResolutionPage();
              }));
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => UserProfilePage(_model)));
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: _model.logout,
          ),
        ],
      ),
    );
  }
}
