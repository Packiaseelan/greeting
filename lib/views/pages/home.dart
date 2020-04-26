import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:greeting/core/utils/enumerations.dart';

import 'package:greeting/views/router.dart';
import 'package:greeting/core/index.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _platformVersion = '';
  FlutterTtsImproved tts = FlutterTtsImproved();

  SpeechTypes _speechTypes = SpeechTypes.none;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    startTime();
  }

  startTime() {
    return Timer(Duration(seconds: 2), startSpeak);
  }

  void startSpeak() {
    _speechTypes = SpeechTypes.welcome;
    tts.speak(welcomeText);
    _platformVersion = '';
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    await tts.setSpeechRate(1.0);
    await tts.setPitch(1.0);
    await tts.setVolume(1.0);

    tts.setProgressHandler((String words, int start, int end, String word) {
      setState(() {
        _platformVersion = word;
      });

      tts.setCompletionHandler(() {
        if (_speechTypes == SpeechTypes.welcome) {
          _showModalBottomSheet();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return InkWell(
      onTap: () {
        _showModalBottomSheet();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/c/c16.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Image.asset('assets/images/balloon.png', fit: BoxFit.fill),
            Image.asset('assets/images/frame2.png', fit: BoxFit.fill),
            Positioned(
              bottom: 100,
              right: 30,
              child: Container(
                child: Image.asset('assets/images/text1.png', width: UIHelper.safeAreaWidth /2,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showModalBottomSheet() {
    _speechTypes = SpeechTypes.prompt1;
    tts.speak(prompt1);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onVerticalDragStart: (_) {},
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // RaisedButton(
                  //   child: Text('Exit App'),
                  //   onPressed: () {
                  //     tts.stop();
                  //     Navigator.of(context).pop(true);
                  //   },
                  // ),
                  RaisedButton(
                    child: Text('Continue'),
                    onPressed: () {
                      tts.stop();
                      Navigator.of(context).pushReplacementNamed(Router.wishes);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        isDismissible: false);
  }
}
