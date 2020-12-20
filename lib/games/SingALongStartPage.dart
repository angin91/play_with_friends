import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_with_friends/games/general/RulePage.dart';
import 'package:play_with_friends/models/CostumButton.dart';

import '../Helper.dart';

class SingALongStartPage extends StatefulWidget {
  SingALongStartPage({Key key}) : super(key: key);

  @override
  _SingALongStartPageState createState() => _SingALongStartPageState();
}

class _SingALongStartPageState extends State<SingALongStartPage> {

  Helper helper;

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sing-a-Long"),
        ),
        body: Column(
          children: [
            Text("test"),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Start",
//                    onTap: () => getRule("resource/rules/sing_a_long_rules"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Rules",
                      onTap: () => getRule("resource/rules/sing_a_long_rules_swe"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  void getRule(url) async {
    var text = await helper.getFileData(url);

    Navigator.push(context, MaterialPageRoute(builder: (context) => RulePage(text: text),));
  }
}