import 'dart:convert';

import 'package:play_with_friends/models/deck_card.dart';
import 'package:play_with_friends/models/custom_icons.dart';
import 'package:play_with_friends/widgets/custom_deck_card.dart';
import 'package:swipeable_card/swipeable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "dart:math";
import 'package:play_with_friends/helper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RingOfFire extends StatefulWidget {
  RingOfFire({Key key,}) : super(key: key);

  @override
  _RingOfFireState createState() => _RingOfFireState();
}

class _RingOfFireState extends State<RingOfFire> with WidgetsBindingObserver {
  Helper helper;
  final _random = new Random();
  List<CustomDeckCard> cards = new List<CustomDeckCard>();
  GlobalKey _keyTaskText = GlobalKey();
  int currentCardIndex = 0;
  Future load;
  int currentKings = 0;
  PanelController _controller = new PanelController();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    helper = new Helper();
    load = setCards();
  }

  setCards() async {
    cards.add(CustomDeckCard(deckCard: DeckCard("Back", "", "", "resource/cards/images/Back.svg"),));

    List<DeckCard> deckCards;
    var s = await helper.getFileData("resource/cards/cards");
    var jsonCards = jsonDecode(s)['cards'] as List;
    deckCards = jsonCards.map((jsonCard) => DeckCard.fromJson(jsonCard)).toList();
    deckCards.shuffle(_random);
    deckCards.forEach((card) {
      cards.add(
          CustomDeckCard(deckCard: card,)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SwipeableWidgetController _cardController = SwipeableWidgetController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Ring of Fire"),
        elevation: 0,
      ),
      backgroundColor: const Color.fromRGBO(241, 233, 218, 1),
      body: FutureBuilder(
        future: load,
        builder:  (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              if (currentCardIndex < cards.length)
                SwipeableWidget(
                  cardController: _cardController,
                  animationDuration: 200,
                  horizontalThreshold: 0.85,
                  scrollSensitivity: 4.5,
                  child: cards[currentCardIndex],
                  nextCards: <Widget>[
                    // show next card
                    // if there are no next cards, show nothing
                    if (!(currentCardIndex + 1 >= cards.length))
                      Align(
                        alignment: Alignment.center,
                        child: cards[currentCardIndex + 1],
                      ),
                  ],
                  onLeftSwipe: () => swipeLeft(),
                  onRightSwipe: () => swipeRight(),
                )
              else
              // if the deck is complete, add a button to reset deck
                Center(
                  child: FlatButton(
                    child: Text("Reset deck"),
                    onPressed: () {
                      setState(() {
                        currentCardIndex = 0;
                        currentKings = 0;
                      });
                    },
                  ),
                ),

              // only show the card controlling buttons when there are cards
              // otherwise, just hide it
              if (currentCardIndex < cards.length)
                bottomSlide()
            ],
          );
        },
      ),
    );
  }

  void swipeLeft() {
    nextCard(context);
  }

  void swipeRight() {
    nextCard(context);
  }

  nextCard(BuildContext context){
    setState(() {
      currentCardIndex++;
    });
    if(currentCardIndex < 53 && cards[currentCardIndex].deckCard.card.contains("Kung")){
      setState(() {
        currentKings++;
      });
      if(currentKings == 4){
        showPopup(context);
      }
    }
  }

  showPopup(BuildContext context){
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text("Sista kungen", style: TextStyle(color: Colors.grey[400]),),
      content: Text("Detta är sista kungen. Dax att dricka upp glaset!", style: TextStyle(color: Colors.grey[400]),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget bottomSlide() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentKings.toString() + "/4 ", style: TextStyle(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(CustomIcons.crown, color: Colors.black,),
              ),
              SizedBox(width: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(currentCardIndex.toString() + "/52 ", style: TextStyle(fontSize: 20)),
              ),
              Icon(CustomIcons.hearts_card, color: Colors.black,)
            ],
          ),
        ),
        !cards[currentCardIndex].deckCard.card.contains("Back") ?
            GestureDetector(
              onTap: () => showHideSlider(),
              child: SlidingUpPanel(
                controller: _controller,
                onPanelOpened: () => setState(() => _isOpen = true),
                onPanelClosed: () => setState(() => _isOpen = false),
                color: Colors.brown[100],
                panelBuilder: (scrollController) {
                  return Opacity(
                    opacity: 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(child: Text(cards[currentCardIndex].deckCard.task, style: TextStyle(fontSize: 40),)),
                                Spacer(),
                                Center(child: Icon(CustomIcons.help,))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: AutoSizeText(
                              cards[currentCardIndex].deckCard.description,
                              maxLines: 6,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                maxHeight: MediaQuery.of(context).size.height * 0.35,
                minHeight: 60,
              ),
            )
            : Container(height: 60,)
      ],
    );
  }

  showHideSlider(){
    if(_isOpen){
      _controller.close();
    }
    if(!_isOpen){
      _controller.open();
    }
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
