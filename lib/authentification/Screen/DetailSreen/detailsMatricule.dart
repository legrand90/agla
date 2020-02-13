



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Matricule.dart';
import 'package:lavage/authentification/Models/Prestations.dart';
import 'package:lavage/authentification/Screen/Edit/editmatricule.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;



class DetailsMatricule extends StatefulWidget {

  int idclient ;

  DetailsMatricule({Key key, @required this.idclient}) : super(key: key);

  @override
  _DetailsMatriculeState createState() => _DetailsMatriculeState(this.idclient);
}

class _DetailsMatriculeState extends State<DetailsMatricule> {
  int idclient ;
  Listmatricule listmatri = Listmatricule();
  _DetailsMatriculeState(this.idclient);

  var admin;
  var idmatri;

  Future<dynamic> getPost() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //String url = "http://192.168.43.217:8000/api/matricule/$id/$idclient";

    var res = await CallApi().getData('matricule/$id/$idclient');
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

  void DeleteMatricule() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().postDataDelete('delete_matricule/$idmatri/$id');
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
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {

            //indexItem = index;

            return Divider();
          },
          itemCount: (listmatri == null || listmatri.data == null || listmatri.data.length == 0 )? 0 : listmatri.data.length,
          itemBuilder: (_,int index)=>ListTile(
              title: Row(
                children: <Widget>[
                  //SizedBox(height: 100.0,),
                  Expanded(child: Text(listmatri.data [index] .matricule),),
                  //SizedBox(width: 170,),
                 IconButton(
                      icon: Icon(
                          Icons.edit),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMatricule(
                                idmatricule: listmatri.data [index] .id,
                                idcouleur: listmatri.data [index] .idCouleur,
                                idmarque: listmatri.data [index] .idMarque,
                                idcli: listmatri.data [index] .idClient,

                              ),
                            ));
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
                                title: Text("Voulez-vous vraiment supprimer le matricule" + " \"${listmatri.data[index].matricule}\"" + "  de la liste des matricules ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Non"),
                                    onPressed: () => Navigator.pop(context, false),
                                  ),
                                  FlatButton(
                                    child: Text("Oui"),
                                    onPressed: () {
                                      DeleteMatricule();
                                      setState(() {
                                        listmatri.data.removeAt(index);
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
                          idmatri = listmatri.data [index] .id;
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
              )
          ),
        ),



//        ListView.builder(
//          itemCount: (listmatri == null || listmatri.data == null || listmatri.data.length == 0 )? 0 : listmatri.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listmatri.data[index].matricule),
//            onTap: (){
//
//            },
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


      ]),
    )));
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










