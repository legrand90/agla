import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Commission.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsCommission.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/Tabs/periodeTabPage.dart';
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

  @override

  void initState(){
    this.getUserName();
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override

  Widget build(BuildContext context){
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          title: Text(''),
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
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            AgentTabPage(),
            ClientTabPage(),
          //  PrestationTabPage(),
           // PeriodeTabPage(),
          ],
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
        ),
      ),
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
}



