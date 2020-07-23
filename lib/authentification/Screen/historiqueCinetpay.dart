import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Cinetpay.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Models/Transaction.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsclient.dart';
import 'package:lavage/authentification/Screen/Edit/editclient.dart';
import 'package:lavage/authentification/Screen/Edit/edtitransaction.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//import '../Transaction.dart';
//import '../login_page.dart';
//import 'package:http/http.dart' as http;

import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'dashbord.dart';
import 'historique.dart';
import 'login_page.dart';

class HistoriqueCinetpayTrans extends StatefulWidget {

  Listclients listclients = Listclients () ;

  HistoriqueCinetpayTrans({Key key, @required this.listclients}) : super(key: key);

  @override
  _HistoriqueCinetpayTransState createState() => _HistoriqueCinetpayTransState(listclients);
}

class _HistoriqueCinetpayTransState extends State<HistoriqueCinetpayTrans>{

  Listtransactions listtransac = Listtransactions();

  Listclients listclients = Listclients();

  _HistoriqueCinetpayTransState(this.listclients);

  var admin;
  var idcli;
  var idtrans;
  bool load = true;
  bool chargement = false;

  ListcinetpayTrans listcynetpay = ListcinetpayTrans();

  void getCynetpayTransactions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //final String urlTrans = "http://192.168.43.217:8000/api/Transaction/$id";
    var res = await CallApi().getData('getCinetpayTransAdmin');

    if(res.statusCode == 200){
      var resBody = json.decode(res.body)['data'];
      setState(() {
        listcynetpay = listcinetpayTransFromJson(res.body);
        chargement = true;

      });
    }
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
    this.getUserName();
    this.getCynetpayTransactions();
    this.getStatut();
  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
        child:Scaffold(
          key: _scaffoldKey,
          // backgroundColor: Colors.grey[200],
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  pinned: true,
                  title: new Text('HISTORIQUE'),
                ),
              ];
            },
            //title: Text('HISTORIQUE'),
            body: ListView(
              //shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  SizedBox(height: 40.0,),
                  Center(
                    //margin: EdgeInsets.only(left: 20.0,),
                    child: Text("INFOS TRANSACTIONS CINETPAY", style: TextStyle(fontSize: 18.0)),
                  ),

                  SizedBox(height: 40.0,),

                  chargement ? Container(
                      height: 470.0,
                      child:

                      ListView.builder(
                        // shrinkWrap: true,
                        //  physics: ClampingScrollPhysics(),
                        itemCount: (listcynetpay == null || listcynetpay.data == null || listcynetpay.data.length == 0 )? 0 : listcynetpay.data.length,
                        itemBuilder: (_,int index)=>Container(
                            child : Card(child :ListTile(
                              title: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text('DATE : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listcynetpay.data [index].dateEnreg}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('LAVAGE : '),
                                      SizedBox(width: 20.0,),
                                      Expanded(child: Text('${listcynetpay.data [index].lavage}'),)
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('NUMERO : '),
                                      SizedBox(width: 20.0,),
                                      Expanded(child: Text('${listcynetpay.data [index].tel}'),)
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('ID TRANSACTION : '),
                                      SizedBox(width: 20.0,),
                                      Expanded(child: Text('${listcynetpay.data [index].idTransaction}'),)

                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('MOYEN DE PAIEMENT : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listcynetpay.data [index].moyenPaiement}'),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('NOMBRE JOUR(S) AVANT : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listcynetpay.data [index].jourAvant} '),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('NOMBRE JOUR(S) APRES : '),
                                      SizedBox(width: 20.0,),
                                      Text('${listcynetpay.data [index].jourApres}'),
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
                      )) : Center(child: CircularProgressIndicator(),) ,

                ]),

//        ListView.builder(
//          itemCount: (listclients == null || listclients.data == null || listclients.data.length == 0 )? 0 : listclients.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listclients.data [index].nom),
//            onTap: (){
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => DetailsClient(
//                      idclient : listclients.data[index].id,
//                      nom : listclients.data[index].nom,
//                      contact : listclients.data[index].contact,
//                      email : listclients.data[index].email,
//                    // matricule : listclients.data[index].matricule,
//                      idmarque : listclients.data[index].idMarque,
//                      idcouleur : listclients.data[index].idCouleur,
//                      dateEnreg : listclients.data[index].dateEnreg,
//                    ),
//                  ));
//            },
//          ),
//        ),

          ),

          bottomNavigationBar: BottomNavigationBar(
            //backgroundColor: Color(0xff0200F4),
            //currentIndex: 0, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                //backgroundColor: Color(0xff0200F4),
                icon: new IconButton(
                  color: Color(0xfff80003),
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
                  color: Color(0xfff80003),
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
                    color: Color(0xfff80003),
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
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff003372),
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
                    await _alertDeconnexion();

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
                  accountEmail: (adm == '0' || adm == '1') ? Text('Lavage: $libLavage \nVous êtes $statu') : Text('Vous êtes $statu'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff003372),
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
        )
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

  void getUserName() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userName = localStorage.getString('nom');

    setState(() {
      nameUser = userName;
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



