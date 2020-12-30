import 'package:flutter/material.dart';
import 'package:play_with_friends/widgets/CustomButton.dart';

class RulePage extends StatefulWidget {
  RulePage({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.text, style: TextStyle(color: Colors.white),),
                            )
                        )
                    ),
                  ),
                )
            ),
          ],
        )
    );
  }
}
