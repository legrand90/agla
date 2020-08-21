import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Screen/Listes/listtarification.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/apropos.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import '../tutoriel.dart';

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

  String date = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  String _mySelection;

  var fenetre = 'MODIFICATION DE TARIF';

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
    var id_user = localStorage.getInt('ID');

      //try {
      var data = {
        'id_prestation': defaultPresta ? _mySelection : idPresta,
        'montant': _montant.text,
        'id_lavage': id,

      };

    var dataLog = {
      'fenetre': '$fenetre',
      'tache': "Modification de Tarif",
      'execution': "Update",
      'id_user': id_user,
      'dateEnreg': date,
      'id_lavage': id,
      'type_user': statu,
    };


      var res = await CallApi().postDataEdit(data, 'update_tarification/$idtari/$id');
      var body = json.decode(res.body);
      print(body);

      if (res.statusCode == 200) {
        var res = await CallApi().postData(dataLog, 'create_log');

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
    this.getStatut();
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
      backgroundColor: Colors.white,
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
                  //logo,
                  //SizedBox(height: 40.0),
                  Text("MODIFIER TARIFICATION",
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
                                    style: TextStyle(color: Colors.black, fontSize: 18.0),
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
                            isExpanded: true,
                            hint: Text('$nomPresta', style: TextStyle(fontSize: 18.0)),
                            style: TextStyle(color: Color(0xff11b719), fontSize: 18.0),
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0,
                              horizontal: 15.0),
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.red,
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
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
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
                                color: Color(0xff003372),
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

      bottomNavigationBar: (adm == '0' || adm == '1') ? BottomNavigationBar(
        //backgroundColor: Color(0xff0200F4),
        //currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            //backgroundColor: Color(0xff0200F4),
            icon: new IconButton(
              color: Color(0xfff80003),
              icon: Icon(Icons.group_add),
              onPressed: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Client();
                    },
                  ),
                );
              },
            ),
            title: new Text('Nouveau Client', style: TextStyle(color: Color(0xff0200F4))),
          ),
          BottomNavigationBarItem(
            icon: new IconButton(
              color: Color(0xfff80003),
              icon: Icon(Icons.home),
              onPressed: (){
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
            title: new Text('Accueil', style: TextStyle(color: Color(0xff0200F4))),
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                color: Color(0xfff80003),
                icon: Icon(Icons.edit),
                onPressed: (){
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
              title: Text('Nouvelle Entrée', style: TextStyle(color: Color(0xff0200F4)),)
          )
        ],
      ) : Text(''),

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
              accountEmail: (adm == '0' || adm == '1') ? Text('Lavage: $libLavage \nVous êtes $statu') : Text('Vous êtes $statu'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Color(0xff003372),
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
              title: Text('Nouvelle Entrée'),
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
              title: Text('Transactions'),
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
              title: Text('Paramètres'),
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
              title: Text('Tutoriel'),
              onTap: () async{
                setState(() {
                  load = false;
                });
                await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Tutoriel();
                    },
                  ),
                );
                setState(() {
                  load = true;
                });
              },
            ),
            ListTile(
              title: Text('A propos'),
              onTap: () async{
                setState(() {
                  load = false;
                });
                await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Apropos();
                    },
                  ),
                );

                setState(() {
                  load = true;
                });
              },
            ),
            ListTile(
              title: Text('Déconnexion'),
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

            Container(
              margin: const EdgeInsets.only(top: 55.0,),
              padding: EdgeInsets.symmetric(horizontal:20.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('Suivez-nous', style: TextStyle(color: Colors.red),),),
                  //SizedBox(width: 170,),
                  IconButton(
                    iconSize: 40.0,
                    color: Colors.blue,
                    icon: FaIcon(FontAwesomeIcons.facebook),
                    onPressed: ()async{
                      await _launchFacebookURL();

                    },
                  ),

                  SizedBox(width: 20,),

                  IconButton(
                    iconSize: 40.0,
                    color: Colors.red,
                    icon: FaIcon(FontAwesomeIcons.chrome),
                    onPressed: ()async{

                      await _launchMaxomURL();
                    },
                  ),
                ],
              ),
            )


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

  var adm;
  var statu;
  var libLavage;

  Future <void> getStatut()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idUser = localStorage.getInt('ID');
    adm = localStorage.getString('Admin');

    if(adm == '0' || adm == '1'){
      var res = await CallApi().getData('getUser/$idUser');
      print('le corps $res');
      var resBody = json.decode(res.body)['data'];

      if(resBody['success']){

        setState((){
          statu = resBody['status'];
          libLavage = resBody['nomLavage'];

        });
      }

    }else{
      var res2 = await CallApi().getData('getUserSuperAdmin/$idUser');
      var resBody2 = json.decode(res2.body)['data'];

      if(resBody2['success']){

        setState((){
          statu = resBody2['status'];
        });
      }
    }

  }

  _launchFacebookURL() async {
    const url = 'https://www.facebook.com/AGLA-103078671237266/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMaxomURL() async {
    const url = 'https://agla.app';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


