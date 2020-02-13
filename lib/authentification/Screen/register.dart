import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/Agent.dart';
import 'package:lavage/authentification/Screen/Couleur.dart';
import 'package:lavage/authentification/Screen/Listes/listusers_pw.dart';
import 'package:lavage/authentification/Screen/Marque.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/commission.dart';
import 'package:lavage/authentification/Screen/create_user.dart';
import 'package:lavage/authentification/Screen/lavage.dart';
import 'package:lavage/authentification/Screen/matricule.dart';
import 'package:lavage/authentification/Screen/prestation.dart';
import 'package:lavage/authentification/Screen/tarification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Listes/listtarification.dart';
import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'dashbord.dart';
import 'historique.dart';
import 'login_page.dart';

class Register extends StatefulWidget {

  @override

  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  @override
  void initState(){
    super.initState();
    this.getUserName();
  }

  Widget build(BuildContext context){
    return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text('SERVICES', textAlign: TextAlign.center,),
          ),
          body: Center(
            child: new Container(
              margin: EdgeInsets.only(top: 60.0, left: 30.0),
              child: new ListView(
               // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //CARD1
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                width: 150.0,
                                height: 140.0,
                                child : FlatButton(
                                  color: Color(0xff11b719),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return Commission();
                                      },
                                    ),
                                  );
                                },
                                child: Text('Commission'),
                              )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Couleur();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Couleur'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),


                    ],
                  ),

                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return TarificationList();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Tarification'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Prestation();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Prestation'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),


                    ],
                  ),

                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Client();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Client'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Agent();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Agent'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Marque();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Marque'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Matricule();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Matricule'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),


                    ],
                  ),

                  (admin == '2') ? Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Lavage();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Lavages'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return User();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Utilisateurs'),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),


                    ],
                  ) : Text(''),

                  (admin == '2') ? Row(
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        height: 140.0,
                        child: new Card(
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 150.0,
                                  height: 140.0,
                                  child : FlatButton(
                                    color: Color(0xff11b719),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ListUsers();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Réinitialiser mot de passe', textAlign: TextAlign.center,),
                                  )),
                            ),
                            /*
                        new Stack(
                          children: <Widget>[
                            new Image.asset(
                              'assets/mobile1.png',
                              width: 200.0,
                              height: 120.0,
                            ),
                          ],
                        ),
                        */
                            //   onTap{("")}
                          ),
                        ),
                      ),


                    ],
                  ) : Text(''),
                ],
              ),
            ),
          ),

      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('$nameUser'),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Color(0xff11b719),
              ),
            ),
            ListTile(
              title: Text('Accueil'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DashbordScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Nouvelle Entree'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Transaction();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Recherche'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ClientPage();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Historique'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Historique();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Parametre'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Register();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Deconnexion'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
        );
  }

  void _logout() async{
    var res = await CallApi().getData('logout');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString('token');
      localStorage.remove('token');
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

    //print('la valeur de admin est : $admin');

  }
}



