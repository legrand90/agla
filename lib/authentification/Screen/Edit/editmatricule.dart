import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsMatricule.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../Transaction.dart';
import '../client.dart';
import '../historique.dart';
import '../login_page.dart';

//import 'Agent.dart';
//import 'Listes/listMatricule.dart';
//import 'Listes/listclients.dart';
//import 'Tabs/clientPage.dart';
//import 'Transaction.dart';
//import 'client.dart';


class EditMatricule extends StatefulWidget {

  var idmatricule;
  var idcouleur;
  var idmarque;
  var idcli;
  EditMatricule({Key key, @required this.idmatricule, this.idcouleur, this.idmarque, this.idcli}) : super(key: key);

  @override
  _EditMatriculeState createState() => new _EditMatriculeState(idmatricule, idcouleur, idmarque, idcli);
}

class _EditMatriculeState extends State<EditMatricule> {
  var idmatricule;
  var idcouleur;
  var idmarque;
  var idcli;
  _EditMatriculeState(this.idmatricule, this.idcouleur, this.idmarque, this.idcli);

  AutoCompleteTextField searchTextField;
  GlobalKey <AutoCompleteTextFieldState<Datu>> key = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _matricule = TextEditingController();
  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  static List <Datu> listclients = List <Datu>()  ;
  List data = List() ;
  List data2 = List() ;
  List data3 = List() ;//edited line
  var data4 ;
  var commission;
  var tarification;
  var id ;
  var idTari ;
  var id_commission;

  var searchVal ;

  var matricule ;

  String _mySelection;
  String _mySelection2;



  bool visible = false;

  bool loading = true;

  bool defaultColor = false;

  bool defaultMarque = false ;

  bool defaultClient = false ;




  static List <Datu> loadClients(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datu>((json)=>Datu.fromJson(json)).toList();
  }


  void getClients() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //final String urlClient = "http://192.168.43.217:8000/api/client/$id";

    var res2 = await CallApi().getData('client/$id');
    // final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
    //final res2 = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
    //var resBody = json.decode(res.body)['data'];

    if(res2.statusCode == 200){

      listclients = loadClients(res2.body);

      setState(() {
        loading  = false ;
      });

    }else{
      _showMsg('ERREUR');
    }



//    setState(() {
//      listclients = loadClients(res2.body);
//      // data = resBody;
//    });

