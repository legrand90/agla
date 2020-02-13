import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/Listes/listmarques.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'dart:convert';

import 'package:lavage/authentification/widgets/loading.dart';

import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Transaction.dart';
import '../historique.dart';
import '../login_page.dart';

//import 'Tabs/clientPage.dart';
//import 'Transaction.dart';

class EditMarque extends StatefulWidget {
  var idmarq;
  EditMarque({Key key, @required this.idmarq}) : super(key: key);
  @override
  _EditMarqueState createState() => new _EditMarqueState(this.idmarq);
}

class _EditMarqueState extends State<EditMarque> {
  var idmarq;

  _EditMarqueState(this.idmarq);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomMarque = TextEditingController();

  String nomMarque;


  bool _autoValidate = false;
  bool _loadingVisible = false;

  var body;

  Future <void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void UpdateMarque() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

      //try {
      var data = {
        'libelle_marque': _nomMarque.text.toUpperCase(),
        // 'id_lavage': id
      };


      var res = await CallApi().postDataEdit(data, 'update_marque/$idmarq/$id');
      var body = json.decode(res.body);
      print(body);

      if (res.statusCode == 200) {

        _nomMarque.text = '';

       // _showMsg('Donnees mises a jour avec succes');

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return ListMarque();
            },
          ),
        );


      }else{
        _showMsg("Erreur d'enregistrement");
      }

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

  void getMarque() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String url = "http://192.168.43.217:8000/api/getMarque/$idmarq/$idlavage"  ;

    var res = await CallApi().getData('getMarque/$idmarq/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      _nomMarque.text = resBody['marque'];

    });


    // print('identi est $idpresta');

  }

  @override
  void initState(){
    super.initState();
    this.getMarque();
    this.getUserName();

  }
  Widget build(BuildContext context) {
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
        title: Text('PAGE DE MODIFICQTION'),
      ),
      body: LoadingScreen(
          child: Form(
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
                      Text("MODIFIER LA MARQUE",
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
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15.0),
                              child: Icon(
                                Icons.home,
                                color: Color(0xff11b719),
                              ),
                            ),
                            new Expanded(
                              child: TextFormField(
                                textCapitalization: TextCapitalization.characters,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                controller: _nomMarque,
                                validator: (value) =>
                                value.isEmpty
                                    ? 'Ce champ est requis'
                                    : null,
                                onSaved: (value) => nomMarque = value,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nom de la marque",
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

                      ////////////////////////////////////////////////////////////////
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(
                                        30.0)
                                ),
                                color: Color(0xff11b719),
                                onPressed: () {
                                  UpdateMarque();
                                },
                                child: new Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: 14.0,
                                  ),
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
                            ),

                          ],
                        ),
                      ),

                      //////////////////////////////////////////////////////////


                      //////////////////////////////////////////////////////////

                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),

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

  Future<void> smsError(String error) async {
    Text titre = new Text("Error:");
    Text soustitre = new Text(error);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(title: titre,
            content: soustitre,
            actions: <Widget>[okButton(buildContext)],);
        }
    );
  }

  FlatButton okButton(BuildContext context) {
    return new FlatButton(
        onPressed: () => Navigator.of(context).pop(), child: new Text("ok"));
  }

  //methode pour se connecter
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _setMarque() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    if (validateAndSave()) {
      //try {
      var data = {
        'libelle_marque': _nomMarque.text,
        'id_lavage': id
      };


      var res = await CallApi().postDataMarque(data, 'create_marque');
      var body = json.decode(res.body)['data'];
      print(body);


      if (body[0]['success']) {
        _nomMarque.text = '';

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

