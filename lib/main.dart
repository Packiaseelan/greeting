import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greeting/core/index.dart';
import 'package:greeting/views/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.grey,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      title: 'Birthday Wish',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLightTheme(),
      onGenerateRoute: Router.generateRoute,
      initialRoute: Router.initialRoute,
    );
  }
}
