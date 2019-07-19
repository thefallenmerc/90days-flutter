import 'package:days90/models/resolution.dart';
import 'package:days90/scoped_models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class AddResolutionPage extends StatefulWidget {
  AddResolutionPage();

  @override
  _AddResolutionPage createState() {
    return _AddResolutionPage();
  }
}

class _AddResolutionPage extends State<StatefulWidget> {
  Map<String, dynamic> _formData = {};
  DateTime selectedDate = DateTime.now();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Resolution resolution;
  // show datetime selector
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2099));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _formData['deadline'] = selectedDate;
      });
    }
  }

  Widget _buildDurationField() {
    return DropdownButton<String>(
      items: <String>['A', 'B', 'C'].map((String e) {
        return DropdownMenuItem(
          child: Text(e),
          value: e,
        );
      }).toList(),
      onChanged: (_) {},
    );
  }

  // add title field
  Widget _buildTitleField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      validator: (String value) {
        if (value.length < 5) {
          return 'Title must be 5 characters atleast';
        } else {
          return null;
        }
      },
      initialValue: resolution == null ? '' : resolution.title,
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  // add description field
  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      initialValue: resolution == null ? '' : resolution.description,
      validator: (String value) {
        if (value.length < 20) {
          return 'Description must be 20 characters atleast';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  // add deadline field
  Widget _buildDeadlineField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Pick Date"),
        Text(DateFormat('dd MMM yyyy').format(selectedDate)),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            _selectDate(context);
          },
        )
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, MainModel model) {
    return model.isLoading
        ? CircularProgressIndicator()
        : RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              resolution == null ? 'Add' : 'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();
              _formData['completed'] = "1".toString();
              _formData['deadline'] = selectedDate.toIso8601String();
              if (resolution == null) {
                model.saveResolution(context, _formData);
              } else {
                model
                    .updateResolution(context, model.selectedResolutionIndex,
                        resolution.id, _formData)
                    .then((value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                });
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Resolution'),
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          if (model.selectedResolutionIndex != null) {
            resolution = model.resolutionList[model.selectedResolutionIndex];
            selectedDate = DateTime.parse(resolution.deadline);
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Center(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildTitleField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildDescriptionField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildDeadlineField(),
                  // _buildDurationField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildSubmitButton(context, model)
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}
