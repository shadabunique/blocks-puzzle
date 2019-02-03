import 'package:blocks_puzzle/routes/game_home.dart';
import 'package:blocks_puzzle/routes/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(BlocksPuzzleApp());
  });
}

class BlocksPuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => SplashScreen(),
        '/home': (BuildContext context) => GameScreen(),
      },
    );
  }
}
