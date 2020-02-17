import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Models/Transaction.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsclient.dart';
import 'package:lavage/authentification/Screen/Edit/editclient.dart';
import 'package:lavage/authentification/Screen/Edit/edtitransaction.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class ListClientLavage extends StatefulWidget {

  Listclients listclients = Listclients () ;

  ListClientLavage({Key key, @required this.listclients}) : super(key: key);

  @override
  _ListClientLavageState createState() => _ListClientLavageState(listclients);
}

class _ListClientLavageState extends State<ListClientLavage>{

  Listtransactions listtransac = Listtransactions();

  Listclients listclients = Listclients();

  _ListClientLavageState(this.listclients);

  var admin;
  var idcli;
  var idtrans;

  //String url = "http://192.168.43.217:8000/api/client/";

  Future<dynamic> getPost() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('Transaction/$id');
    //String url = "http://192.168.43.217:8000/api/Transaction/$id";
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    // var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listclients = listclientsFromJson(res.body);
      listtransac = listtransactionsFromJson(res.body);
    });
    return listclients;
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

  void DeleteTransaction() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().postDataDelete('delete_transaction/$idtrans.id}/$id');
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
  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('LISTES DES CLIENTS'),
        ),
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {

            //indexItem = index;

            return Divider(color: Colors.black, height: 50.0,);
          },
          itemCount: (listtransac == null || listtransac.data == null || listtransac.data.length == 0 )? 0 : listtransac.data.length,
          itemBuilder: (_,int index)=>ListTile(
            title: Row(
              children: <Widget>[
                Expanded(child: Text(" Transaction du : " + " " + "  ${listtransac.data [index] .date}"),),
                SizedBox(width: 170,),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                        Icons.edit),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTransaction(idtransaction: listtransac.data [index] .id,),
                          ));
                    },
                  ),
                ),

                Expanded(
                  child: IconButton(
                    color: Colors.red,
                    icon: Icon(
                        Icons.delete),
                    onPressed: (){
                      setState(() {
                        idtrans = listtransac.data [index] .id;
                      });
                      //deleteItem();
                      if(admin == '1'){
                        DeleteTransaction();
                        setState(() {
                          listtransac.data.removeAt(index);
                          //  indexItem;
                        });
                      }else if(admin == '0'){
                        _showMsg('Vous ne pouvez pas effectuer cette action !!!');
                      }

                      //Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )

          ),
        ),


//        ListView.builder(
//          itemCount: (listclients == null || listclients.data == null || listclients.data.length == 0 )? 0 : listclients.data.length,
//          itemBuilder: (_,int index)=>ListTile(
//            title: Text(listclients.data [index].nom),
//            onTap: (){
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => DetailsClient(
//                      idclient : listclients.data[index].id,
//                      nom : listclients.data[index].nom,
//                      contact : listclients.data[index].contact,
//                      email : listclients.data[index].email,
//                    // matricule : listclients.data[index].matricule,
//                      idmarque : listclients.data[index].idMarque,
//                      idcouleur : listclients.data[index].idCouleur,
//                      dateEnreg : listclients.data[index].dateEnreg,
//                    ),
//                  ));
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
                accountName: Text('Legrand Koffi'),
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
}



