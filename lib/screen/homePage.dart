import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
//import '../authentification/Screen/choice.dart';
//import '../authentification/Screen/login_page.dart';
//import '../authentification/Screen/register_page.dart';
//import '../authentification/Screen/register_partenaire.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo_blanc.png',
              fit: BoxFit.cover,
              width: 60.0,
              height: 60.0,
            ),
          )
      ),
    );
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            logo,
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
               child: FlatButton(
                 shape: new RoundedRectangleBorder(
                     borderRadius: new BorderRadius.circular(30.0)
                 ),
                 color: Colors.red,
                 //highlightedBorderColor: Colors.white,
                 onPressed: () {
                   Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (BuildContext context) {
                         return ;
                       },
                     ),
                   );
                 },
                 child: new Container(
                   padding: const EdgeInsets.symmetric(
                     vertical: 15.0,
                     horizontal: 15.0,
                   ),
                   child: new Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       new Expanded(
                         child: Text(
                           "S'inscrire patient",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold),
                         ),
                       ),
                     ],
                   ),
               ),
             ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                ),
                color: Colors.red,
                //highlightedBorderColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ;
                      },
                    ),
                  );
                },
                child: new Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 15.0,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: Text(
                          "Devenir partenaire",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                ),
                color: Colors.red,
                //highlightedBorderColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ;
                      },
                    ),
                  );
                },
                child: new Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 15.0,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: Text(
                          "Connection",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    ),
    );
  }

  Widget imageAsset() {
    AssetImage assetImage = AssetImage('assets/images/logo_rouge.png');
    Image image = Image(image: assetImage,
      width: 60.0,
      height: 60.0,
    );
    return Container(
      child: image,
     // padding: EdgeInsets.only(top: 10.0),
    );
  }

}
