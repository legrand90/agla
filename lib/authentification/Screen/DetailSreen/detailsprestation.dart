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



class DetailsPrestation extends StatefulWidget {

     int idpresta ;

  DetailsPrestation({Key key, @required this.idpresta}) : super(key: key);

  @override
  _DetailsPrestationState createState() => _DetailsPrestationState(idpresta);
}

class _DetailsPrestationState extends State<DetailsPrestation> {

  int idpresta ;

  var data ;

  var libelle ;

  var descrip ;

  _DetailsPrestationState(this.idpresta);

  @override

  void initState(){
    super.initState();
    this.getTarification();
    this.getPrestation();
    this.getUserName();

  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('DETAILS DE LA PRESTATIONS'),
        ),
        body:ListView(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("PRESTATION ===> $libelle"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("DESCRIPTION ===> $descrip"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

//            Container(
//              margin: EdgeInsets.only(left: 25.0),
//              child: Text("MONTANT ===> $data"),
//            ),

          ],
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


      ]),
    ))
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

    void getTarification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String urlTari = "http://192.168.43.217:8000/api/getTarification/$idpresta/$id" ;

    var res = await CallApi().getData('getTarification/$idpresta/$id');

//    setState(() {
//      param = _mySelection3;
//    });

    //var chaine = param + urlTari ;

//    final res = await http.get(Uri.encodeFull(urlTari), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      data = resBody['montant'];
      //idTari = resBody['id'];
    });


    print('identi est $idpresta');

  }


  void getPrestation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String url = "http://192.168.43.217:8000/api/getPrestation/$idpresta/$idlavage"  ;

    var res = await CallApi().getData('getPrestation/$idpresta/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      libelle = resBody['libelle_prestation'];
      descrip = resBody['descrip_prestation'];
      //idTari = resBody['id'];
    });


   // print('identi est $idpresta');

  }

  var nameUser;

  void getUserName() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userName = localStorage.getString('nom');

    setState(() {
      nameUser = userName;
    });

    //print('la valeur de admin est : $admin');

  }

}



