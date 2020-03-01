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
import 'package:flutter_html/flutter_html.dart';


import 'Listes/listtarification.dart';
import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'create_superAdmin.dart';
import 'dashbord.dart';
import 'historique.dart';
import 'login_page.dart';

class Register extends StatefulWidget {

  @override

  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool load = true;


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
          body: load ? Center(
            child: new Container(
              margin: EdgeInsets.only(top: 110.0, left: 30.0),
              child: new ListView(
               // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //CARD1
                  (admin == '0' || admin == '1') ? Row(
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
                                onPressed: ()async{
                                    setState(() {
                                      load = false;
                                    });
                                  await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return Commission();
                                      },
                                    ),
                                  );
                                  setState(() {
                                    load =true;
                                  });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Matricule();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                  ) : Text(''),

                  (admin == '0' || admin == '1') ? Row(
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return TarificationList();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Prestation();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                  ) : Text(''),

                  (admin == '0' || admin == '1') ? Row(
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Client();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Agent();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Marque();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Couleur();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                     await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Lavage();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                     await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return User();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ListUsers();
                                          },
                                        ),
                                      );
                                      setState(() {
                                        load = true;
                                      });
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
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return SuperAdmin();
                                          },
                                        ),
                                      );
                                      setState(() {
                                        load = true;
                                      });
                                    },
                                    child: Text('Creér Super Admin', textAlign: TextAlign.center,),
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
                      )


                    ],
                  ) : Text(''),
                ],
              ),
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
              onTap: () async{
                setState(() {
                  load = false;
                });
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DashbordScreen();
                    },
                  ),
                );

                setState(() {
                  load = true;
                });
              },
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
              title: Text('Deconnexion'),
              onTap: () async{
                setState(() {
                  load = false;
                });
                await _logout();

                setState(() {
                  load = true;
                });
              },
            ),

          ],
        ) : ListView(
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
              onTap: () async{
                setState(() {
                  load = false;
                });
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DashbordScreen();
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
              title: Text('Deconnexion'),
              onTap: () async{
                setState(() {
                  load = false;
                });
                await _logout();

                setState(() {
                  load = true;
                });
              },
            ),

          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),
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



