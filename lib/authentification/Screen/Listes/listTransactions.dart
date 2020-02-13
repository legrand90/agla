import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:json_table/json_table.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Transaction.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import '../register.dart';

class ListTransaction extends StatefulWidget {
  @override
  _ListTransactionState createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {

  var json2 ;
  bool toggle = false;
  var affiche = false;

  void getTransactions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //final String urlTrans = "http://192.168.43.217:8000/api/Transaction/$id";
    var res = await CallApi().getData('Transaction/$id');
    //final res = await http.get(Uri.encodeFull(urlTrans), headers: {"Accept": "application/json","Content-type" : "application/json",});
//    final res2 = await http.get(Uri.encodeFull(urlTrans), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    if(res.statusCode == 200){

      var resBody = json.decode(res.body)['data'];

      setState(() {
        json2 = resBody;
        toggle = true;
        affiche = true;

      });
    }


    print('donnees json : $json2');

  }

  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  var recette;
  var commissions;
  var totalTarif;
  void getRecette() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
   // String url = "http://192.168.43.217:8000/api/getCommissionsAndRecette/$date/$id";
    var res = await CallApi().getData('getCommissionsAndRecette/$date/$id');
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body);
    // final response = await http.get('$url');

    setState(() {
      recette = resBody['recette'];
      commissions = resBody['commissions'];
      totalTarif = recette + commissions;
    });

    //print("la recette est  : ${recette['recette']}");

  }
    @override
    void initState(){
      super.initState();
      this.getRecette();
      this.getUserName();
      this.getTransactions();
    }
    Widget build(BuildContext context){
      var json = json2;

      //SystemChrome.setPreferredOrientations([
       // DeviceOrientation.landscapeLeft,
       // DeviceOrientation.landscapeRight
      //]);

        return Scaffold(
            backgroundColor: Color(0xFFDADADA),
            appBar: AppBar(
              title: Text('LISTES DES TRANSACTIONS'),
            ),
            body: affiche ? ListView(
              children: <Widget>[
                SizedBox(height: 40.0,),
                Container(
                  margin: EdgeInsets.only(left: 20.0,),
                  child: Text("TOTAL TARIFICATIONS : $totalTarif FCFA"),
                ),

                SizedBox(height: 40.0,),
                Container(
                  margin: EdgeInsets.only(left: 15.0,),
                  child: Text("TOTAL COMMISSIONS : $commissions FCFA"),
                ),

                SizedBox(height: 40.0,),
                Container(
                  margin: EdgeInsets.only(left: 15.0,),
                  child: Text("RECETTE : $recette FCFA"),
                ),

                SizedBox(height: 40.0,),
                toggle ? JsonTable(json,
                  tableHeaderBuilder: (String header) {
                    return
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.5),
                            color: Colors.grey[300]),
                        child: Text(
                          header,
                          textAlign: TextAlign.center,
                          style: Theme
                              .of(context)
                              .textTheme
                              .display1
                              .copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                              color: Colors.blue),
                        ),
                      );
                  },
                  tableCellBuilder: (value) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey.withOpacity(0.5))),
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .display1
                            .copyWith(
                            fontSize: 18.0, color: Colors.grey[900]),
                      ),
                    );
                  },
                  allowRowHighlight: true,
                  rowHighlightColor: Colors.yellow[500].withOpacity(0.7),

                ) : CircularProgressIndicator(),
              ],
            ) : Text(" "),
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
              //_logout();
            },
          ),
        ]),

        ));

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

  void getUserName() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userName = localStorage.getString('nom');

    setState(() {
      nameUser = userName;
    });

    //print('la valeur de admin est : $admin');

  }
  }

