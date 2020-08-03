import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Commission.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsCommission.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/Tabs/clientTabPage.dart';
import 'package:lavage/authentification/Screen/Tabs/comptabiliteTabPage.dart';
import 'package:lavage/authentification/Screen/Tabs/prestationTabPage.dart';
import 'package:lavage/authentification/Screen/TabsCinetpay/historiqueTrans.dart';
import 'package:lavage/authentification/Screen/TabsCinetpay/renewAbonnement.dart';
import 'package:lavage/authentification/Screen/TabsTransactionPaiement/paimentAgent.dart';
import 'package:lavage/authentification/Screen/TabsTransactionPaiement/searchPaiement.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/prestation.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

//import 'creditAgent.dart';



class CinetpayTab extends StatefulWidget {

  final Widget child ;

  CinetpayTab({Key key, @required this.child}) : super(key: key);

  @override
  _CinetpayTabState createState() => _CinetpayTabState();
}

Color PrimaryColor = Color(0xff0200F4) ;

Color boxDeco = Color(0xff0200F4) ;

class _CinetpayTabState extends State<CinetpayTab> with SingleTickerProviderStateMixin{

  TabController _tabController ;

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
    this.getUserName();
    this.getStatut();
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override

  Widget build(BuildContext context){
    return  DefaultTabController(
        length: 2,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color(0xFFDADADA),
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    actions: <Widget>[
                    ],

                    pinned: true,
                    bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      indicatorWeight: 6.0,
                      onTap: (index){
                        setState(() {
                          switch(index){
                            case 0:
                              PrimaryColor = Color(0xff0200F4);
                              boxDeco = Color(0xff0200F4);
                              break;
                            case 1:
                              PrimaryColor = Color(0xff0200F4);
                              boxDeco = Color(0xff0200F4);
                              break;
                            default:
                          }
                        });

                      },

                      tabs: <Widget>[
                        Tab(
                          child: Container(
                              child: Text(
                                'ABONNEMENT',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              )
                          ) ,
                        ),

                        Tab(
                          child: Container(
                              child: Text(
                                'HISTORIQUE',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              )
                          ) ,
                        ),

                      ],
                    ),
                  ),
                ];
              },
              // backgroundColor: PrimaryColor,
              //  title: Text(''),
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Abonnement(),
                  HistoriqueTrans(),
                ],
              ),
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

            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there is't enough vertical
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
                    title: Text('Transactions'),
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
                    title: Text('Tutoriel'),
                    onTap: () async{

                    },
                  ),
                  ListTile(
                    title: Text('A propos'),
                    onTap: () async{

                    },
                  ),
                  ListTile(
                    title: Text('Deconnexion'),
                    onTap: () {
                      _alertDeconnexion();
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
              ),
            )
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
  var isadmin;

  void getUserName() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userName = localStorage.getString('nom');

    setState(() {
      nameUser = userName;
      isadmin = localStorage.getString('Admin');
    });

    print('la valeur de admin est : $isadmin');

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



