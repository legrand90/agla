import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/Edit/edittarification.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class TarificationList extends StatefulWidget {

  ListTarifications listtari = ListTarifications ()  ;

  TarificationList({Key key, @required this.listtari}) : super(key: key);

  @override
  _TarificationListState createState() => _TarificationListState(listtari);
}

class _TarificationListState extends State<TarificationList> {

  ListTarifications listtari = ListTarifications ()  ;

  _TarificationListState(this.listtari);

  String dateHeure = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  var fenetre = 'LISTE DES TARIFICATIONS';

  var idtarif;
  var admin;
  bool load = true;


  Future<dynamic> getPost() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('tarification/$id');
   // String url = "http://192.168.43.217:8000/api/tarification/$id";
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listtari = listTarificationsFromJson(res.body);
    });
    return listtari;
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


  void getAdmin() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var isadmin = localStorage.getString('Admin');

    setState(() {
      admin = isadmin;
    });

    print('la valeur de admin est : $admin');

  }

  void DeleteTarification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var id_user = localStorage.getInt('ID');

    var dataLog = {
      'fenetre': '$fenetre',
      'tache': "Suppression d'une Tarification",
      'execution': "Supprimer",
      'id_user': id_user,
      'dateEnreg': dateHeure,
      'id_lavage': id,
    };

    var res = await CallApi().postDataDelete('delete_tarification/$idtarif/$id');
    var resLog = await CallApi().postData(dataLog, 'create_log');
//    if (res.statusCode == 200) {
//      _showMsg('Donnees supprimees avec succes');
//
//    }else{
//      _showMsg("Erreur de suppression");
//    }
  }

  @override

  void initState(){
    super.initState();
    this.getPost();
    this.getUserName();
    this.getAdmin();
    this.getStatut();
  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('LISTE DES TARIFICATIONS'),
        ),
        body: load ? ListView.separated(
          separatorBuilder: (BuildContext context, int index) {

            //indexItem = index;

            return Divider();
          },
          itemCount: (listtari == null || listtari.data == null || listtari.data.length == 0 )? 0 : listtari.data.length,
          itemBuilder: (_,int index)=>ListTile(
              title: Row(
                children: <Widget>[
                  SizedBox(height: 50.0,),
                  Expanded(child: Text(listtari.data [index] .prestationMontant),),
                  //SizedBox(width: 170,),
               IconButton(
                      icon: Icon(
                          Icons.edit),
                      onPressed: ()async{
                        setState(() {
                          load = false;
                        });

                        if(admin == '1'){

                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTarification(
                                  idtari: listtari.data [index] .id,
                                  prestaEtMontant: listtari.data [index] .prestationMontant,
                                  idPresta : listtari.data [index] .idPrestation,
                                ),
                              ));

                        }else{
                          _showMsg('Vous ne pouvez pas effectuer cette action !!!');
                        }

                       setState(() {
                         load = true;
                       });
                      },
                    ),

                  SizedBox(width: 30.0,),

                IconButton(
                      color: Colors.red,
                      icon: Icon(
                          Icons.delete),
                      onPressed: ()async{
                        Future<bool> _sureToDelete(){
                          return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Voulez-vous vraiment supprimer tarification " + " \"${listtari.data[index].montant} Fcfa\"" + "  de la liste des tarifications ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Non"),
                                    onPressed: () => Navigator.pop(context, false),
                                  ),
                                  FlatButton(
                                    child: Text("Oui"),
                                    onPressed: () {
                                      DeleteTarification();
                                      setState(() {
                                        listtari.data.removeAt(index);
                                        //  indexItem;
                                      });
                                      Navigator.pop(context, false);
                                    }
                                    ,
                                  )
                                ],
                              )
                          );
                        }

                        setState(() {
                          idtarif = listtari.data [index] .id;
                        });
                        //deleteItem();
                        if((admin == '2') || (admin == '3')){
                          _sureToDelete();

                        }else{
                          _showMsg('Vous ne pouvez pas effectuer cette action !!!');
                        }

                        //Navigator.of(context).pop();
                      },
                    ),

                ],
              )
          ),
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


//        ListView.builder(
//          itemCount: (listtari == null || listtari.data == null || listtari.data.length == 0 )? 0 : listtari.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listtari.data [index] .prestationMontant),
//
//          ),
//        ),

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
        ) : Center(child: CircularProgressIndicator(),),


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



