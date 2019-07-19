import 'package:days90/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:days90/pages/authentication.dart';
import 'package:days90/pages/homepage.dart';

void main() => runApp(MyApp());

class BootStrap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<StatefulWidget> {
  MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    // Log the user if his state changes
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: '90 Days',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) => _isAuthenticated
              ? MyHomePage(_model)
              : AuthenticationPage(_model),
        },
      ),
    );
  }
}
