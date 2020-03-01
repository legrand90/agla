import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:lavage/authentification/Screen/login_page.dart';
//import 'package:flutter/cupertino.dart';
//import 'screen/homePage.dart';


class SlideSplashScreen extends StatefulWidget{
  @override
  _SlideSplashScreenState createState() => _SlideSplashScreenState();
}

class _SlideSplashScreenState extends State<SlideSplashScreen>  {

  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "MAXOM 1",
        styleTitle: TextStyle(
            color: Color(0xffD02090),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "Much evil soon high in hope do view. Out may few northward believing attempted. ",
        styleDescription: TextStyle(
            color: Color(0xffD02090),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/logoAgla.png",
        colorBegin: Color(0xffFFA500),
        colorEnd: Color(0xff7FFFD4),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),

    );
    slides.add(
      new Slide(
        title: "MAXOM 2",
        styleTitle: TextStyle(
            color: Color(0xffD02090),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "Ye indulgence unreserved connection alteration appearance",
        styleDescription: TextStyle(
            color: Color(0xffD02090),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/logoAgla.png",
        colorBegin: Color(0xffFFFACD),
        colorEnd: Color(0xffFF6347),
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      new Slide(
        title: "MAXOM 3",
        styleTitle: TextStyle(
            color: Color(0xffD02090),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "Much evil soon high in hope do view. Out may few northward believing attempted. ",
        styleDescription: TextStyle(
            color: Color(0xffD02090),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/images/logoAgla.png",
        colorBegin: Color(0xffFFA500),
        colorEnd: Color(0xff7FFFD4),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    Navigator.push(context,
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginPage();
        },
      ),
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffD02090),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffD02090),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffD02090),
    );
  }



  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0x33000000),
      highlightColorSkipBtn: Color(0xff000000),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33000000),
      highlightColorDoneBtn: Color(0xff000000),

      // Dot indicator
      colorDot: Color(0x33D02090),
      colorActiveDot: Color(0xffD02090),
      sizeDot: 13.0,

      // Show or hide status bar
      shouldHideStatusBar: true,
    );
  }
}