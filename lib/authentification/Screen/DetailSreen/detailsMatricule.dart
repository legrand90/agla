
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Matricule.dart';
import 'package:lavage/authentification/Models/Prestations.dart';
import 'package:lavage/authentification/Screen/Edit/editmatricule.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/apropos.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

import '../tutoriel.dart';



class DetailsMatricule extends StatefulWidget {

  int idclient ;
  var nomClient ;

  DetailsMatricule({Key key, @required this.idclient, this.nomClient}) : super(key: key);

  @override
  _DetailsMatriculeState createState() => _DetailsMatriculeState(this.idclient, this.nomClient);
}

class _DetailsMatriculeState extends State<DetailsMatricule> {
  int idclient ;
  var nomClient ;
  Listmatricule listmatri = Listmatricule();
  _DetailsMatriculeState(this.idclient, this.nomClient);

  var admin;
  var idmatri;
  bool load = true;

  Future<dynamic> getPost() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //String url = "http://192.168.43.217:8000/api/matricule/$id/$idclient";

    var res = await CallApi().getData('getInfosVehicule/$idclient/$id');
   // final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listmatri = listmatriculeFromJson(res.body);
    });

    //print('les emails : ${listmatri.data.length}');
    return listmatri;
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

  String dateHeure = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  var fenetre = 'INFOS VEHICULE';

  void DeleteMatricule() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var id_user = localStorage.getInt('ID');

    var dataLog = {
      'fenetre': '$fenetre',
      'tache': "Suppression d'un Matricule",
      'execution': "Supprimer",
      'id_user': id_user,
      'dateEnreg': dateHeure,
      'id_lavage': id,
    };


    var res = await CallApi().postDataDelete('delete_matricule/$idmatri/$id');
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
    this.getAdmin();
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
          title: Text('LISTE DES MATRICULES'),
        ),
        body: load ? ListView(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Container(child: Center(child: Text('CLIENT : ' + ' $nomClient', style: TextStyle(fontSize: 15.0),),),),
            SizedBox(height: 15.0,),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {

            //indexItem = index;

            return Divider();
          },
          itemCount: (listmatri == null || listmatri.data == null || listmatri.data.length == 0 )? 0 : listmatri.data.length,
          itemBuilder: (_,int index)=>ListTile(
              title: Column(
                children: <Widget>[
                  //SizedBox(height: 100.0,),
                  Row(children: <Widget>[
                    Expanded(child: Text('MATRICULE : ${listmatri.data [index] .matricule}'),),


                  //SizedBox(width: 170,),
                 IconButton(
                      icon: Icon(
                          Icons.edit),
                      onPressed: ()async{

                        if(admin == '1'){

                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditMatricule(
                                  idmatricule: listmatri.data [index] .id,
                                  idcouleur: listmatri.data [index] .idCouleur,
                                  idmarque: listmatri.data [index] .idMarque,
                                  idcli: listmatri.data [index] .idClient,
                                  nomCli: nomClient,

                                ),
                              ));

                        }else{
                          _showMsg('Vous ne pouvez pas effectuer cette action !!!');
                        }

                      },
                    )],),

                  Row(children: <Widget>[
                    Expanded(child: Text('COULEUR : ${listmatri.data [index] .idCouleur}'),),
                  ],),

                  SizedBox(height: 10.0,),

                  Row(children: <Widget>[
                    Expanded(child: Text('MARQUE : ${listmatri.data [index] .idMarque}'),),
                  ],),


                  SizedBox(width: 30.0,),

                ],
              )
          ),
        )],) : Center(child: CircularProgressIndicator(),),

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



//        ListView.builder(
//          itemCount: (listmatri == null || listmatri.data == null || listmatri.data.length == 0 )? 0 : listmatri.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listmatri.data[index].matricule),
//            onTap: (){
//
//            },
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
                  await Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Tutoriel();
                      },
                    ),
                  );
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










