import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:http/http.dart' as http;

import 'package:lavage/authentification/Screen/Listes/listagents.dart';

import '../Transaction.dart';
import '../historique.dart';
import '../login_page.dart';

//import 'Tabs/clientPage.dart';
//import 'Transaction.dart';
//import 'Listes/listagents.dart';

//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class EditAgent extends StatefulWidget {
  var idagent ;
  EditAgent({Key key, @required this.idagent}) : super(key: key);
  @override
  _EditAgentState createState() => new _EditAgentState(idagent);
}

class _EditAgentState extends State<EditAgent> {
  var idagent ;
  _EditAgentState(this.idagent);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAgent = TextEditingController();
  final TextEditingController _contactAgent = TextEditingController();
  final TextEditingController _domicilAgent = TextEditingController();
  final TextEditingController _contactUrgence = TextEditingController();


  String dateHeure = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  String nomAgent;
  String contactAgent;
  String domicilAgent;
  String contactUrgence;

  bool _autoValidate = false;
  bool _loadingVisible = false;

  // Listagents listagents = Listagents ()  ;

  Future <void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }


  void UpdateAgent() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

      //try {
      var data = {
        'nom': _nomAgent.text.toUpperCase(),
        'contact': _contactAgent.text,
        'quartier': _domicilAgent.text.toUpperCase(),
        'contactUrgence': _contactUrgence.text,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        // 'id_lavage': id
      };


      var res = await CallApi().postDataEdit(data, 'update_agent/$idagent/$id');
      var body = json.decode(res.body);
      print(body);

      if (res.statusCode == 200) {

        _nomAgent.text = '';
        _contactAgent.text = '';
        _domicilAgent.text = '';
        _contactUrgence.text = '';

        //_showMsg('Donnees mises a jour avec succes');

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return ListAgent();
            },
          ),
        );

      }else{
        _showMsg("Erreur d'enregistrement");
      }

  }

  void getAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

   // final String url = "http://192.168.43.217:8000/api/getAgent/$idagent/$idlavage"  ;

    var res = await CallApi().getData('getAgent/$idagent/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      _nomAgent.text = resBody['nom'];
      _contactAgent.text = resBody['contact'];
      _contactUrgence.text = resBody['contactUrgence'];
      _domicilAgent.text = resBody['quartier'];
      //dateEnreg = resBody['dateEnreg'];
      //idTari = resBody['id'];
    });



    // print('identi est $idpresta');

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

  @override

  void initState(){
    super.initState();
    this.getAgent();
    this.getUserName();
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
      appBar: AppBar(
        title: Text('MODIFICATION AGENT'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  logo,
                  SizedBox(height: 40.0),
                  Text("MODIFIER l'AGENT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
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
                        color: Colors.white.withOpacity(0.5),
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
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            controller: _nomAgent,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => nomAgent = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nom agent",
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
                        color: Colors.white.withOpacity(0.5),
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
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            //autofocus: false,
                            controller: _contactAgent,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => contactAgent = value,
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
                            Icons.home,
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            //obscureText: true,
                            autofocus: false,
                            controller: _domicilAgent,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => domicilAgent = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Domicile",
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ////////////////////////////////////////////////////////////////

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
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
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            //autofocus: false,
                            controller: _contactUrgence,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => contactUrgence = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Contact d'urgence",
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),


                  Row(
                    children : <Widget>[
                      Expanded(child :Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff11b719),
                                onPressed: (){
                                  UpdateAgent();
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
                              ),
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
      ),

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
  void _sendDataAgent () async{

    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      var data = {
        'nom': _nomAgent.text.toUpperCase(),
        'contact': _contactAgent.text,
        'quartier': _domicilAgent.text.toUpperCase(),
        'contactUrgence': _contactUrgence.text,
        'dateEnreg': dateHeure,
        'id_lavage': id,
      };

      var res = await CallApi().postDataAgent(data, 'create_agent');
      var body = json.decode(res.body)['data'];
      print('les donnees de l\'Agent: ${body}');

      if(body[0]['success']) {
        _nomAgent.text = '';
        _contactAgent.text = '';
        _domicilAgent.text = '';
        _contactUrgence.text = '';

        _showMsg(body[0]['message']);

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



