import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Models/Transaction.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsclient.dart';
import 'package:lavage/authentification/Screen/Edit/editclient.dart';
import 'package:lavage/authentification/Screen/Edit/edtitransaction.dart';
import 'package:lavage/authentification/Screen/apropos.dart';
import 'package:lavage/authentification/Screen/client.dart';
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

class Tutoriel extends StatefulWidget {

  Listclients listclients = Listclients () ;

  Tutoriel({Key key, @required this.listclients}) : super(key: key);

  @override
  _TutorielState createState() => _TutorielState(listclients);
}

class _TutorielState extends State<Tutoriel>{

  Listtransactions listtransac = Listtransactions();

  Listclients listclients = Listclients();

  _TutorielState(this.listclients);

  var admin;
  var idcli;
  var idtrans;
  bool load = true;
  bool chargement = false;

  Future<dynamic> getPost() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //String url = "http://192.168.43.217:8000/api/Transaction/$id";
    var res = await CallApi().getData('Transaction/$id');
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');
    setState(() {
      //listclients = listclientsFromJson(res.body);
      listtransac = listtransactionsFromJson(res.body);
      chargement = true;
    });
    return listclients;
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


  Future<bool> _alertAgent(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 70.0, right: 70.0),
          title: ListView(
            shrinkWrap: true,
            children: [
            Text('Pour créer un Agent :'),
              SizedBox(height: 20.0,),
              Text('1-Cliquer sur le menu Paramètre'),
              Text('2-Cliquer sur Gestion Agent'),
              Text('3-Cliquer sur Agent'),
          ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  Future<bool> _alertClient(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 70.0, right: 70.0),
          title: ListView(
            shrinkWrap: true,
            children: [
              Text('Pour créer un Client :'),
              SizedBox(height: 20.0,),
              Text('1-Cliquer sur le menu Paramètre'),
              Text('2-Cliquer sur Gestion Client'),
              Text('3-Cliquer sur Client'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  Future<bool> _alertPrestation(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 70.0, right: 70.0),
          title: ListView(
            shrinkWrap: true,
            children: [
              Text('Pour créer une Prestaion :'),
              SizedBox(height: 20.0,),
              Text('1-Cliquer sur le menu Paramètre'),
              Text('2-Cliquer sur Configuration'),
              Text('3-Cliquer sur Prestation'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }


  Future<bool> _alertCommission(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 70.0, right: 70.0),
          title: ListView(
            shrinkWrap: true,
            children: [
              Text('Pour créer une Commission :'),
              SizedBox(height: 20.0,),
              Text('1-Cliquer sur le menu Paramètre'),
              Text('2-Cliquer sur Gestion Agent'),
              Text('3-Cliquer sur Commission'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }


  Future<bool> _alertTransaction(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 70.0, right: 70.0),
          title: ListView(
            shrinkWrap: true,
            children: [
              Text('Pour effectuer une transaction :'),
              SizedBox(height: 20.0,),
              Text('1-Cliquer sur le menu Paramètre'),
              Text('2-Cliquer sur Nouvelle Entrée'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  Future<bool> _alertSoldeAgent(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 70.0, right: 70.0),
          title: ListView(
            shrinkWrap: true,
            children: [
              Text('Pour consulter le solde des agents :'),
              SizedBox(height: 20.0,),
              Text('1-Cliquer sur le menu Paramètre'),
              Text('2-Cliquer sur Finances'),
              Text('3-Cliquer sur Soldes'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  Future<bool> _alertRenewAbon(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 70.0, right: 70.0),
          title: ListView(
            shrinkWrap: true,
            children: [
              Text('Pour renouveller l\'abonnement :'),
              SizedBox(height: 20.0,),
              Text('1-Cliquer sur le menu Paramètre'),
              Text('2-Cliquer sur Finances'),
              Text('3-Cliquer sur Abonnement'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  @override
  void initState(){
    super.initState();
    this.getUserName();
    this.getPost();
    this.getStatut();
    this.getUserName();
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
                  title: new Text('TUTORIEL'),
                ),
              ];
            },
            //title: Text('HISTORIQUE'),
            body: ListView(
                scrollDirection: Axis.vertical,

                children: <Widget>[

                  SizedBox(height: 50.0,),

                  Container(child: Text('GUIDE D\'AIDE AGLA', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0),),),

                  SizedBox(height: 50.0,),

                  ListView (
                      shrinkWrap: true,
                      children: <Widget>[
                        new Container (

                            child: Expanded(
                              child: new FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              ),
                              color: Color(0xff003372),
                              onPressed: (){
                                _alertAgent();
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
                                        "Comment créer un Agent ?",
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
                            )),
                        ),

                        new Container (
                            child: Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)
                                  ),
                                  color: Color(0xff003372),
                                  onPressed: (){
                                    _alertClient();
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
                                            "Comment créer un Client ?",
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
                                )),
                        ),

                        new Container(
                            child: Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)
                                  ),
                                  color: Color(0xff003372),
                                  onPressed: (){
                                    _alertPrestation();
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
                                            "Comment créer une Prestation ?",
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
                                )),
                        ),

                        Container (
                            child: Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)
                                  ),
                                  color: Color(0xff003372),
                                  onPressed: (){
                                    _alertCommission();
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
                                            "Comment créer une Commission?",
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
                                )),
                        ),

                        Container(
                            child: Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)
                                  ),
                                  color: Color(0xff003372),
                                  onPressed: (){
                                    _alertTransaction();
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
                                            "Comment effectuer une Transaction?",
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
                                )),
                        ),

                        Container (
                          child: Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff003372),
                                onPressed: (){
                                  _alertSoldeAgent();
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
                                          "Solde des Agents ?",
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
                              )),
                        ),

                        Container(
                          child: Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff003372),
                                onPressed: (){
                                  _alertRenewAbon();
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
                                          "Renouveler l\'abonnement ?",
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
                              )),
                        ),
                      ]
                  )


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
//                      nom : listclients.data[inde x].nom,
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

          bottomNavigationBar: (adm == '0' || adm == '1') ? BottomNavigationBar(
            //backgroundColor: Color(0xff0200F4),
            //currentIndex: 0, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                //backgroundColor: Color(0xff0200F4),
                icon: new IconButton(
                  color: Color(0xfff80003),
                  icon: Icon(Icons.group_add),
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
                ),
                title: new Text('Nouveau Client', style: TextStyle(color: Color(0xff0200F4))),
              ),
              BottomNavigationBarItem(
                icon: new IconButton(
                  color: Color(0xfff80003),
                  icon: Icon(Icons.home),
                  onPressed: (){
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
                title: new Text('Accueil', style: TextStyle(color: Color(0xff0200F4))),
              ),
              BottomNavigationBarItem(
                  icon: IconButton(
                    color: Color(0xfff80003),
                    icon: Icon(Icons.edit),
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
                  title: Text('Nouvelle Entrée', style: TextStyle(color: Color(0xff0200F4)),)
              )
            ],
          ) : Text(''),

          drawer: load ? Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
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
                  title: Text('Nouvelle Entrée'),
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
                  title: Text('Transactions'),
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
                  title: Text('Paramètres'),
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
                    await Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Apropos();
                        },
                      ),
                    );

                    setState(() {
                      load = true;
                    });
                  },
                ),
                ListTile(
                  title: Text('Déconnexion'),
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

                          _launchMaxomURL();
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
    const url = 'https://agla.app';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}



