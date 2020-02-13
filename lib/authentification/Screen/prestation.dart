import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Listes/listprestations.dart';
import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'dashbord.dart';
import 'historique.dart';
import 'login_page.dart';

class Prestation extends StatefulWidget {
  @override
  _PrestationState createState() => new _PrestationState();
}

class _PrestationState extends State<Prestation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomPrestation = TextEditingController();
  final TextEditingController _descripPrestation = TextEditingController();
  final TextEditingController _montant = TextEditingController();

  String nomPrestation;
  String descripPrestation;

  bool _autoValidate = false;
  bool _loadingVisible = false;
  String montant;
  var idPresta = 0;

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


  void getIdPresta() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('getLastIdPrestation/$id');

    //var urlClient = "http://192.168.43.217:8000/api/getClient/$id";
    //final res = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    if(resBody == null){
      setState(() {
        idPresta = 0;
      });
    }else{
      setState(() {
        idPresta = resBody[0]['id'];
      });
    }
    print('les donnees sont : $idPresta');

  }

  @override
  void initState(){
    super.initState();
    this.getUserName();
    this.getIdPresta();
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
        title: Text('PRESTATION'),
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
                  Text("PRESTATION",
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
                            Icons.home,
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            //autofocus: false,
                            controller: _nomPrestation,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => nomPrestation = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nom prestation",
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
                            Icons.person_outline,
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            //autofocus: false,
                            controller: _descripPrestation,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => descripPrestation = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Description",
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
                          padding: EdgeInsets.symmetric(vertical: 10.0,
                              horizontal: 15.0),
                          child: Icon(
                            Icons.monetization_on,
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            //autofocus: false,
                            controller: _montant,
                            validator: (value) =>
                            value.isEmpty
                                ? 'Ce champ est requis'
                                : null,
                            onSaved: (value) => montant = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Montant en FCFA",
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),

                        //Container(width: 20.0,),
                        // Expanded(child: Text("Fcfa"),)
                      ],
                    ),
                  ),

                  ////////////////////////////////////////////////////////////////

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
                                  checkPrestation();
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
                      Container(
                        width: 15.0,
                      ),
                      Expanded(child : Container(
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
                                child: new Container(
                                  //padding: const EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "AFFICHER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ListPrestations();
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),)],),

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
                    builder: (BuildContext context){
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
  void _sendDataPrestation ()async{
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      //try {
      var data = {
        'libelle_prestation': _nomPrestation.text.toUpperCase(),
        'descrip_prestation': _descripPrestation.text.toUpperCase(),
        'id_lavage': id,
      };

      var res = await CallApi().postDataPrestation(data, 'create_prestation');
      var body = json.decode(res.body)['data'];
      // print('les donnees de prestation: ${body}');

      setState(() {
        // success = true;
        idPresta = body[0]['id'];
      });

      if(res.statusCode == 200){
        _sendDataTarification();
      }



    }

    print(' le type ${idPresta.runtimeType}');
    print(' le type val ${idPresta}');
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

  void checkPrestation()async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var resPrestation = await CallApi().getData('checkPrestation/$id/${_nomPrestation.text}');
    var prestationBody = json.decode(resPrestation.body)['data'];

    if((prestationBody != null)){

      // print('donnee 1 $matriculebody');
      //print('donnee 2 $contactbody');
      _showMsg("Cette prestation existe deja !!!");
    }

    else{
      //_showMsg("existe pas!!!");
      _sendDataPrestation();

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


  void _sendDataTarification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    if (validateAndSave()) {
      //_sendDataPrestation();

      var data = {
        'id_prestation': idPresta,
        'montant': _montant.text,
        'id_lavage': id,

      };

      var res = await CallApi().postAppData(data, 'create_tarification');
      var body = json.decode(res.body);
      print('$body');

      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('idTarif', body['id'].toString());
        localStorage.setString('presta_Montant', (body['prestation_montant']));
        localStorage.setBool('valeur', true);
        // print(localStorage.getString('idTarif'));
        //  print(localStorage.getString('presta_Montant'));

        setState(() {
          _nomPrestation.text = '';
          _descripPrestation.text = '';
          _montant.text = '' ;
        });

        _showMsg("Donnees enregistrees avec succes ");

      }else{
        _showMsg("Erreur d'enregistrement ");
      }
    }

  }


}



