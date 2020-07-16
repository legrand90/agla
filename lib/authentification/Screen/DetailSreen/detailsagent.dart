import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Prestations.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;


class DetailsAgent extends StatefulWidget {

  int idagent ;

  DetailsAgent({Key key, @required this.idagent}) : super(key: key);

  @override
  _DetailsAgentState createState() => _DetailsAgentState(idagent);
}

class _DetailsAgentState extends State<DetailsAgent> {

  int idagent ;

  var nom ;
  var contact ;
  var contactUrgence ;
  var quartier ;
  var dateEnreg ;

  _DetailsAgentState(this.idagent);

  bool load = true ;

  @override

  void initState(){
    super.initState();
    this.getAgent();
    this.getUserName();
    this.getStatut();

  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('DETAILS AGENT'),
        ),
        body: load ? ListView(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("NOM ===> $nom"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("CONTACT ===> $contact"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("CONTACT D'URGENCE ===> $contactUrgence"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("QUARTIER ===> $quartier"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("DATE ===> $dateEnreg"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("N° CNI ===> $numCni"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("DATE DE NAISSANCE ===> $dateNaiss"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

          ],
        ) : Center(child: CircularProgressIndicator(),),

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

                  setState((){
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
          ),
        ) : Center(child: CircularProgressIndicator(),),));
  }

  var dateNaiss;
  var numCni;
  var urlPhoto;

  Future<Map<String, dynamic>> getImage() async{
    var res = await CallApi().getData('getPhoto/$urlPhoto');

    return json.decode(res.body);


    //print('la valeur de admin est : $admin');

  }

  void getAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String url = "http://192.168.43.217:8000/api/getAgent/$idagent/$idlavage"  ;

    var res = await CallApi().getData('getAgent/$idagent/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      nom = resBody['nom'];
      contact = resBody['contact'];
      contactUrgence = resBody['contactUrgence'];
      quartier = resBody['quartier'];
      dateEnreg = resBody['dateEnreg'];
      dateNaiss = resBody['dateNaiss'];
      numCni = resBody['numero_cni'];
      urlPhoto = resBody['photo'];
      //idTari = resBody['id'];
    });



    // print('identi est $idpresta');

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



