import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lavage/authentification/Screen/dashbord.dart';

import '../login_page.dart';


class TypeUserSearch extends StatefulWidget {
  @override
  _TypeUserSearchState createState() => new _TypeUserSearchState();
}

class _TypeUserSearchState extends State<TypeUserSearch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _gainAgent = TextEditingController();
  //final TextEditingController _password = TextEditingController();

  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());
  String gainAgent;


  // final String urlTarification = "http://192.168.43.217:8000/api/tarification";
  bool val = false;
  bool isButtonDisable = false;
  List data = List() ;
  List data2 = List() ;//edited line
  var id ;
  String _mySelection;
  String _mySelection2;
  bool loading = true;
  bool load = true;

  var _currencies = <String>[
    'PROPRIETAIRE',
    'GERANT',
  ];

  Future<String> getAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('agent/$id');
    //final String urlAgent = "http://192.168.43.217:8000/api/agent/$id";

    //final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];


    setState(() {
      data = resBody;
    });

    print(resBody);
    return "Success";
  }

  Future<String> getTarification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('tarification/$id');
    // final String urlTarification = "http://192.168.43.217:8000/api/tarification/$id";
    //final res = await http.get(Uri.encodeFull(urlTarification), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];
    //SharedPreferences localStorage = await SharedPreferences.getInstance();

    setState(() {

      data2 = resBody;

      //localStorage.setBool('valeur', null);
    });



    print(val);
    return "Success";
  }
  //SharedPreferences localStorage = await SharedPreferences.getInstance();


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

  @override
  void initState(){
    super.initState();
    this.getAgent();
    this.getUserName();
    this.getTarification();
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
      backgroundColor: Color(0xFFDADADA),
      body: load ? Form(
        key: _formKey,
        // autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Text("TYPE USER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton<String>(
                            items: _currencies.map((String value) => DropdownMenuItem<String>(
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                              value: value,
                            )).toList(),
                            onChanged: ( choix){
                              setState(() {
                                _mySelection2 = choix ;
                              });
                            },
                            value: _mySelection2,
                            isExpanded: false,
                            hint: Text('Selectionner statut'),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
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
  void _sendDataCommission() async{
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idlavage = localStorage.getString('id_lavage');
      var data = {
        'gain_agent': _gainAgent.text,
        'dateEnreg': date,
        'id_lavage': idlavage,
        'id_agent': _mySelection,
        'id_tarification': _mySelection2,

      };

      var res = await CallApi().postAppData(data, 'create_commission');

      // print('les donnees de commission: $body');

      if(res.statusCode == 200){
        var body = json.decode(res.body)['data'];


        setState(() {
          _gainAgent.text = '';
          _mySelection = null;
          _mySelection2 = null;
        });


        _showMsg('Donnees enregistrees avec succes');


      }else{
        _showMsg("Erreur d' enregistrement");
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


}



