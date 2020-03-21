import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/historique.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:lavage/authentification/Screen/transac.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Transaction.dart';
import 'login_page.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DashbordScreen extends StatefulWidget {

  int Counter ;
  var name ;

  DashbordScreen({Key key, @required this.Counter, this.name}) : super(key: key);

  @override
  _DashbordScreenState createState() => _DashbordScreenState(Counter, name);
}

class _DashbordScreenState extends State<DashbordScreen> {

  int Counter = 0 ;
  var name ;

  _DashbordScreenState(this.Counter, this.name);

  int nb = 8 ;

  bool load = true;
  Future<bool> _onBackPressed(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Vous voulez vraiment quitter cette page ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Non"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Oui"),
              onPressed: () => _logout(),
            )
          ],
        )
    );
  }

  Future<bool> _alertDeconnexion(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Vous voulez vraiment vous deconnecter ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Non"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Oui"),
              onPressed: () => _logout(),
            )
          ],
        )
    );
  }

  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());



  @override

  void initState(){
    super.initState();
    this.getUserName();
    this.getStatut();
    //this.nombreCarWashed();

  }

  Widget build(BuildContext context){
      return  WillPopScope(
            onWillPop: () async => _onBackPressed(),
          child:  Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Text('TABLEAU DE BOARD'),
            ),
            body: load ? new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                    Padding(
//                      padding : EdgeInsets.only(left: 100.0, top: 100.0),
//                      child : Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Text('Nombre de vehicule lave :'),
//                        ),
//                        Expanded(
//                          child: Text('$Counter'),
//                        ),
//                      ],
//                    )
//                    ),
//
//                    Padding(
//                        padding : EdgeInsets.only(left: 100.0, top: 30.0),
//                        child : Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Text('Laveur Actif :'),
//                        ),
//                        Expanded(
//                          child: Text('XXX'),
//                        ),
//                      ],
//                    )),
//
//                    Padding(
//                        padding : EdgeInsets.only(left: 100.0, top: 30.0),
//                        child : Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Text('Prestation :'),
//                        ),
//                        Expanded(
//                          child: Text('XXX'),
//                        ),
//                      ],
//                    )),
//
//                    Padding(
//                        padding : EdgeInsets.only(left: 100.0, top: 30.0, bottom: 50.0),
//                        child : Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Text('Recette de la journee :'),
//                        ),
//                        Expanded(
//                          child: Text('XXX'),
//                        ),
//                      ],
//                    )),

                    (admin == '0' || admin == '1') ? Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              ),
                              color: Color(0xff0200F4),
                              onPressed: (){
                                    Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return Transaction();
                                    },
                                  ),
                                );
                              },
                              child: new Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Nouvelle Entree",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ) : Text(''),

                    (admin == '0' || admin == '1') ? Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              ),
                              color: Color(0xff0200F4),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ClientPage();
                                    },
                                  ),
                                );
                              },
                              child: new Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Recherche",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontSize: 20.0
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ) : Text(''),

                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              ),
                              color: Color(0xff0200F4),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return Register();
                                    },
                                  ),
                                );
                              },
                              child: new Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "Parametre",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontSize: 20.0
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ) : Center(child: CircularProgressIndicator(),),

            drawer: load ? Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: (admin == '0' || admin == '1') ? ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text('$nameUser'),
                    accountEmail: (adm == '0' || adm == '1') ? Text('Lavage: $libLavage \nVous êtes $statu') : Text('Vous êtes $statu'),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff0200F4),
                    ),
                  ),
                  ListTile(
                    title: Text('Nouvelle Entree'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                     await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Transaction();
                          },
                        ),
                      );
                     setState(() {
                       load = true;
                     });
                    },
                  ),
                  ListTile(
                    title: Text('Recherche'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ClientPage();
                          },
                        ),
                      );

                      setState(() {
                        load = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Historique'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Historique();
                          },
                        ),
                      );
                      setState(() {
                        load = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Parametre'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Register();
                          },
                        ),
                      );
                      setState(() {
                        load = true;
                      });
                    },
                  ),

                  ListTile(
                    title: Text('Tutoriel'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                     // await Navigator.push(
                      //  context,
                       // new MaterialPageRoute(
                       //   builder: (BuildContext context) {
                        //    return Register();
                        //  },
                       // ),
                     // );
                      setState(() {
                        load = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('A propos'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      //await _alertDeconnexion();

                      setState(() {
                        load = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Deconnexion'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      await _alertDeconnexion();

                      setState(() {
                        load = true;
                      });
                    },
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 100.0,),
                    padding: EdgeInsets.symmetric(horizontal:20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Suivez-nous'),),
                        //SizedBox(width: 170,),
                        IconButton(
                          iconSize: 40.0,
                          color: Colors.blue,
                          icon: FaIcon(FontAwesomeIcons.facebook),
                          onPressed: ()async{
                            await _launchFacebookURL();

                          },
                        ),

                        SizedBox(width: 20,),

                        IconButton(
                          iconSize: 40.0,
                          color: Colors.red,
                          icon: FaIcon(FontAwesomeIcons.chrome),
                          onPressed: ()async{

                            _launchMaxomURL();
                          },
                        ),
                      ],
                    ),
                  )

                ],
              ) : ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text('$nameUser'),
                    accountEmail: (adm == '0' || adm == '1') ? Text('Lavage: $libLavage \nVous êtes $statu') : Text('Vous êtes $statu'),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff0200F4),
                    ),
                  ),

                  ListTile(
                    title: Text('Parametre'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Register();
                          },
                        ),
                      );
                      setState(() {
                        load = true;
                      });
                    },
                  ),

                  ListTile(
                    title: Text('Tutoriel'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      // await Navigator.push(
                      //  context,
                      // new MaterialPageRoute(
                      //   builder: (BuildContext context) {
                      //    return Register();
                      //  },
                      // ),
                      // );
                      setState(() {
                        load = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('A propos'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      //await _alertDeconnexion();

                      setState(() {
                        load = true;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Deconnexion'),
                    onTap: () async{
                      setState(() {
                        load = false;
                      });
                      await _alertDeconnexion();

                      setState(() {
                        load = true;
                      });
                    },
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 270.0,),
                    padding: EdgeInsets.symmetric(horizontal:20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('Suivez-nous', style: TextStyle(color: Colors.red),),),
                        //SizedBox(width: 170,),
                        IconButton(
                          iconSize: 40.0,
                          color: Colors.blue,
                          icon: FaIcon(FontAwesomeIcons.facebook),
                          onPressed: ()async{
                            await _launchFacebookURL();

                          },
                        ),

                        SizedBox(width: 20,),

                        IconButton(
                          iconSize: 40.0,
                          color: Colors.red,
                          icon: FaIcon(FontAwesomeIcons.chrome),
                          onPressed: ()async{
                            _launchMaxomURL();
                          },
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ) : Center(child: CircularProgressIndicator(),),

            ) ,
          );
    }

    void _logout() async{
    var res = await CallApi().getData('logout');
    var body = json.decode(res.body);
    if(body['success']){
      print('deconn $body');
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString('token');
      localStorage.remove(token);
      localStorage.remove('user');
      localStorage.remove('id_lavage');
      localStorage.remove('Admin');
      await Navigator.push(context,
          new MaterialPageRoute(
              builder: (BuildContext context){
                return new LoginPage();
              }
          ));
    }

    }

    var nameUser;
  var admin;

  void getUserName() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userName = localStorage.getString('nom');

    setState(() {
      nameUser = userName;
      admin = localStorage.getString('Admin');
    });

    print(localStorage.getString('token'));

  }

  var adm;
  var statu;
  var libLavage;

  Future <void> getStatut()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idUser = localStorage.getInt('ID');
    adm = localStorage.getString('Admin');

    if(adm == '0' || adm == '1'){
      var res = await CallApi().getData('getUser/$idUser');
      print('le corps $res');
      var resBody = json.decode(res.body)['data'];

      if(resBody['success']){

        setState((){
          statu = resBody['status'];
          libLavage = resBody['nomLavage'];

        });
      }

    }else{
      var res2 = await CallApi().getData('getUserSuperAdmin/$idUser');
      var resBody2 = json.decode(res2.body)['data'];

      if(resBody2['success']){

        setState((){
          statu = resBody2['status'];
        });
      }
    }


}


  _launchFacebookURL() async {
    const url = 'https://www.facebook.com/AGLA-103078671237266/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMaxomURL() async {
    const url = 'https://maxom.ci';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  }



