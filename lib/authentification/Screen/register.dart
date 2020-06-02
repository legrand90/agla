import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/Agent.dart';
import 'package:lavage/authentification/Screen/Couleur.dart';
import 'package:lavage/authentification/Screen/Listes/listlog.dart';
import 'package:lavage/authentification/Screen/Listes/listusers_pw.dart';
import 'package:lavage/authentification/Screen/Marque.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/commission.dart';
import 'package:lavage/authentification/Screen/create_user.dart';
import 'package:lavage/authentification/Screen/lavage.dart';
import 'package:lavage/authentification/Screen/matricule.dart';
import 'package:lavage/authentification/Screen/photo.dart';
import 'package:lavage/authentification/Screen/prestation.dart';
import 'package:lavage/authentification/Screen/solde.dart';
import 'package:lavage/authentification/Screen/tarification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';


import 'Listes/listtarification.dart';
import 'Tabs/clientPage.dart';
import 'TabsTransactionPaiement/paiementTab.dart';
import 'Transaction.dart';
import 'create_superAdmin.dart';
import 'dashbord.dart';
import 'gestionAbonnement.dart';
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
    this.getStatut();
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
                                  color: Color(0xff0200F4),
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
                                child: Text('Commission',style: TextStyle(color: Colors.white),),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Matricule',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Tarification',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Prestation',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Client',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Agent',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ListSolde();
                                          },
                                        ),
                                      );

                                      setState(() {
                                        load = true;
                                      });
                                    },
                                    child: Text('Soldes',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });

                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return PaimentTab();
                                          },
                                        ),
                                      );


                                      setState(() {
                                        load = true;
                                      });
                                    },
                                    child: Text('Transaction Paiement',style: TextStyle(color: Colors.white)),
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

                  (admin == '2' || admin == '3' || admin == '4') ? Row(
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Marque',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Couleur',style: TextStyle(color: Colors.white)),
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

                  (admin == '2' || admin == '3' || admin == '4') ? Row(
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Lavages',style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Utilisateurs',style: TextStyle(color: Colors.white)),
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

                  (admin == '2' || admin == '3' || admin == '4') ? Row(
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Réinitialiser mot de passe', textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
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
                                    child: Text('Creér Super Admin', textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
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

                  (admin == '2' || admin == '3' || admin == '4') ? Row(
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
                                    color: Color(0xff0200F4),
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ListLogs();
                                          },
                                        ),
                                      );
                                      setState(() {
                                        load = true;
                                      });
                                    },
                                    child: Text('LOG', textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
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
                                    color: Color(0xff0200F4),
                                    onPressed: () async{
                                      setState(() {
                                        load = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return GestionAbonnement();
                                          },
                                        ),
                                      );
                                      setState(() {
                                        load = true;
                                      });
                                    },
                                    child: Text('Gestion Abonnement', textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
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
          ) : Center(child: CircularProgressIndicator(),),

      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Color(0xff0200F4),
        //currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            //backgroundColor: Color(0xff0200F4),
            icon: new IconButton(
              color: Color(0xff0200F4),
              icon: Icon(Icons.settings),
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
            ),
            title: new Text('Paramètre', style: TextStyle(color: Color(0xff0200F4))),
          ),
          BottomNavigationBarItem(
            icon: new IconButton(
              color: Color(0xff0200F4),
              icon: Icon(Icons.mode_edit),
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
            ),
            title: new Text('Nouvelle Entrée', style: TextStyle(color: Color(0xff0200F4))),
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                color: Color(0xff0200F4),
                icon: Icon(Icons.search),
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
              ),
              title: Text('Recherche', style: TextStyle(color: Color(0xff0200F4)),)
          )
        ],
      ),

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
              margin: const EdgeInsets.only(top: 55.0,),
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

                      await _launchMaxomURL();
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
              margin: const EdgeInsets.only(top: 210.0,),
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
                      await _launchMaxomURL();
                    },
                  ),
                ],
              ),
            )

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



