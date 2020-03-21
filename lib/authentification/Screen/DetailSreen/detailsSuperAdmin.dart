import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
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


class DetailsSuperAdmin extends StatefulWidget {

  int idUser ;

  DetailsSuperAdmin({Key key, @required this.idUser}) : super(key: key);

  @override
  _DetailsSuperAdminState createState() => _DetailsSuperAdminState(idUser);
}

class _DetailsSuperAdminState extends State<DetailsSuperAdmin> {

  int idUser ;

  var nom ;
  var contact ;
  var contactUrgence ;
  var quartier ;
  var dateEnreg ;
  bool load = true;
  bool _switchVal = true;

  _DetailsSuperAdminState(this.idUser);

  void DesactivateUser() async{
    var data = {
      'password': 'desactiver',
      // 'id_lavage': id
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().postDataEdit(data, 'desactiverUser/${this.idUser}');
    var resbody = json.decode(res.body);

    if(resbody['statut'] == 'success'){
      setState(() {
        _switchVal = false;
      });
      print("pass $_switchVal");
      _showMsg('$nom a été désactivé avec success !');
    }else{
      _showMsg('La désactivation a échoué !');
    }


    print("${this.idUser}");

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
    //this.DesactivateUser();
    this.getUser();
    this.getUserName();
    this.getStatut();

  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        key: _scaffoldKey,
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
              child: Text("EMAIL ===> $email"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Text("STATUT ===> $statut"),
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
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              //margin: EdgeInsets.only(left: 25.0),
              child: Switch(
                onChanged: (bool value)async{

                  Future<bool> _sureToDelete(){
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Voulez-vous vraiment désactiver $nom ? "),
                          actions: <Widget>[
                            FlatButton(
                                child: Text("Non"),
                                onPressed: () {
                                  setState(() {
                                    _switchVal = true;
                                  });
                                  Navigator.pop(context, false);

                                }
                            ),
                            FlatButton(
                              child: Text("Oui"),
                              onPressed: () {
                                DesactivateUser();
                                Navigator.pop(context, false);
                              }
                              ,
                            )
                          ],
                        )
                    );
                  }
                  setState(() {
                    this._switchVal = value;
                  });

                  if(_switchVal == false){
                    _sureToDelete();
                  }
                },
                value: this._switchVal,
              ),
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
                color: Color(0xff0200F4),
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
                color: Color(0xff0200F4),
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
                  color: Color(0xff0200F4),
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
          child: (admin2 == '0' || admin2 == '1') ? ListView(
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
                  color: Color(0xff0200F4),
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
                  color: Color(0xff0200F4),
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
        ) : Center(child: CircularProgressIndicator(),),),
    );
  }

  var email;
  var statut;
  var nomLavage;
  var situation;
  var admin;
  var password;

  void getUser() async {


    //final String url = "http://192.168.43.217:8000/api/getAgent/$idagent/$idlavage"  ;

    var res = await CallApi().getData('getUserSuperAdmin/$idUser');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      nom = resBody['nom'];
      contact = resBody['numero'];
      email = resBody['email'];
      statut = resBody['status'];
      admin = resBody['admin'];
      dateEnreg = resBody['dateEnreg'];

      //idTari = resBody['id'];
    });

    if(resBody['password'] == 'desactiver'){

      setState((){
        _switchVal = false;
      });

    }else{
      _switchVal = true;
    }



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
  var admin2;


  void getUserName() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userName = localStorage.getString('nom');

    setState(() {
      nameUser = userName;
      admin2 = localStorage.getString('Admin');
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



