import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Couleurs.dart';
import 'package:lavage/authentification/Models/Marques.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsMatricule.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/apropos.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Transaction.dart';
import '../client.dart';
import '../historique.dart';
import '../login_page.dart';
import '../tutoriel.dart';

//import 'Agent.dart';
//import 'Listes/listMatricule.dart';
//import 'Listes/listclients.dart';
//import 'Tabs/clientPage.dart';
//import 'Transaction.dart';
//import 'client.dart';


class EditMatricule extends StatefulWidget {

  EditMatricule({Key key, @required this.idmatricule, this.idcouleur, this.idmarque, this.idcli, this.nomCli}) : super(key: key);
  var idmatricule;
  var idcouleur;
  var idmarque;
  var idcli;
  var nomCli;

  @override
  _EditMatriculeState createState() => new _EditMatriculeState(idmatricule, idcouleur, idmarque, idcli, nomCli);
}

class _EditMatriculeState extends State<EditMatricule> {

  _EditMatriculeState(this.idmatricule, this.idcouleur, this.idmarque, this.idcli, this.nomCli);

  var idmatricule;
  var idcouleur;
  var idmarque;
  var idcli;
  var nomCli;

  AutoCompleteTextField searchTextField;
  GlobalKey <AutoCompleteTextFieldState<Datu>> key = GlobalKey();
  AutoCompleteTextField searchTextField1;
  AutoCompleteTextField searchTextField2;
  GlobalKey <AutoCompleteTextFieldState<Datu1>> key1 = GlobalKey();
  GlobalKey <AutoCompleteTextFieldState<Datu2>> key2 = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _matricule = TextEditingController();
  String date = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  static List <Datu> listclients = List <Datu>()  ;
  static List <Datu1> Listmarques = List <Datu1>() ;
  static List <Datu2> Listcouleurs = List <Datu2>() ;
  List data = List() ;
  List data2 = List() ;
  List data3 = List() ;//edited line
  var data4 ;
  var commission;
  var tarification;
  var id ;
  var idTari ;
  var id_commission;
  var searchValMarque ;
  var searchValCouleur ;
  var searchVal ;

  var matricule ;

  String _mySelection;
  String _mySelection2;



  bool visible = false;

  bool loading = true;

  bool defaultColor = false;

  bool defaultMarque = false ;

  bool defaultClient = false ;

  bool loader = true;

  bool load = true;
  bool loader1 = true;
  bool loader2 = true;

  var fenetre = 'MODIFICATION INFOS VEHICULE';




  static List <Datu> loadClients(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datu>((json)=>Datu.fromJson(json)).toList();
  }

  static List <Datu1> loadMarques(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datu1>((json)=>Datu1.fromJson(json)).toList();
  }

  static List <Datu2> loadCouleurs(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datu2>((json)=>Datu2.fromJson(json)).toList();
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
    var id_user = localStorage.getInt('ID');

      //try {
      var data = {
        'id_client': defaultClient ? searchVal : this.idcli,
        'libelle_matricule': _matricule.text,
        'dateEnreg': date,
        'id_lavage': id,
        'id_couleur': defaultColor ? searchValCouleur : CouleurId,
        'id_marque': defaultMarque ? searchValMarque : marqueId,

      };

    var dataLog = {
      'fenetre': '$fenetre',
      'tache': "Modification infos vehicule",
      'execution': "Update",
      'id_user': id_user,
      'dateEnreg': date,
      'id_lavage': id,
      'type_user': statu,
    };


      var res = await CallApi().postDataEdit(data, 'update_matricule/$idmatricule/$id');
      var body = json.decode(res.body);
     // print(body);

      if (res.statusCode == 200) {
        var res = await CallApi().postData(dataLog, 'create_log');


       // _showMsg('Donnees mises a jour avec succes');

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return DetailsMatricule(idclient: int.parse(defaultClient ? searchVal : idcli), nomClient: nomCli,);
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
        Text(ag.nom, style: TextStyle(fontSize: 20.0),)
      ],
    );
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
      searchTextField.textField.controller.text = nomCli;
      searchTextField2.textField.controller.text = idcouleur;
      searchTextField1.textField.controller.text = idmarque;

    });



     //print('identi est $idcouleur');

  }


  @override
  void initState(){
    this.getClients();
    this.getMarque();
    this.getCouleur();
    this.getMatriculeEdit();
    this.getIdCouleur_IdMarque();
    super.initState();
    this.getUserName();
    this.getStatut();


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
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('MODIFICATION MATRICULE')
      ),
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
                  logo,
                  //SizedBox(height: 40.0),
                  Text("MATRICULE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 20.0),

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: loading ? Center(child: CircularProgressIndicator()) : searchTextField = AutoCompleteTextField<Datu>(
                          key: key,
                          clearOnSubmit: false,
                          suggestions: listclients,
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
                              hintText: "Saisir Client",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0)
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

                    ],
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
                                  defaultMarque = true;
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
                                  defaultColor = true ;
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
                              child: loader ? FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff003372),
                                onPressed: ()async{
                                  setState(() {
                                    loader = false;
                                  });

                                   await UpdateMatricule();

                                   setState(() {
                                     loader = true;
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
              accountEmail: Text(''),
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


    var res = await CallApi().getData('couleur');
    //final res = await http.get(Uri.encodeFull(urlCouleur), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    if(res.statusCode == 200) {
      Listcouleurs = loadCouleurs(res.body);
      setState(() {
        //listclients = loadClients(res.body);

        loader2 = false;
        // data = resBody;
      });
    }

    print(resBody);
    return "Success";
  }

  Future<String> getMarque() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('marque');
   // final res = await http.get(Uri.encodeFull(urlMarque), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    if(res.statusCode == 200) {
      Listmarques = loadMarques(res.body);
      setState(() {
        //listclients = loadClients(res.body);

        loader1 = false;
        //searchTextField1.textField.controller.text = this.idmarque;
        // data = resBody;
      });
    }

    //print(resBody);
    return "Success";
  }

  var CouleurId ;
  var marqueId ;

  void getIdCouleur_IdMarque()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var id = localStorage.getString('id_lavage');

    var resMarque = await CallApi().getData('getIdMarque/$idmarque');
    var resCouleur = await CallApi().getData('getIdCouleur/$idcouleur');
    // final res = await http.get(Uri.encodeFull(urlMarque), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBodyMarque = json.decode(resMarque.body)['data'];
    var resBodyCouleur = json.decode(resCouleur.body)['data'];

    setState(() {
      marqueId = resBodyMarque['id'];
      CouleurId = resBodyCouleur['id'];
    });

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

  _launchFacebookURL() async {
    const url = 'https://www.facebook.com/AGLA-103078671237266/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMaxomURL() async {
    const url = 'https://maxom.ci';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var adm;
  var statu;
  var libLav;

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
          //libLavage = resBody['nomLavage'];

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
}



