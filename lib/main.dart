import 'package:flutter/material.dart';
import 'package:lavage/authentification/Screen/login_page.dart';
import 'authentification/routes/route.dart';
import 'Slidesplashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff0200F4),
      ),
      title: 'AGLA',
      debugShowCheckedModeBanner: false,
      home: SlideSplashScreen(),
      routes: <String, WidgetBuilder>{
        SLIDE_SPLASH : (BuildContext context)=> new SlideSplashScreen(),
        LOGIN_SCREEN  : (BuildContext context) => new LoginPage(),
      },
    );
  }
}