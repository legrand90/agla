import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  Listtransactions listtransa = Listtransactions();

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
        listtransa = listtransactionsFromJson(res.body);
        toggle = true;
        affiche = true;

      });
    }


    print('donnees json : $listtransa');

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

  final GlobalKey <ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();

  _showMsg(msg) {
    final snackBar = SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Fermer',
          onPressed: () {

          },
        )
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
        key: _scaffoldKey,
        //ackgroundColor: Color(0xFFDADADA),
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  pinned: true,
                  title: new Text('LISTES DES TRANSACTIONS'),
                ),
              ];
            },
            body:ListView(
              //shrinkWrap: true,
                scrollDirection: Axis.vertical,
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

                  Container(
                      height: 500.0,
                      child:

                      ListView.builder(
                        // shrinkWrap: true,
                        //  physics: ClampingScrollPhysics(),
                        itemCount: (listtransa == null || listtransa.data == null || listtransa.data.length == 0 )? 0 : listtransa.data.length,
                        itemBuilder: (_,int index)=>Container(
                            child : Card(child :ListTile(
                              title: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text('DATE : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listtransa.data [index].date}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('AGENT : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listtransa.data [index].agent}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('CLIENT : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listtransa.data [index].client}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('PLAQUE D\'IMMATRICULATION : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listtransa.data [index].plaqueImmatriculation}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('PRESTATION : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listtransa.data [index].prestation}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('TARIFICATION : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listtransa.data [index].tarification}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('COMMISSION : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listtransa.data [index].commission}'),
                                    ],
                                  ),
                                  // SizedBox(height: 20.0,),
                                  // Divider(color: Colors.white, height: 10.0,),
                                ],
                              ),



//                onTap: (){
////                  Navigator.push(
////                      context,
////                      MaterialPageRoute(
////                        builder: (context) => DetailsPrestation(idpresta: listprestations.data[index].id),
////                      ));
//                },
                            ), color: Color(0xff11b719),)
                        ),
                      ))

                ])
        ) ,
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
                        builder: (BuildContext context){
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

