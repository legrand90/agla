import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Models/Couleurs.dart';
import 'package:lavage/authentification/Models/Prestations.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsprestation.dart';
import 'package:lavage/authentification/Screen/Edit/editcouleur.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Couleur.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class ListCouleur extends StatefulWidget {

  ListCouleurs listcolor = ListCouleurs() ;

  ListCouleur({Key key, @required this.listcolor}) : super(key: key);


  @override
  _ListCouleurState createState() => _ListCouleurState(listcolor);
}

class _ListCouleurState extends State<ListCouleur> {

  ListCouleurs listcolor = ListCouleurs() ;

  _ListCouleurState(this.listcolor);

  bool suppr = false;

  var idcolor ;

  var indexItem;
  var admin;
  bool load = true;


  //String url = "http://192.168.43.217:8000/api/couleur";

  Future<dynamic> getPost() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('couleur');
   // final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listcolor = listCouleursFromJson(res.body);
    });
    return listcolor;
  }

  void DeleteCouleur() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().postDataDelete('delete_couleur/$idcolor');
//    if (res.statusCode == 200) {
//      _showMsg('Donnees supprimees avec succes');
//
//    }else{
//      _showMsg("Erreur de suppression");
//    }
  }

  void getAdmin() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var isadmin = localStorage.getString('Admin');

    setState(() {
      admin = isadmin;
    });

    print('la valeur de admin est : $admin');

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
    this.getPost();
    this.getUserName();
    this.getAdmin();
  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('LISTE DES COULEURS'),
        ),
        body: load ? ListView.separated(
          separatorBuilder: (BuildContext context, int index) {

              //indexItem = index;

            return Divider();
            },
          itemCount: (listcolor == null || listcolor.data == null || listcolor.data.length == 0 )? 0 : listcolor.data.length,
          itemBuilder: (_,int index)=>ListTile(
            title: Row(
              children: <Widget>[
                Expanded(child: Text(listcolor.data [index] .couleur),),
               // SizedBox(width: 170,),
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
                    builder: (context) => EditCouleur(idcouleur: listcolor.data [index] .id,),
                  ));
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
                              title: Text("Voulez-vous vraiment supprimer la couleur " + " \"${listcolor.data[index].couleur}\"" + "  de la liste des couleurs ?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Non"),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                FlatButton(
                                  child: Text("Oui"),
                                  onPressed: () {
                                    DeleteCouleur();
                                    setState(() {
                                      listcolor.data.removeAt(index);
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
                        idcolor = listcolor.data [index] .id;
                      });
                      //deleteItem();
                      if((admin == '1') || (admin == '2')){
                        _sureToDelete();
                      }else if(admin == '0'){
                        _showMsg('Vous ne pouvez pas effectuer cette action !!!');
                      }

                      //Navigator.of(context).pop();
                    },
                  ),

              ],
            )

          ),
        ) : Center(child: CircularProgressIndicator(),),

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
                  color: Color(0xff11b719),
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
                  await _logout();

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
                accountEmail: Text(''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff11b719),
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
                title: Text('Deconnexion'),
                onTap: () async{
                  setState(() {
                    load = false;
                  });
                  await _logout();

                  setState(() {
                    load = true;
                  });
                },
              ),

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

  Future <bool> deleteItem(){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Voulez-vous vraiment supprimez cette couleur"),
          actions: <Widget>[
            FlatButton(
              child: Text("Non"),
              onPressed: () =>Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Oui"),
              onPressed: () {

                Navigator.pop(context, false);
    }
            ),
          ],
        )
    );
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



