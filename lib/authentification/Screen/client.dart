import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/authentification/Models/Couleurs.dart';
import 'package:lavage/authentification/Models/Marques.dart';
import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lavage/authentification/Screen/apropos.dart';

import 'package:lavage/authentification/Screen/register.dart';
import 'package:lavage/authentification/Screen/tutoriel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Listes/listagents.dart';
import 'Listes/listclients.dart';
import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'dashbord.dart';
import 'historique.dart';
import 'login_page.dart';

class Client extends StatefulWidget {
  @override
  _ClientState createState() => new _ClientState();
}

class _ClientState extends State<Client> {
  AutoCompleteTextField searchTextField1;
  AutoCompleteTextField searchTextField2;
  GlobalKey <AutoCompleteTextFieldState<Datu1>> key1 = GlobalKey();
  GlobalKey <AutoCompleteTextFieldState<Datu2>> key2 = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nomClient = TextEditingController();
  final TextEditingController _contactClient = TextEditingController();
  final TextEditingController _matricule = TextEditingController();
//  final TextEditingController _couleurVehicule = TextEditingController();
//  final TextEditingController _marqueVehicule = TextEditingController();

  static List <Datu1> Listmarques = List <Datu1>() ;
  static List <Datu2> Listcouleurs = List <Datu2>() ;
  var searchValMarque ;
  var searchValCouleur ;

  static List <Datu1> loadMarques(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datu1>((json)=>Datu1.fromJson(json)).toList();
  }

  static List <Datu2> loadCouleurs(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datu2>((json)=>Datu2.fromJson(json)).toList();
  }



  String _mySelection;
  String _mySelection2;
  String email;
  String nomClient;
  String contactClient;
  String matricule;
  var idClient = 0;
  bool success = false;
  bool loading = true;
  bool load = true;
  bool loader1 = true;
  bool loader2 = true;
  String date = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());


