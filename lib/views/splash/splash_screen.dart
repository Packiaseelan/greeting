import 'package:flutter/material.dart';
import 'package:greeting/core/index.dart';
import 'package:greeting/views/router.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.open(
      Audio("assets/audios/instrumental.mp3"),
    );
    _assetsAudioPlayer.playOrPause();
    _assetsAudioPlayer.playlistFinished.listen((onData) {
      if (onData) {
        Navigator.of(context).pushReplacementNamed(Router.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: <Widget>[
                  Text('Happy Birthday', style: AppTheme.sTitle),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 30),
                child: Image.asset('assets/images/cake.gif'),
              ),
            ),
            Text(
              'Powered By',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'P\u00B3+S\u00B2+M\u00B9=',
                  style: TextStyle(
                      letterSpacing: 3, color: Colors.yellow.shade600),
                ),
                Text(
                  '⚡',
                  style: TextStyle(
                      letterSpacing: 3, fontSize: 35, color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
