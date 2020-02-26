import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Screen/Listes/listtarification.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';

//import 'Tabs/clientPage.dart';
//import 'Transaction.dart';
//import 'dashbord.dart';

class EditTarification extends StatefulWidget {
  var idtari;
  var prestaEtMontant;
  var idPresta ;
  EditTarification({Key key, @required this.idtari, this.prestaEtMontant, this.idPresta}) : super(key: key);
  @override
  _EditTarificationState createState() => new _EditTarificationState(idtari, prestaEtMontant, idPresta);
}

class _EditTarificationState extends State<EditTarification> {
  var idtari;
  var prestaEtMontant ;
  var idPresta ;
  _EditTarificationState(this.idtari, this.prestaEtMontant, this.idPresta);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //final TextEditingController _prestation = TextEditingController();

  final TextEditingController _montant = TextEditingController();
  final TextEditingController _prestaMontant = TextEditingController();

  String _mySelection;

  String montant;

  var idpresta;

  var nomPresta ;

  bool defaultPresta = false ;

  bool loading = true;

  bool load = true;




  List data = List();

  Future<String> getPrestation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('prestation/$id');
    //final String urlPrestation = "http://192.168.43.217:8000/api/prestation/$id";
//    final res = await http.get(Uri.encodeFull(urlPrestation), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });
    var resBody = json.decode(res.body)['data'];

    setState(() {

      data = resBody;

    });

    return "Success";
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

  void UpdateTarification() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

      //try {
      var data = {
        'id_prestation': defaultPresta ? _mySelection : idPresta,
        'montant': _montant.text,
        'id_lavage': id,

      };


      var res = await CallApi().postDataEdit(data, 'update_tarification/$idtari/$id');
      var body = json.decode(res.body);
      print(body);

      if (res.statusCode == 200) {

        _montant.text = '' ;

        defaultPresta = false;

       // _showMsg('Donnees mises a jour avec succes');

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return TarificationList();
            },
          ),
        );


      }else{
        _showMsg("Erreur d'enregistrement");
      }

  }

  void getTarification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String url = "http://192.168.43.217:8000/api/getTarificationEdit/$idtari/$idlavage"  ;

    var res = await CallApi().getData('getTarificationEdit/$idtari/$idlavage');
    var res2 = await CallApi().getData('getPrestation/$idPresta/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];
    var resBody2 = json.decode(res2.body)['data'];

    setState(() {
      _montant.text = resBody['montant'];
      nomPresta = resBody2['libelle_prestation'];
      _prestaMontant.text = prestaEtMontant;

    });



    // print('identi est $idpresta');

  }

  @override
  void initState() {
    super.initState();
    this.getPrestation();
    this.getTarification();
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
        title: Text('TARIFICATION'),
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
                  SizedBox(height: 40.0),
                  Text("TARIFICATION",
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

                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[

                        new Expanded(
                          child: DropdownButton(
                            items: data.map((value) =>
                                DropdownMenuItem(
                                  child: Text(
                                    value['libelle_prestation'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: value['id'].toString(),
                                )).toList(),
                            onChanged: (choix) {
                              setState(() {
                                _mySelection = choix;
                                defaultPresta = true;
                              });
                            },
                            value: _mySelection,
                            isExpanded: false,
                            hint: Text('$nomPresta'),
                            style: TextStyle(color: Color(0xff11b719)),
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0,
                              horizontal: 15.0),
                          child: Icon(
                            Icons.person_outline,
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
                              hintText: "Montant",
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

                  Row(
                    children: <Widget>[
                      Expanded(child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: loading ? FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(
                                        30.0)
                                ),
                                color: Color(0xff11b719),
                                onPressed: () async{
                                  setState(() {
                                    loading = false;
                                  });
                                  await UpdateTarification();

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

  void _sendDataTarification() async {
    if (validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      var data = {
        'id_prestation': _mySelection,
        'montant': _montant.text,
        'id_lavage': id,

      };

      var res = await CallApi().postAppData(data, 'create_tarification');
      var body = json.decode(res.body);
      print('les donnees de l\'Agent: ${body}');


      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('idTarif', body['id'].toString());
        localStorage.setString('presta_Montant', (body['prestation_montant']));
        localStorage.setBool('valeur', true);
        print(localStorage.getString('idTarif'));
        print(localStorage.getString('presta_Montant'));

        _montant.text = '' ;

        _showMsg(body['message']);

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


