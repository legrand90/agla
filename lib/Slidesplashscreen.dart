import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
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

class _SlideSplashScreenState extends State<SlideSplashScreen> {

  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "",
        backgroundImage: "assets/images/imgAc.jpg",
        maxLineTextDescription: 3,
        backgroundBlendMode: BlendMode.color
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

  Widget renderNextBtn(){
    return Icon(
      Icons.navigate_next,
      color: Color(0xffD02090),
      size: 35.0,
    );
  }

  Widget renderDoneBtn(){
    return Icon(
      Icons.done,
      //color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,
      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33000000),
      highlightColorDoneBtn: Color(0xff000000),

      // Dot indicator
      //colorDot: Color(0x33D02090),
      //colorActiveDot: Color(0xffD02090),
      //sizeDot: 13.0,

      // Show or hide status bar
      shouldHideStatusBar: true,
    );
  }
}