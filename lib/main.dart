import './pages/about.dart';

import './pages/home_page.dart';

import './screens/playlist_screen.dart';
import './screens/playvideo_screen.dart';
import 'package:flutter/material.dart';

import './pages/splash_page.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      // home: HomePage(),
      routes: {
        HomePage.routeName: (ctx) => HomePage(),
        PlaylistScreen.routeName: (ctx) => PlaylistScreen(),
        PlayvideoScreen.routeName: (ctx) => PlayvideoScreen(),
        About.routeName: (ctx) => About(),
      },
    );
  }
}
