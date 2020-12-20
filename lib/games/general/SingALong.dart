import 'package:flutter/material.dart';
import 'file:///C:/Users/angin/workspace/play_with_friends/lib/models/flip_card.dart';
import 'package:play_with_friends/models/CostumButton.dart';
import 'package:wakelock/wakelock.dart';

class SingALong extends StatefulWidget {
  SingALong({Key key, @required this.songTitle, @required this.frontText, @required this.backText}) : super(key: key);

  final String songTitle;
  final String frontText;
  final String backText;

  @override
  _SingALongState createState() => _SingALongState();
}

class _SingALongState extends State<SingALong> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(widget.songTitle,
                style: TextStyle(
                    fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  child: FlipCard(
                    front: Card(
                      color: Colors.white60,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                            color: Colors.black
                        ),
                      ),
                      borderOnForeground: true,
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.frontText,
                              style: TextStyle(
                                  fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ),
                    ),
                    back: Card(
                      color: Colors.white60,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                            color: Colors.black
                        ),
                      ),
                      borderOnForeground: true,
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.backText,
                              style: TextStyle(
                                fontSize: 20
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Back",
                onTap: _finish,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
  }

  _finish(){
    Navigator.pop(context);
  }
}
