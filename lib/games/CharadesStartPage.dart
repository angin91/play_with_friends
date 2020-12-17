import 'package:flutter/material.dart';

class CharadesStartPage extends StatefulWidget {
  CharadesStartPage({Key key}) : super(key: key);

  @override
  _CharadesStartPageState createState() => _CharadesStartPageState();
}

class _CharadesStartPageState extends State<CharadesStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Charades"),
        ),
        body: Column(
          children: [
            Text("test")
          ],
        )
    );
  }
}