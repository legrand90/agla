import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/Edit/editagent.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class ListAgent extends StatefulWidget {

  Listagents listagents = Listagents ()  ;

  ListAgent({Key key, @required this.listagents}) : super(key: key);

  @override
  _ListAgentState createState() => _ListAgentState(listagents);
}

class _ListAgentState extends State<ListAgent> {

  Listagents listagents = Listagents ()  ;

  _ListAgentState(this.listagents);

var admin ;
var idagen ;


  Future<dynamic> getPost() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('agent/$id');
    //String url = "http://192.168.43.217:8000/api/agent/$id";
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
   // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listagents = listagentsFromJson(res.body);
    });
    return listagents;
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

  void DeleteAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().postDataDelete('delete_agent/$idagen/$id');
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
  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('LISTE DES AGENTS'),
        ),
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {

            //indexItem = index;

            return Divider();
          },
          itemCount: (listagents == null || listagents.data == null || listagents.data.length == 0 )? 0 : listagents.data.length,
          itemBuilder: (_,int index)=>ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(child: Text(listagents.data [index] .nom),),
                  //SizedBox(width: 170,),
                  IconButton(
                      icon: Icon(
                          Icons.edit),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAgent(idagent: listagents.data [index] .id,),
                            ));
                      },
                    ),

                  SizedBox(width: 30,),
                  IconButton(
                      color: Colors.red,
                      icon: Icon(
                          Icons.delete),
                      onPressed: ()async{
                        Future<bool> _sureToDelete(){
                          return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Voulez-vous vraiment supprimer " + " \"${listagents.data[index].nom}\"" + "  de la liste des agents ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Non"),
                                    onPressed: () => Navigator.pop(context, false),
                                  ),
                                  FlatButton(
                                    child: Text("Oui"),
                                    onPressed: () {
                                      DeleteAgent();
                                      setState(() {
                                        listagents.data.removeAt(index);
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
                          idagen = listagents.data [index] .id;
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

              onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsAgent(idagent : listagents.data[index].id),
                  ));
            },
          ),
        ),


//        ListView.builder(
//          itemCount: (listagents == null || listagents.data == null || listagents.data.length == 0 )? 0 : listagents.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listagents.data [index] .nom),
//
//          ),
//        ),

        drawer: Drawer(
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
                  color: Color(0xff11b719),
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



