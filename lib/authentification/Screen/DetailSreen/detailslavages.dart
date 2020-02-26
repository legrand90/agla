import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Prestations.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;



class DetailsLavage extends StatefulWidget {

  int idlav ;

  DetailsLavage({Key key, @required this.idlav}) : super(key: key);

  @override
  _DetailsLavageState createState() => _DetailsLavageState(idlav);
}

class _DetailsLavageState extends State<DetailsLavage> {

  int idlav ;

  var data ;

  var DATE ;

  var libelle ;

  var situation ;

  bool load = true;

  _DetailsLavageState(this.idlav);

  @override

  void initState(){
    super.initState();
    this.getLavage();
    this.getUserName();

  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
        child:Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Text('DETAILS DU LAVAGE'),
            ),
            body: load ? ListView(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),

                Container(
                  margin: EdgeInsets.only(left: 25.0),
                  child: Text("DATE ===> $DATE"),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25.0),
                  child: Text("NOM DU LAVAGE ===> $libelle"),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                ),

                Container(
                  margin: EdgeInsets.only(left: 25.0),
                  child: Text("SITUATION GEOGRAPHIQUE ===> $situation"),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                ),

//            Container(
//              margin: EdgeInsets.only(left: 25.0),
//              child: Text("MONTANT ===> $data"),
//            ),

              ],
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
            ) : Center(child: CircularProgressIndicator(),),)
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


  void getLavage() async {

    //final String url = "http://192.168.43.217:8000/api/getPrestation/$idpresta/$idlavage"  ;

    var res = await CallApi().getData('getLavage/$idlav');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      libelle = resBody['libelle_lavage'];
      situation = resBody['situation_geo'];
      DATE = resBody['dateEnreg'];
      //idTari = resBody['id'];
    });


    // print('identi est $idpresta');

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



