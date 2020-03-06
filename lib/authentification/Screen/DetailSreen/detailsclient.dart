import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Prestations.dart';
import 'package:lavage/authentification/Models/listinfovehicule.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;



class DetailsClient extends StatefulWidget {

  int idclient ;
  var nom ;
  var contact ;
  var matricule ;
  var email ;
  var dateEnreg ;

  DetailsClient({Key key, @required this.idclient, this.nom, this.contact, this.email,this.dateEnreg}) : super(key: key);

  @override
  _DetailsClientState createState() => _DetailsClientState(this.idclient, this.nom, this.contact, this.email, this.dateEnreg);
}

class _DetailsClientState extends State<DetailsClient> {

  ListinfoVehicule infosVehicule = ListinfoVehicule();

  int idclient ;
  var nom ;
  var contact ;
  var email ;
  var dateEnreg ;

  _DetailsClientState(this.idclient, this.nom, this.contact, this.email, this.dateEnreg);

  var marque ;
  var couleur ;
  bool load = true;

  @override

  void initState(){
    super.initState();
    //this.getMarque();
    this.getInfosVehicule();
    this.getUserName();
  }

  Widget build(BuildContext context){
    return  WillPopScope(
      // onWillPop: _onBackPressed,
      child:Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('DETAILS CLIENT'),
        ),
        body: load ? ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),
            Center(child: Text("INFOS CLIENT"),),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text("NOM ===> $nom"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text("CONTACT ===> $contact"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text("EMAIL ===> $email"),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            Center(child: Text("INFOS VEHICULE"),),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: (infosVehicule == null || infosVehicule.data == null || infosVehicule.data.length == 0 )? 0 : infosVehicule.data.length,
              itemBuilder: (_,int index)=>ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('MARQUE : '),
                          SizedBox(width: 20.0,),
                          Text('${infosVehicule.data [index] .idMarque}'),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          Text('COULEUR'),
                          SizedBox(width: 20.0,),
                          Text('${infosVehicule.data [index] .idCouleur}'),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          Text('MATRICULE'),
                          SizedBox(width: 20.0,),
                          Text('${infosVehicule.data [index] .matricule}'),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          Text('DATE'),
                          SizedBox(width: 20.0,),
                          Text('${infosVehicule.data [index] .dateEnreg}'),
                        ],
                      ),
                      Divider(),
                    ],
                  )

//                onTap: (){
////                  Navigator.push(
////                      context,
////                      MaterialPageRoute(
////                        builder: (context) => DetailsPrestation(idpresta: listprestations.data[index].id),
////                      ));
//                },
              ),
            )
          ],
        ) : Center(child: CircularProgressIndicator(),),

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



  void getInfosVehicule() async {
   // print('couleur est $idcouleur');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    // this.param = _mySelection3;
   // print('id lavage est $id');

    //final String url = "http://192.168.43.217:8000/api/getInfosVehicule/$idclient/$id" ;

    var res = await CallApi().getData('getInfosVehicule/$idclient/$id');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    //var resBody = json.decode(res.body)['data'];

    setState(() {

      infosVehicule = listinfoVehiculeFromJson(res.body);

    });

    // print('identi est $idcouleur');

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