//  final String urlCouleur = "http://192.168.43.217:8000/api/couleur";
//  final String urlMarque = "http://192.168.43.217:8000/api/marque";
  List data = List() ;
  List data2 = List() ;//edited line

  var fenetre = 'CLIENT';

  Future<String> getCouleur() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('couleur');
    //final res = await http.get(Uri.encodeFull(urlCouleur), headers: {"Accept": "application/json","Content-type" : "application/json",});


    if(res.statusCode == 200) {
      var resBody = json.decode(res.body)['data'];
      setState(() {
        //listclients = loadClients(res.body);
        Listcouleurs = loadCouleurs(res.body);
        loader2 = false ;
        // data = resBody;
      });
    }
    //print(resBody);
    return "Success";
  }

  Future<String> getMarque() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('marque');
    //final res = await http.get(Uri.encodeFull(urlMarque), headers: {"Accept": "application/json","Content-type" : "application/json",});

    if(res.statusCode == 200) {
      var resBody = json.decode(res.body)['data'];

      setState(() {
        //listclients = loadClients(res.body);
        Listmarques = loadMarques(res.body);
        loader1 = false ;
        // data = resBody;
      });

    }

    //print(resBody);
    return "Success";
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

  void getIdClient() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('getClient/$id');

    //var urlClient = "http://192.168.43.217:8000/api/getClient/$id";
    //final res = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    if(resBody == null){
      setState(() {
        idClient = 0;
      });
    }else{
      setState(() {
        idClient = resBody[0]['id'];
      });
    }
    print('les donnees sont : $idClient');

  }

  Widget row1(Datu1 ag){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(ag.marque, style: TextStyle(fontSize: 18.0),)
      ],
    );
  }

  Widget row2(Datu2 ag){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(ag.couleur, style: TextStyle(fontSize: 18.0),)
      ],
    );
  }

  List<Widget> createListClient1(){
    List<Widget> widgets = [];

    for(Datu1 datu1 in Listmarques){
      widgets.add(Row(
        children: <Widget>[
          Expanded(
            child: Text(datu1.id.toString()),
          ),
          Expanded(
            child: Text(datu1.id.toString()),
          ),
          Expanded(
            child: Text(datu1.id.toString()),
          ),
        ],
      ));
    }
  }

  List<Widget> createListClient2(){
    List<Widget> widgets = [];

    for(Datu2 datu2 in Listcouleurs){
      widgets.add(Row(
        children: <Widget>[
          Expanded(
            child: Text(datu2.id.toString()),
          ),
          Expanded(
            child: Text(datu2.id.toString()),
          ),
          Expanded(
            child: Text(datu2.id.toString()),
          ),
        ],
      ));
    }
  }


  @override
  void initState(){
    super.initState();
    this.getCouleur();
    this.getMarque();
    this.getUserName();
    this.getIdClient();
    this.getStatut();
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
        title: Text('$fenetre'),
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
                  LogoAClient(),
                  SizedBox(height: 40.0),
                  Text("Informations Client",
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
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
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
                           // validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                           // onSaved: (value) => contactClient = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Contact",
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
                            //textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            //obscureText: true,
                            autofocus: false,
                            controller: _email,
                           // validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            //onSaved: (value) => _password = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 40.0),
                  Text("Informations Vehicule",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      )
                  ),

                  Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : loader1 ? Center(child: CircularProgressIndicator()) : searchTextField1 = AutoCompleteTextField<Datu1>(
                            key: key1,
                            clearOnSubmit: false,
                            suggestions: Listmarques,
                            style: TextStyle(color: Colors.black, fontSize: 16.0),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
                                hintText: "Marque du véhicule",
                                hintStyle: TextStyle(color: Colors.black, fontSize: 18.0)
                            ),
                            itemFilter: (item, query){
                              return item.marque.toLowerCase().startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b){
                              return a.marque.compareTo(b.marque);
                            },
                            itemSubmitted: (item){
                              setState(() {
                               // idmatricule = null;
                               // affiche = false;
                                searchTextField1.textField.controller.text = item.marque;
                                searchValMarque = item.id ;
                                //idclient = searchVal;
                                //getNomClient();
                              });
                            },
                            itemBuilder: (context, item){
                              return row1(item);
                            },

                          ),)
                    ],

                  )),

                  ////////////////////////////////////////////////////////////////
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : loader2 ? Center(child: CircularProgressIndicator()) : searchTextField2 = AutoCompleteTextField<Datu2>(
                            key: key2,
                            clearOnSubmit: false,
                            suggestions: Listcouleurs,
                            style: TextStyle(color: Colors.black, fontSize: 16.0),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
                                hintText: "Couleur du véhicule",
                                hintStyle: TextStyle(color: Colors.black, fontSize: 18.0)
                            ),
                            itemFilter: (item, query){
                              return item.couleur.toLowerCase().startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b){
                              return a.couleur.compareTo(b.couleur);
                            },
                            itemSubmitted: (item){
                              setState(() {
                                // idmatricule = null;
                                // affiche = false;
                                searchTextField2.textField.controller.text = item.couleur;
                                searchValCouleur = item.id ;
                                //idclient = searchVal;
                                //getNomClient();
                              });
                            },
                            itemBuilder: (context, item){
                              return row2(item);
                            },

                          ),)
                    ],

                  )),

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
                            color: Colors.red,
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
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
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
                              child: loading ? FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff003372),
                                onPressed: ()async{
                                  setState(() {
                                    loading = false;
                                  });

                                  await checkMatriculeAndContact();

                                  setState(() {
                                    loading = true;
                                  });

                                    //_sendDataClient();
                                    //_sendDataMatricule();
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
                                color: Color(0xff003372),
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
                                onPressed: () async{
                                  setState(() {
                                    load = false;
                                  });
                                 await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ListClient();
                                      },
                                    ),
                                  );

                                 setState(() {
                                   load = true;
                                 });
                                },
                              ),
                            )
                          ],
                        ),
                      ),)],),

                  SizedBox(height: 50.0),

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
  Future <String> _sendDataClient() async{

    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      var id_user = localStorage.getInt('ID');

      var data = {
        'nom': _nomClient.text.toUpperCase(),
        'contact': _contactClient.text,
        'email': _email.text,
        'dateEnreg': date,
        'id_lavage': id,

      };

      var dataLog = {
        'fenetre': '$fenetre',
        'tache': "Enregistrement d'un Client",
        'execution': "Enregistrer",
        'id_user': id_user,
        'dateEnreg': date,
        'id_lavage': id,
        'type_user': statu,
      };

      var res = await CallApi().postAppData(data, 'create_client');

      if (res.statusCode == 200) {
        var resLog = await CallApi().postData(dataLog, 'create_log');
        var body = json.decode(res.body)['data'];

        setState(() {
          // success = true;
          idClient = body[0]['id'];
        });

        if (res.statusCode == 200) {
          _sendDataMatricule();
        }
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

  Future <void> _sendDataMatricule() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');

    if(validateAndSave()) {

      //_sendDataClient();

      var data = {
        'id_client': idClient,
        'libelle_matricule': _matricule.text,
        'dateEnreg': date,
        'id_lavage': idlavage,
        'id_couleur': searchValCouleur,
        'id_marque': searchValMarque,
      };

      var res = await CallApi().postAppData(data, 'create_matricule');

      if(res.statusCode == 200) {
        setState(() {
          success = false;
          _nomClient.text = '';
          _contactClient.text = '';
          _matricule.text = '';
          _email.text = '';
          searchTextField1.textField.controller.text = "";
          searchTextField2.textField.controller.text = "";
        });

        _showMsg("Donnees enregistrees avec succes");
      }else{
        _showMsg("Erreur d'enregistrement des donnees");
      }

    }
  }

  void checkMatriculeAndContact()async {
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');

      if (_contactClient.text != '') {
        var resContact = await CallApi().getData(
            'checkContact/$id/${_contactClient.text}');
        var contactbody = json.decode(resContact.body);


        var resMatricule = await CallApi().getData(
            'checkMatricule/$id/${_matricule.text}');
        var matriculebody = json.decode(resMatricule.body);

        if ((matriculebody['success']) || (contactbody['success'])) {
          // print('donnee 1 $matriculebody');
          //print('donnee 2 $contactbody');
          _showMsg("Ce matricule ou ce contact existe deja !!!");
        } else {
          //_showMsg("existe pas!!!");
          _sendDataClient();
        }
      } else {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var id = localStorage.getString('id_lavage');
        var resMatricule = await CallApi().getData(
            'checkMatricule/$id/${_matricule.text}');
        var matriculebody = json.decode(resMatricule.body);

        if ((matriculebody['success'])) {
          // print('donnee 1 $matriculebody');
          //print('donnee 2 $contactbody');
          _showMsg("Ce matricule existe deja !");
        } else {
          //_showMsg("existe pas!!!");
          _sendDataClient();
        }
      }
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


class LogoAClient extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/Client.jpg');
    Image image = Image(image: assetImage, width: 250.0,);

    return Container(child: image,);
  }

}



