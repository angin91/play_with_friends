import 'package:flutter/material.dart';

class BaseAlertTextDialog extends StatelessWidget {

  Color _color = Color.fromARGB(220, 117, 218 ,255);

  String _title;
  String _yes;
  String _no;
  Function _yesOnPressed;
  Function _noOnPressed;
  TextEditingController _controller;

  BaseAlertTextDialog({String title, Function yesOnPressed, Function noOnPressed, String yes = "Yes", String no = "No", TextEditingController controller}){
    this._title = title;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
    this._controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this._title),
      content: TextField(
        autofocus: true,
        controller: _controller,
        decoration: new InputDecoration(
            labelText: 'Full Name', hintText: 'eg. John Smith'),
      ),
      backgroundColor: this._color,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: <Widget>[
        FlatButton(
          child: Text(this._yes),
          textColor: Colors.greenAccent,
          onPressed: () {
            this._yesOnPressed();
          },
        ),
        FlatButton(
          child: Text(this._no),
          textColor: Colors.redAccent,
          onPressed: () {
            this._noOnPressed();
          },
        ),
      ],
    );
  }
}
