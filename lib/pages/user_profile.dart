import 'package:days90/scoped_models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserProfilePage extends StatefulWidget {
  final MainModel model;
  UserProfilePage(this.model);

  @override
  _UserProfilePage createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  String image =
      "https://store.playstation.com/store/api/chihiro/00_09_000/container/US/en/999/UP1018-CUSA00133_00-AV00000000000015/1553561653000/image?w=512&h=512&bg_color=ffffff&opacity=100&_version=00_09_000";
  @override
  Widget build(BuildContext context) {
    widget.model.getUserProfile(context, force: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('POCHINKI'),
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildBody(context, model);
        },
      ),
    );
  }

  SingleChildScrollView _buildBody(BuildContext context, MainModel model) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(image), fit: BoxFit.cover))),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 0.75,
                          // height: 200.0,
                          margin: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
                          child: Card(
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(50.0, 125.0, 50.0, 50.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    model.user == null
                                        ? "John Doe"
                                        : model.user.name.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    model.user == null
                                        ? "john.doe@gmail.com"
                                        : model.user.email.toLowerCase(),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              // margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                              width: 150.0,
                              height: 150.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: FadeInImage.assetNetwork(
                                  height: 150.0,
                                  width: 150.0,
                                  image: image,
                                  placeholder: 'assets/user_profile.jpg',
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