    print('CLIENTS : ${listclients.length}');
  }


  void UpdateMatricule() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

      //try {
      var data = {
        'id_client': defaultClient ? searchVal : this.idcli,
        'libelle_matricule': _matricule.text,
        'dateEnreg': date,
        'id_lavage': id,
        'id_couleur': defaultColor ? _mySelection : idcouleur,
        'id_marque': defaultMarque ? _mySelection2 : idmarque,

      };


      var res = await CallApi().postDataEdit(data, 'update_matricule/$idmatricule/$id');
      var body = json.decode(res.body);
     // print(body);

      if (res.statusCode == 200) {

        setState(() {
          _matricule.text = '';
          searchTextField.textField.controller.text = '';
          searchVal = '' ;
          _mySelection = null;
          _mySelection2 = null;

          defaultColor = false ;
          defaultMarque = false ;
         // defaultClient = false ;

        });

       // _showMsg('Donnees mises a jour avec succes');

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return DetailsMatricule(idclient: int.parse(defaultClient ? searchVal : idcli));
            },
          ),
        );


      }else{
        _showMsg("Erreur d'enregistrement");
      }

  }



  //SharedPreferences localStorage = await SharedPreferences.getInstance();


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

  Widget row(Datu ag){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(ag.nom, style: TextStyle(fontSize: 16.0),)
      ],
    );
  }

  void getMatriculeEdit() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    //final String url = "http://192.168.43.217:8000/api/getMatriculeEdit/$idmatricule/$idlavage"  ;

    var res = await CallApi().getData('getMatriculeEdit/$idmatricule/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      _matricule.text = resBody['matricule'];
      //idcli = resBody['id_client'];

    });



    // print('identi est $idpresta');

  }


  @override
  void initState(){
    this.getClients();
    this.getMarque();
    this.getCouleur();
    this.getMatriculeEdit();
    this.getNomCouleur_NomMarque_NomClient();
    super.initState();
    this.getUserName();


  }

  @override
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
          title: Text('MODIFICATION MATRICULE')
      ),
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
                  Text("MATRICULE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 50.0),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: loading ? CircularProgressIndicator() : searchTextField = AutoCompleteTextField<Datu>(
                          key: key,
                          clearOnSubmit: false,
                          suggestions: listclients,
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
                              hintText: "Saisir Client",
                              hintStyle: TextStyle(color: Colors.black)
                          ),
                          itemFilter: (item, query){
                            return item.nom.toLowerCase().startsWith(query.toLowerCase());
                          },
                          itemSorter: (a, b){
                            return a.nom.compareTo(b.nom);
                          },
                          itemSubmitted: (item){
                            setState(() {
                              searchTextField.textField.controller.text = item.nom;
                              searchVal = item.id ;
                              defaultClient = true ;
                            });
                          },
                          itemBuilder: (context, item){
                            return row(item);
                          },

                        ),


                      ),

                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context){
                                return Client();
                              },
                            ),
                          );
                        },
                      )

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton<String>(
                            items: data2.map((value) => DropdownMenuItem<String>(
                              child: Text(
                                value['marque'],
                                style: TextStyle(color: Colors.black),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix){
                              setState(() {
                                _mySelection2 = choix ;
                                defaultMarque = true;
                              });
                            },
                            value: _mySelection2,
                            isExpanded: false,
                            hint: Text('$libmarque'),
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
                            items: data.map((value) => DropdownMenuItem(
                              child: Text(
                                value['couleur'],
                                style: TextStyle(color: Colors.black),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix){
                              setState(() {
                                _mySelection = choix ;
                                defaultColor = true;
                              });
                            },
                            value:  _mySelection ,
                            isExpanded: false,
                            hint: Text('$libCouleur'),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  ),

                  SizedBox(height: 30.0),


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
                            Icons.directions_car,
                            color: Color(0xff11b719),
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            // obscureText: true,
                            autofocus: false,
                            controller: _matricule,
                            validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            //  onSaved: (value) => matricule = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Matricule",
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
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff11b719),
                                onPressed: (){
                                  setState(() {
                                    UpdateMatricule();
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
                              ),
                            ),

                            Container(
                              width: 10.0,
                            ),



                          ],
                        ),
                      )),

                      //////////////////////////////////////////////////////////
//                      Container(
//                        width: 50.0,
//                      ),


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
  void _sendDataMatricule() async{
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idlavage = localStorage.getString('id_lavage');
      var data = {
        'id_client': searchVal,
        'libelle_matricule': _matricule.text,
        'dateEnreg': date,
        'id_lavage': idlavage,

      };

      var res = await CallApi().postAppData(data, 'create_matricule');
      // var body = json.decode(res.body)['data'];

      if(res.statusCode == 200){
        setState(() {
          _matricule.text = '';
          searchTextField.textField.controller.text = '';
          searchVal = '' ;

        });
        _showMsg('Donnees enregistrees avec success');

      }else{
        _showMsg("ERREUR");
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

//  final String urlCouleur = "http://192.168.43.217:8000/api/couleur";
//  final String urlMarque = "http://192.168.43.217:8000/api/marque";

  Future<String> getCouleur() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('couleur/$id');
    //final res = await http.get(Uri.encodeFull(urlCouleur), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    setState(() {
      data = resBody;
    });

    print(resBody);
    return "Success";
  }

  Future<String> getMarque() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('marque/$id');
   // final res = await http.get(Uri.encodeFull(urlMarque), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    setState(() {
      data2 = resBody;
    });

    //print(resBody);
    return "Success";
  }

  var libCouleur ;
  var libmarque ;

  Future<String> getNomCouleur_NomMarque_NomClient() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('getCouleur/$idcouleur/$id');
    var res2 = await CallApi().getData('getMarque/$idmarque/$id');
    var res3 = await CallApi().getData('getClientEdit/$idcli/$id');
    //final res = await http.get(Uri.encodeFull(urlCouleur), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];
    var resBody2 = json.decode(res2.body)['data'];
    var resBody3 = json.decode(res3.body)['data'];

    setState(() {
      libCouleur = resBody['couleur'];
      libmarque = resBody2['marque'];
      searchTextField.textField.controller.text = resBody3['nom'];
      //_mySelection = libCouleur;
    });

    //print(idcli);
    return "Success";
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



