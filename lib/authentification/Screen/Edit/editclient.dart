import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Screen/Listes/listclients.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'dart:convert';

import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';

//import 'Listes/listagents.dart';
//import 'Listes/listclients.dart';
//import 'Transaction.dart';
//import 'dashbord.dart';

class EditClient extends StatefulWidget {
  var idclient;
  EditClient({Key key, @required this.idclient}) : super(key: key);
  @override
  _EditClientState createState() => new _EditClientState(idclient);
}

class _EditClientState extends State<EditClient> {
  var idclient;
  _EditClientState(this.idclient);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nomClient = TextEditingController();
  final TextEditingController _contactClient = TextEditingController();
  final TextEditingController _matricule = TextEditingController();
//  final TextEditingController _couleurVehicule = TextEditingController();
//  final TextEditingController _marqueVehicule = TextEditingController();

  String _mySelection;
  String _mySelection2;
  String email;
  String nomClient;
  String contactClient;
  String matricule;
  bool loading = true;
  bool load = true;
  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());


//  final String urlCouleur = "http://192.168.43.217:8000/api/couleur";
//  final String urlMarque = "http://192.168.43.217:8000/api/marque";

  List data = List() ;
  List data2 = List() ;//edited line

  Future<String> getCouleur() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('couleur/$id');
    //final res = await http.get(Uri.encodeFull(urlCouleur), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    setState(() {
      data = resBody;
    });

    //print(resBody);
    return "Success";
  }

  Future<String> getMarque() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('marque/$id');
    //final res = await http.get(Uri.encodeFull(urlMarque), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    setState(() {
      data2 = resBody;
    });

    //print(resBody);
    return "Success";
  }

  void UpdateClient() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

      //try {
      var data = {
        'nom': _nomClient.text.toUpperCase(),
        'contact': _contactClient.text,
        'email': _email.text,
        'dateEnreg': date,
        'id_lavage': id,

      };


      var res = await CallApi().postDataEdit(data, 'update_client/$idclient/$id');
      var body = json.decode(res.body);
      print(body);

      if (res.statusCode == 200) {

        _nomClient.text = '';
        _contactClient.text = '';
        _matricule.text = '';
        _email.text = '';

      //  _showMsg('Donnees mises a jour avec succes');

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return ListClient();
            },
          ),
        );

      }else{
        _showMsg("Erreur d'enregistrement");
      }

  }


  final GlobalKey <ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  _showMsg(msg){
    final snackBar = SnackBar(
        content: Text(msg),
        action : SnackBarAction(
          label: 'Fermer',
          onPressed: (){

          },
        )
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void getClient() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String url = "http://192.168.43.217:8000/api/getClientEdit/$idclient/$idlavage"  ;

    var res = await CallApi().getData('getClientEdit/$idclient/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      _nomClient.text = resBody['nom'];
      _contactClient.text = resBody['contact'];
      _email.text = resBody['email'];
      //dateEnreg = resBody['dateEnreg'];
      //idTari = resBody['id'];
    });



    // print('identi est $idpresta');

  }


  @override
  void initState(){
    super.initState();
    this.getClient();
    this.getUserName();
    //this.getMarque();
  }
  Widget build(BuildContext context){
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo_rouge.png',
              fit: BoxFit.cover,
              width: 60.0,
              height: 60.0,
            ),
          )),
    );

    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('MODIFICATION CLIENT'),
      ),
      body: load ? Form(
        key: _formKey,
        //autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  logo,
                 // SizedBox(height: 40.0),
                  Text("MODIFIER LE CLIENT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.red,
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            controller: _nomClient,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => nomClient = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nom client",
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.red,
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.phone,
                            //autofocus: false,
                            controller: _contactClient,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => contactClient = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Contact",
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ////////////////////////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal:20.0),
                          child: Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                           // textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            //obscureText: true,
                            autofocus: false,
                            controller: _email,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            //onSaved: (value) => _password = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//
//                      SizedBox(width: 5.0,),
//                      Expanded(
//                          child : DropdownButton(
//                            items: data2.map((value) => DropdownMenuItem(
//                              child: Text(
//                                value['marque'],
//                                style: TextStyle(color: Color(0xff11b719)),
//                              ),
//                              value: value['id'].toString(),
//                            )).toList(),
//                            onChanged: (choix){
//                              setState(() {
//                                _mySelection2 = choix ;
//                              });
//                            },
//                            value: _mySelection2,
//                            isExpanded: false,
//                            hint: Text('Selectionner la marque du vehicule'),
//                            style: TextStyle(color: Color(0xff11b719)),
//                          ))
//                    ],
//
//                  ),

                  ////////////////////////////////////////////////////////////////

//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//
//                      SizedBox(width: 5.0,),
//                      Expanded(
//                          child : DropdownButton(
//                            items: data.map((value) => DropdownMenuItem(
//                              child: Text(
//                                value['couleur'],
//                                style: TextStyle(color: Color(0xff11b719)),
//                              ),
//                              value: value['id'].toString(),
//                            )).toList(),
//                            onChanged: (choix){
//                              setState(() {
//                                _mySelection = choix ;
//                              });
//                            },
//                            value: _mySelection,
//                            isExpanded: false,
//                            hint: Text('Selectionner la couleur du vehicule'),
//                            style: TextStyle(color: Color(0xff11b719)),
//                          ))
//                    ],
//
//                  ),


                  Row(
                    children : <Widget>[
                      Expanded(child :Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: loading ? FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff0200F4),
                                onPressed: ()async{
                                  setState(() {
                                    loading = false;
                                  });

                                 await  UpdateClient();

                                 setState(() {
                                   loading = true;
                                 });
                                },
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "ENREGISTRER",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ) : Center(child: CircularProgressIndicator(),),
                            )
                          ],
                        ),
                      )),

                      //////////////////////////////////////////////////////////

                    ],
                  ),

                  //////////////////////////////////////////////////////////

                ],
              ),
            ),
          ),
        ),
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
      ) : Center(child: CircularProgressIndicator(),),

    );
  }

  Future<void> smsError(String error) async{
    Text titre = new Text("Error:");
    Text soustitre = new Text(error);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          return new AlertDialog(title: titre, content: soustitre, actions: <Widget>[okButton(buildContext)],);
        }
    );
  }

  FlatButton okButton(BuildContext context){
    return new FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: new Text("ok"));
  }
  //methode pour se connecter
  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  void _sendDataClient() async{
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      var data = {
        'nom': _nomClient.text.toUpperCase(),
        'contact': _contactClient.text,
        'email': _email.text,
        'dateEnreg': date,
        'id_lavage': id,
        'id_couleur': _mySelection,
        'id_marque': _mySelection2,

      };

      var res = await CallApi().postAppData(data, 'create_client');
//      var body = json.decode(res.body)['data'];
//      print('les donnees du client: $body');

      if (res.statusCode == 200) {

        _nomClient.text = '';
        _contactClient.text = '';
        _matricule.text = '';
        _email.text = '';

        _showMsg("Donnees enregistrees avec succes");

      }else{
        _showMsg("Erreur d'enregistrement des donnees");
      }
    }
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



