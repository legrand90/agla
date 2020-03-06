import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Models/Prestations.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsprestation.dart';
import 'package:lavage/authentification/Screen/Edit/editprestation.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class ListPrestations extends StatefulWidget {

  Listprestations listprestations = Listprestations() ;

  ListPrestations({Key key, @required this.listprestations}) : super(key: key);


  @override
  _ListPrestationsState createState() => _ListPrestationsState(listprestations);
}

class _ListPrestationsState extends State<ListPrestations> {

  Listprestations listprestations = Listprestations()  ;

  _ListPrestationsState(this.listprestations);

  var admin;
  var idpresta;
  bool load = true;

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

    //print('la valeur de admin est : $admin');

  }

  void DeletePrestation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().postDataDelete('delete_prestation/$idpresta/$id');
//    if (res.statusCode == 200) {
//      _showMsg('Donnees supprimees avec succes');
//
//    }else{
//      _showMsg("Erreur de suppression");
//    }
  }




    Future<dynamic> getPost() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('prestation/$id');
   // String url = "http://192.168.43.217:8000/api/prestation/$id";
   // final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listprestations = listprestationsFromJson(res.body);
    });
    return listprestations;
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
          title: Text('LISTE DES PRESTATIONS'),
        ),
        body: load ? ListView.separated(
          separatorBuilder: (BuildContext context, int index) {

            //indexItem = index;

            return Divider();
          },
          itemCount: (listprestations == null || listprestations.data == null || listprestations.data.length == 0 )? 0 : listprestations.data.length,
          itemBuilder: (_,int index)=>ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(child: Text(listprestations.data [index] .libellePrestation),),
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
                              builder: (context) => EditPrestation(idprestation: listprestations.data [index] .id,),
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
                                title: Text("Voulez-vous vraiment supprimer la prestation " + " \"${listprestations.data[index].libellePrestation}\"" + "  de la liste des prestations ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Non"),
                                    onPressed: () => Navigator.pop(context, false),
                                  ),
                                  FlatButton(
                                    child: Text("Oui"),
                                    onPressed: () {
                                      DeletePrestation();
                                      setState(() {
                                        listprestations.data.removeAt(index);
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
                          idpresta = listprestations.data [index] .id;
                        });
                        //deleteItem();
                        if((admin == '1') || (admin == '2')){
                          _sureToDelete();
                        }else if(admin == '0'){
                          print('desole');
                          _showMsg('Vous ne pouvez pas effectuer cette action !!!');
                        }

                        //Navigator.of(context).pop();
                      },
                    ),

                ],
              ),

            onTap: ()async{
                setState(() {
                  load = false;
                });
             await Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => DetailsPrestation(idpresta: listprestations.data[index].id),
              ));

             setState(() {
               load = true;
             });
            },
          ),
        ) : Center(child: CircularProgressIndicator(),),


//        ListView.builder(
//          itemCount: (listprestations == null || listprestations.data == null || listprestations.data.length == 0 )? 0 : listprestations.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listprestations.data [index] .libellePrestation),
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
                accountEmail: Text(''),
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
}



