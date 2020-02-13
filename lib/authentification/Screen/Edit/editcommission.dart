import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsCommission.dart';
import 'package:lavage/authentification/Screen/Listes/listCommissions.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lavage/authentification/Screen/dashbord.dart';

import '../Transaction.dart';
import '../historique.dart';
import '../login_page.dart';

//import 'Listes/listCommissions.dart';
//import 'Tabs/clientPage.dart';
//import 'Transaction.dart';

class EditCommission extends StatefulWidget {
  var idcommission ;
  var idtarif ;
  var idagent ;
  var prestaEtMontant;
      EditCommission({Key key, @required this.idcommission, this.idagent, this.prestaEtMontant, this.idtarif}) : super(key: key);
  @override
  _EditCommissionState createState() => new _EditCommissionState(idcommission, idagent, prestaEtMontant, idtarif);
}

class _EditCommissionState extends State<EditCommission> {
  var idcommission ;
  var idtarif ;
  var idagent ;
  var prestaEtMontant;
  _EditCommissionState(this.idcommission, this.idagent, this.prestaEtMontant, this.idtarif) ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _gainAgent = TextEditingController();
  final TextEditingController _nomAgent = TextEditingController();
  final TextEditingController _prestaMontant = TextEditingController();
  //final TextEditingController _password = TextEditingController();

  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());
  String gainAgent;


  //final String urlTarification = "http://192.168.43.217:8000/api/tarification";
  bool val = false;
  bool isButtonDisable = false;
  List data = List() ;
  List data2 = List() ;//edited line
  var id ;
  String _mySelection;
  String _mySelection2;
  var nomAgent;

  bool defaultAgent = false ;

  bool defaultPrestMontant = false ;


  Future<String> getAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
   // final String urlAgent = "http://192.168.43.217:8000/api/agent/$id";

    var res = await CallApi().getData('agent/$id');
    var res2 = await CallApi().getData('getAgent/$idagent/$id');

    //final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];
    var resBody2 = json.decode(res2.body)['data'];


    setState(() {
      data = resBody;
      nomAgent = resBody2['nom'];
    });

    print(resBody);
    return "Success";
  }

  void UpdateCommission() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

      //try {
      var data = {
        'gain_agent': _gainAgent.text,
        'dateEnreg': date,
        'id_lavage': id,
        'id_agent': defaultAgent ? _mySelection : idagent,
        'id_tarification': defaultPrestMontant ? _mySelection2 : idtarif,

      };


      var res = await CallApi().postDataEdit(data, 'update_commission/$idcommission/$id');
      var body = json.decode(res.body);
      print(body);

      if (res.statusCode == 200) {

        setState(() {
//          _gainAgent.text = '';
//          _mySelection = null;
//          _mySelection2 = null;
          //defaultAgent = false;
          defaultPrestMontant = false ;
        });
      //  _showMsg('Donnees mises a jour avec succes');

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return DetailsCommissions(idagent: int.parse(defaultAgent ? _mySelection : idagent));
            },
          ),
        );


      }else{
        _showMsg("Erreur d'enregistrement");
      }

  }


  Future<String> getTarification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //final String urlTarification = "http://192.168.43.217:8000/api/tarification/$id";

    var res = await CallApi().getData('tarification/$id');
    //final res = await http.get(Uri.encodeFull(urlTarification), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];
    //SharedPreferences localStorage = await SharedPreferences.getInstance();

    setState(() {

      data2 = resBody;

      //localStorage.setBool('valeur', null);
    });



    print("idcomm $idcommission \n idag $idagent \n idt $idtarif");
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

  void getCommissionData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String url = "http://192.168.43.217:8000/api/getCommissionEdit/$idcommission/$idlavage"  ;

    var res = await CallApi().getData('getCommissionEdit/$idcommission/$idlavage');
    var res2 = await CallApi().getData('getAgent/$idagent/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];
    var resBody2 = json.decode(res2.body)['data'];

    setState(() {
      _gainAgent.text = resBody['gain_agent'];
      _nomAgent.text = resBody2['nom'];
      _prestaMontant.text = prestaEtMontant;
      idtarif = resBody['id_tarification'];

    });


    // print('identi est $idpresta');

  }


  @override
  void initState(){
    super.initState();
    this.getAgent();
    this.getTarification();
    this.getCommissionData();
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
      appBar: AppBar(
        title: Text('COMMSSION'),
      ),
      backgroundColor: Color(0xFFDADADA),
      body: Form(
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
                  logo,
                  SizedBox(height: 40.0),
                  Text("COMMISSION",
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton(
                            items: data.map((value) => DropdownMenuItem(
                              child: Text(
                                value['nom'],
                                style: TextStyle(color: Colors.black),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix){
                              setState(() {
                                _mySelection = choix ;
                                defaultAgent = true ;
                              });
                            },
                            value: _mySelection,
                            isExpanded: false,
                            hint: Text('$nomAgent'),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  ),

                  ////////////////////////////////////////////////////////////////

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton(
                            items: data2.map((value) => DropdownMenuItem(
                              child: Text(
                                value['prestation_montant'],
                                style: TextStyle(color: Colors.black),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix){
                              setState(() {
                                _mySelection2 = choix ;
                                defaultPrestMontant = true ;
                              });
                            },
                            value: _mySelection2,
                            isExpanded: false,
                            hint:  Text('$prestaEtMontant') ,
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

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
                              Icons.monetization_on,
                              color: Color(0xff11b719),
                              size: 27.0
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            //autofocus: false,
                            controller: _gainAgent,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => gainAgent = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Gain en Fcfa",
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
                    children : <Widget>[
                      Expanded(child :Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child:  FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff11b719),
                                onPressed: (){

                                  UpdateCommission();
                                } ,


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
                      )
                      ),

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



