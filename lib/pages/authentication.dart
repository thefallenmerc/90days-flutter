import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main_model.dart';

class AuthenticationPage extends StatefulWidget {
  final MainModel _model;
  AuthenticationPage(this._model);

  @override
  _AuthenticationPageState createState() {
    return _AuthenticationPageState();
  }
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'email': null, 'password': null};

  @override
  void initState() {
    widget._model.autoAuthenticate();
    super.initState();
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email"),
      onSaved: (String value) {
        _formData['email'] = value;
      },
      validator: (String value) {
        if (value.length < 5) {
          return 'Email is required!';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      onSaved: (String value) {
        _formData['password'] = value;
      },
      decoration: InputDecoration(labelText: 'Password'),
      validator: (String value) {
        if (value.length < 5) {
          return 'Password must be atleast 5 characters';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildLoginButton(BuildContext context, MainModel model) {
    return model.isLoading
        ? CircularProgressIndicator()
        : RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Login'.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }

              _formKey.currentState.save();
              model.login(context, _formData);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget widget, MainModel model) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Text('Authentication Page'),
                      _buildEmailField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildLoginButton(context, model)
                    ],
                  ),
                  key: _formKey,
                ),
                padding: EdgeInsets.all(20.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
