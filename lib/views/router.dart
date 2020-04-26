import 'package:flutter/material.dart';
import 'package:greeting/views/pages/index.dart';
import 'package:greeting/views/splash/index.dart';

class Router {
  static String initialRoute = '/';
  static String currentPage = initialRoute;

  static const String home = '/home';
  static const String wishes = '/wishes';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentPage = settings.name;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case wishes:
        return MaterialPageRoute(builder: (_) => WishesPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
