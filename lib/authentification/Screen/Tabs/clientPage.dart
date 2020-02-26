import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Commission.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsCommission.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/Tabs/comptabiliteTabPage.dart';
import 'package:lavage/authentification/Screen/Tabs/prestationTabPage.dart';
import 'package:lavage/authentification/Screen/prestation.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

import 'agentTabPage.dart';
import 'clientTabPage.dart';

class ClientPage extends StatefulWidget {

 final Widget child ;

  ClientPage({Key key, @required this.child}) : super(key: key);

  @override
  _ClientPagetState createState() => _ClientPagetState();
}

  Color PrimaryColor = Color(0xff109618) ;

  Color boxDeco = Color(0xff109618) ;

class _ClientPagetState extends State<ClientPage> with SingleTickerProviderStateMixin{

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
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override

  Widget build(BuildContext context){
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
          backgroundColor: Color(0xFFDADADA),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
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
                          PrimaryColor = Color(0xff109618);
                          boxDeco = Color(0xff109618);
                          break;
                        case 1:
                          PrimaryColor = Color(0xff109618);
                          boxDeco = Color(0xff109618);
                          break;
                        default:
                      }
                    });

                  },

                  tabs: <Widget>[
                    Tab(
                      child: Container(
                          child: Text(
                            'AGENT',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          )
                      ) ,
                    ),

                    (isadmin == '1' || isadmin == '2') ? Tab(
                      child: Container(
                          child: Text(
                            'COMPTABILITE',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          )
                      ) ,
                    ) : Text(''),

                    Tab(
                      child: Container(
                          child: Text(
                            'CLIENT',
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
            AgentTabPage(),
            ComptabiliteTabPage(),
            ClientTabPage(),
          //  PrestationTabPage(),
           // PeriodeTabPage(),
          ],
        ),

      ),

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
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: boxDeco,
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
}



