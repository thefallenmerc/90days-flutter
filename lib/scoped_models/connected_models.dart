import 'package:days90/configs/api.dart';
import 'package:days90/models/resolution.dart';
import 'package:days90/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ConnectedModel extends Model {
  final String USERTOKEN = 'user_token';

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future<String> _getAuthorizationTokenString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return "Bearer " + prefs.getString('user_token');
  }

  Future<Map<String, String>> _getAuthorizedHeaders() async {
    return {
      'Accept': 'application/json',
      'Authorization': await _getAuthorizationTokenString()
    };
  }

  void _showScaffold(BuildContext context, String text) {
    try {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    } catch (error) {}
  }
}

class AutheticationModel extends ConnectedModel {
  PublishSubject<bool> userSubject = PublishSubject();

  User user;

  void login(BuildContext context, Map<String, dynamic> _formData) async {
    startLoading();
    try {
      http.Response response = await http.post(
          ApiConfig.base_url + ApiConfig.login,
          body: _formData,
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        String token = json.decode(response.body)['success']['token'];
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        await _prefs.setString('user_token', token);
        userSubject.add(true);
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('Authentication failed!')));
      }
      return;
    } catch (err) {
      print(err);
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text('Could not log you in!')));
    } finally {
      endLoading();
    }
  }

  void autoAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(USERTOKEN) != null) {
      userSubject.add(true);
      notifyListeners();
    }
  }

  void getUserProfile(BuildContext context, {bool force}) async {
    try {
      startLoading();
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      if (force == null) force = false;
      if (force) {
        http.Response response = await http.get(
            ApiConfig.base_url + ApiConfig.user_profile,
            headers: await _getAuthorizedHeaders());
        if (response.statusCode == 200) {
          Map<String, dynamic> userMap = json.decode(response.body)["success"];
          await _prefs.setString('user_data', json.encode(userMap));
          user = User.fromJson(userMap);
        } else {
          _showScaffold(context, 'Some error occured fetching profile!');
        }
      }
    } catch (e) {
      _showScaffold(context, 'Some error occured fetching profile!');
      print('Some error occurred fetching user profile');
    } finally {
      endLoading();
    }
  }

  void logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove('user_token');
    userSubject.add(false);
    notifyListeners();
    return;
  }
}

class ResolutionModel extends ConnectedModel {
  List<Resolution> resolutionList = [];
  int selectedResolutionIndex;

  set setSelectedResolutionIndex(index) {
    selectedResolutionIndex = index;
    notifyListeners();
  }

  void getResolutions(BuildContext context) async {
    resolutionList = [];
    startLoading();
    try {
      http.Response response = await http.get(
          ApiConfig.base_url + ApiConfig.resolutions,
          headers: await _getAuthorizedHeaders());
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['success'];
        responseData.forEach((e) {
          resolutionList.add(Resolution.fromJson(e));
        });
      }
    } catch (error) {} finally {
      endLoading();
    }
  }

  void saveResolution(
      BuildContext context, Map<String, dynamic> formData) async {
    startLoading();
    try {
      http.Response response = await http.post(
          ApiConfig.base_url + ApiConfig.resolutions,
          headers: await _getAuthorizedHeaders(),
          body: formData);
      if (response.statusCode == 201) {
        Resolution resolution =
            Resolution.fromJson(json.decode(response.body)['success']);
        print('resolution ' + resolution.createdAt);
        resolutionList.insert(0, resolution);
        endLoading();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: Text('Ye to fuck ho gya!'),
        ));
        print(response.body);
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text('Ye to fuck ho gya!'),
      ));
      print(e);
    }
    endLoading();
  }

  Future<bool> updateResolution(BuildContext context, int index, int id,
      Map<String, dynamic> formData) async {
    bool toBeReturned = false;
    startLoading();
    try {
      http.Response response = await http.put(
          ApiConfig.base_url + ApiConfig.resolutions + "/" + id.toString(),
          body: formData,
          headers: await _getAuthorizedHeaders());
      if (response.statusCode == 200) {
        resolutionList[index] =
            Resolution.fromJson(json.decode(response.body)['success']);
        _showScaffold(context, 'Updated');
        toBeReturned = true;
      } else {
        _showScaffold(context, 'Failed updating resolution!');
      }
    } catch (e) {
      _showScaffold(context, 'Failed updating resolution!');
      print(e);
    }
    endLoading();
    return toBeReturned;
  }

  void deleteResolution(BuildContext context, int index, int id) async {
    startLoading();
    try {
      http.Response response = await http.delete(
          ApiConfig.base_url + ApiConfig.resolutions + "/" + id.toString(),
          headers: await _getAuthorizedHeaders());
      if (response.statusCode == 200) {
        resolutionList.removeAt(index);
        _showScaffold(context, 'Updated');
        Navigator.of(context).pop();
      } else {
        _showScaffold(context, 'Failed to delete resolution!');
      }
    } catch (e) {
      _showScaffold(context, 'Failed to delete resolution!');
      print(e);
    }
    endLoading();
  }

  int getCompletedResolutionCount() {
    return resolutionList.where((e) => e.completed == 2).toList().length;
  }

  int getIncompletedResolutionCount() {
    return resolutionList.where((e) => e.completed == 1).toList().length;
  }

  int getFailedResolutionCount() {
    return resolutionList.where((e) => e.completed == 3).toList().length;
  }
}
