import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Users.dart';
import 'package:lavage/authentification/Models/listdepense.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsUsers.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/Edit/editagent.dart';
import 'package:lavage/authentification/Screen/Edit/editdepense.dart';
import 'package:lavage/authentification/Screen/Edit/edituser.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/TabsSuperAdmin/superAdmin.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/create_superAdmin.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class ListDepense extends StatefulWidget {

  Listdepense listdepenses = Listdepense () ;

  @override
  _ListDepenseState createState() => _ListDepenseState();
}

class _ListDepenseState extends State<ListDepense> {

  Listdepense listdepenses = Listdepense () ;

  var admin ;
  var iduser ;
  bool load = true;
  bool chargement = false;


  Future<dynamic> getDepenses() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('SortieCaisseDepenses/$id');
    //String url = "http://192.168.43.217:8000/api/agent/$id";
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listdepenses =  listdepenseFromJson(res.body);
      chargement = true;
    });
    return listdepenses;
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





  @override

  void initState(){
    super.initState();
    this.getDepenses();
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
          title: Text('HISTORIQUE DES DEPENSES'),
        ),

        body: chargement ? ListView.separated(
          separatorBuilder: (BuildContext context, int index) {

            //indexItem = index;

            return Divider();
          },
          itemCount: (listdepenses == null || listdepenses.data == null || listdepenses.data.length == 0 )? 0 : listdepenses.data.length,
          itemBuilder: (_,int index)=>ListTile(
            title: Column(
              children: <Widget>[

                Row(
                  children: <Widget>[
                    Expanded(child: Text('DATE : ${listdepenses.data [index] .dateEnreg}'),),
                    //SizedBox(width: 170,),

                    IconButton(
                      icon: Icon(
                          Icons.edit),
                      onPressed: ()async{
                        setState(() {
                          load = false;
                        });
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDepense(iddepense: listdepenses.data [index] .id,),
                            ));
                        setState(() {
                          load = true;
                        });
                      },
                    ),

                    SizedBox(width: 30,),

                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(child: Text('LIBELLE : ${listdepenses.data[index].libelleDepense}',),),

                    //SizedBox(width: 80.0,),
                    //Text('${listusers.data[index].admin}',),
                  ],
                ),

                SizedBox(height: 10.0,),

                Row(
                  children: <Widget>[
                    Expanded(child: Text('QUANTITE : ${listdepenses.data[index].quantite}',),),

                    //SizedBox(width: 80.0,),
                    //Text('${listusers.data[index].admin}',),
                  ],
                ),

                SizedBox(height: 10.0,),

                Row(
                  children: <Widget>[
                    Expanded(child: Text('PRIX UNITAIRE : ${listdepenses.data[index].prixUnitaire}',),),
                    //SizedBox(width: 80.0,),

                  ],
                ),

                SizedBox(height: 10.0,),

                Row(
                  children: <Widget>[
                    Expanded(child: Text('PRIX TOTAL : ${listdepenses.data[index].prixTotal}',),),
                    //SizedBox(width: 80.0,),

                  ],
                )
              ],
            ),


          ),
        ) : Center(child: CircularProgressIndicator(),),

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
//          itemCount: (listagents == null || listagents.data == null || listagents.data.length == 0 )? 0 : listagents.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listagents.data [index] .nom),
//
//          ),
//        ),

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
                  //await _alertDeconnexion();

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

  void route() async{



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



