import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'dart:convert';
import 'package:lavage/authentification/widgets/loading.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Listes/listcouleurs.dart';
import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'historique.dart';
import 'login_page.dart';

class Couleur extends StatefulWidget {
  var idcouleur ;
  Couleur({Key key, @required this.idcouleur}) : super(key: key);

  @override
  _CouleurState createState() => new _CouleurState(this.idcouleur);
}
class _CouleurState extends State<Couleur> {
  var idcouleur ;
  _CouleurState(this.idcouleur);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomCouleur = TextEditingController();

  String nomCouleur;


  bool _autoValidate = false;
  bool _loadingVisible = false;

  var body;

  void UpdateCouleur() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
  }

  Future <void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
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
        title: Text('COULEUR'),
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
                      Text("ENREGISTRER COULEUR",
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
                                controller: _nomCouleur,
                                validator: (value) =>
                                value.isEmpty
                                    ? 'Ce champ est requis'
                                    : null,
                                onSaved: (value) => nomCouleur = value,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nom de la couleur",
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
                       // padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                  checkCouleur();
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

                            Container(
                              width: 10.0,
                            ),

                            new Expanded(
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(
                                        30.0)
                                ),
                                color: Color(0xff11b719),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ListCouleur();
                                      },
                                    ),
                                  );
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
                                          "AFFICHER",
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

  void _setCouleur() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    if (validateAndSave()) {
      //try {
      var data = {
        'libelle_couleur': _nomCouleur.text.toUpperCase(),
        'id_lavage': id
      };


      var res = await CallApi().postDataCouleur(data, 'create_couleur');
      var body = json.decode(res.body)['data'];
      print(body);

      if (res.statusCode == 200) {

         setState(() {
           _nomCouleur.text = '';
         });


        _showMsg("Donnees enregistrees avec succes ");

    }else{
        _showMsg("Erreur d'enregistrement ");
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

  void checkCouleur()async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var resCouleur = await CallApi().getData('checkCouleur/$id/${_nomCouleur.text}');
    var couleurBody = json.decode(resCouleur.body)['data'];

    if((couleurBody != null)){

      // print('donnee 1 $matriculebody');
      //print('donnee 2 $contactbody');
      _showMsg("Cette couleur existe deja !!!");
    } else{
      //_showMsg("existe pas!!!");
      _setCouleur();

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

