import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
//import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Models/Matricule.dart';
import 'package:lavage/authentification/Screen/Listes/listTransactions.dart';
import 'package:lavage/authentification/Screen/apropos.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:lavage/authentification/Screen/tutoriel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Agent.dart';
import 'Listes/listclientlavage.dart';
import 'Listes/listclients.dart';
import 'Tabs/clientPage.dart';
import 'client.dart';
import 'historique.dart';
import 'login_page.dart';


class Transaction extends StatefulWidget {

  int counter = 0 ;

  Transaction({Key key, @required this.counter}) : super(key: key);

  @override
  _TransactionState createState() => new _TransactionState(counter);
}

class _TransactionState extends State<Transaction> {

  AutoCompleteTextField searchTextField;
  GlobalKey <AutoCompleteTextFieldState<Datu>> key = GlobalKey();

  String param ;

  int counter = 0 ;

  _TransactionState(this.counter);

  var texte = 'PRESTATION' ;

  var val ;
  var idclient ;
  List listmatri = List();
  var idmatricule ;

  bool loading = true;
  bool loader = true;
  bool load = true;

  var fenetre = 'TRANSACTIONS';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _gainAgent = TextEditingController();
  //final TextEditingController _password = TextEditingController();

  String date = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  String gainAgent;

//  final String urlAgent = "http://192.168.43.217:8000/api/agent";
//
//  final String urlTarification = "http://192.168.43.217:8000/api/getLastTarification";


  //static List <Datu> listclients = List <Datu>()  ;
  static List <Datu> Listmatricule = List <Datu>() ;
  List data = List() ;
  List data2 = List() ;
  List data3 = List() ;//edited line
  var data4 ;
  var commission;
  var tarification;
  var id ;
  var idTari ;
  var id_commission;
  String _mySelection;
  String _mySelection2;
  String _mySelection3 ;
  var searchVal ;


  bool visible = false;


  static List <Datu> loadClients(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datu>((json)=>Datu.fromJson(json)).toList();
  }

  Future<String> getAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('agent/$id');
   // final String urlAgent = "http://192.168.43.217:8000/api/agent/$id";
   // final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
   // final res2 = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});

    var resBody = json.decode(res.body)['data'];


    setState(() {

      data = resBody;
    });

    //print('AGENTS : ${listagents.length}');
    return "Success";
  }


  void getClients() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('listImmatriculations/$id');

    if(res.statusCode == 200){

      setState(() {
        //listclients = loadClients(res.body);
        Listmatricule = loadClients(res.body);
        loading = false ;
        // data = resBody;
      });
    }

    print('Cli : ${Listmatricule.length}');

  }


//  Future<String> getLastTarification() async {
//    final res = await http.get(Uri.encodeFull(urlTarification), headers: {"Accept": "application/json","Content-type" : "application/json",});
//    var resBody = json.decode(res.body)['data'];
//
//
//    setState(() {
//      tarification = resBody['montant'];
//      id = resBody['id'];
//    });
//
//
//    print(resBody['id']);
//    return "Success";
//  }



  Future<String> getPrestation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('prestation/$id');
   // final String urlPrestation = "http://192.168.43.217:8000/api/prestation/$id";
//    final res = await http.get(Uri.encodeFull(urlPrestation), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      data3 = resBody;
      param = _mySelection3 ;
    });

    print(param);
    return "Success";
  }


  Future<String> getClient() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('client/$id');
    //final String urlClient = "http://192.168.43.217:8000/api/client/$id";
   // final res = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];


    setState(() {
      data2 = resBody;

    });



    //print(resBody['id']);
    return "Success";
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
        Text(ag.matricule, style: TextStyle(fontSize: 18.0),)
      ],
    );
  }


  List<Widget> createListClient(){
    List<Widget> widgets = [];

    for(Datu datu in Listmatricule){
      widgets.add(Row(
        children: <Widget>[
          Expanded(
            child: Text(datu.id.toString()),
          ),
          Expanded(
            child: Text(datu.id.toString()),
          ),
          Expanded(
            child: Text(datu.id.toString()),
          ),
        ],
      ));
    }
  }

  var nomClient;
  var contactClient;
  bool affiche = false;

  void getNomClient() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('nomClientByImmatriculation/$id/$searchVal');
   // String url = "http://192.168.43.217:8000/api/matricule/$id/$idclient";
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
     var resBody = json.decode(res.body);
    // final response = await http.get('$url');

      setState(() {
        nomClient = resBody['nomClient'];
        contactClient = resBody['contactClient'];
        idclient = resBody['idClient'];
        affiche = true;
      });

  }

  var success, on_off, alerte, heure, smsR;

  void smsConfig() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('getSmsConfigData/$id');
    var res2 = await CallApi().getData('getSmsoperaData/$id');
    // String url = "http://192.168.43.217:8000/api/matricule/$id/$idclient";
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body);
    var resBody2 = json.decode(res2.body);
    // final response = await http.get('$url');

    setState(() {
      success = resBody['success'];
      on_off = resBody['on_off'];
      alerte = resBody['alerte'];
      heure = resBody['heure'];
      smsR = resBody2['smsR'];
    });

    //print("smsR  : ${resBody2['smsR']}");
   // print("alerte  : ${resBody['alerte']}");
   // print("etat  : ${resBody['on_off']}");

  }

//  var recette;
//  var commissions;
//  void getRecette() async{
//    SharedPreferences localStorage = await SharedPreferences.getInstance();
//    var id = localStorage.getString('id_lavage');
//    String url = "http://192.168.43.217:8000/api/getCommissionsAndRecette/$date/$id";
//    final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
//    var resBody = json.decode(res.body);
//    // final response = await http.get('$url');
//
//    setState(() {
//      recette = resBody['recette'];
//      commissions = resBody['commissions'];
//    });
//
//    print("la recette est  : ${recette['recette']}");
//
//  }

  Timer timer;

  Future<bool> _alertSMS(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Il vous reste $alerte SMS ."),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context, false),
            ),

          ],
        )
    );
  }


  @override
  void initState(){
    super.initState();
    this.getAgent();
    this.getClients();
    this.getUserName();
    this.smsConfig();
    this.getPrestation();
    this.getStatut();
    //timer = Timer.periodic(Duration(seconds: 5), (Timer t) => this.getClients());
    //this.getLastCommission();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  Widget build(BuildContext context){
   // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
      //DeviceOrientation.portraitDown
    //]);
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
          title: Text('$fenetre')
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
                  LogoTransactions(),
                  SizedBox(height: 20.0),

                  SizedBox(height: 30.0),

                  Text("INFOS CLIENT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff003372),
                          fontWeight: FontWeight.bold
                      )
                  ),

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: loading ? Center(child: CircularProgressIndicator()) : searchTextField = AutoCompleteTextField<Datu>(
                          key: key,
                          clearOnSubmit: false,
                          suggestions: Listmatricule,
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
                              hintText: "PLAQUE D'IMMATRICULATION",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0)
                          ),
                          itemFilter: (item, query){
                            return item.matricule.toLowerCase().startsWith(query.toLowerCase());
                          },
                          itemSorter: (a, b){
                            return a.matricule.compareTo(b.matricule);
                          },
                          itemSubmitted: (item){
                            setState(() {
                              idmatricule = null;
                              affiche = false;
                              searchTextField.textField.controller.text = item.matricule;
                              searchVal = item.id ;
                              //idclient = searchVal;
                              getNomClient();
                            });
                          },
                          itemBuilder: (context, item){
                            return row(item);
                          },

                        ),

                      ),
                    ],
                  )),

                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child :
                    Row(
                      children: <Widget>[
                        Text('NOM : ', style: TextStyle(fontSize: 18.0)),
                        //SizedBox(width: 20.0,),
                        affiche ? Expanded(child: Text('  $nomClient', style: TextStyle(fontSize: 18.0)),) : Text('')
                      ],
                    ),

                  ),

                  SizedBox(height: 10.0,),

                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child :
                    Row(
                      children: <Widget>[
                        Text('CONTACT : ', style: TextStyle(fontSize: 18.0)),
                        //SizedBox(width: 20.0,),
                        affiche ? Expanded(child: Text('  $contactClient', style: TextStyle(fontSize: 18.0)),) : Text('')
                      ],
                    ),

                  ),

                  SizedBox(height: 40.0,),

                  ////////////////////////////////////////////////////////////////

                  Text("SELECTIONNER AGENT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff003372),
                          fontWeight: FontWeight.bold
                      )
                  ),

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton(
                            items: data.map((value) => DropdownMenuItem(
                              child: Text(
                                value['nom'],
                                style: TextStyle(color: Colors.black, fontSize: 18.0),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix){
                              setState(() {

                                _mySelection = choix ;

                                if(_mySelection3 == val){

                                  _mySelection3 = null ;
                                }
                               // getPrestation();
                                visible = false ;
                              });


                            },
                            value: _mySelection,
                            isExpanded: true,
                            hint: Text('AGENT', style: TextStyle(fontSize: 18.0),),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  )),

                  SizedBox(height: 30.0,),

                  Text("SELECTIONNER PRESTATION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff003372),
                          fontWeight: FontWeight.bold
                      )
                  ),

              Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton(
                            items: data3.map((value) => DropdownMenuItem(
                              child: Text(
                                value['libelle_prestation'],
                                style: TextStyle(color: Colors.black, fontSize: 18.0),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix){
                              setState(() {
                                if(_mySelection == null){
                                  _showMsg('Veuillez selectionner un Agent !');
                                }else{
                                  _mySelection3 = choix ;

                                  val = _mySelection3 ;

                                  getTarification();

                                  //visible = true;

                                }

                               // param = _mySelection3.toString() ;

                              });


                            },
                            value: _mySelection3,
                            isExpanded: true,
                            hint: Text('$texte', style: TextStyle(fontSize: 18.0),),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  )),

                  visible ?
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        child: Row(
                          children: <Widget>[
                              Text('Coût Prestation (FCFA) :', style: TextStyle(fontSize: 18.0)),
                            Expanded(
                              child: Text('  $data4', style: TextStyle(fontSize: 18.0)),
                            ),
                          ],
                        )) : Text(''),

                    visible ?
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        child: Row(
                          children: <Widget>[
                            Text('Commission Agent (FCFA) :', style: TextStyle(fontSize: 18.0)),
                            Expanded(
                              child: Text('  $commission', style: TextStyle(fontSize: 18.0)),
                            ),
                          ],
                        )) : Text(''),

                  ////////////////////////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),

                  ////////////////////////////////////////////////////////////////

                  Row(
                    children : <Widget>[
                      Expanded(child :
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
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
                                  await _sendDataTransaction();

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

                          new Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              ),
                              color: Color(0xff003372),
                              onPressed: () async{
                                setState(() {
                                  load = false;
                                });
                                 await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context){
                                        return ListTransaction();
                                      },
                                    ),
                                  );
                                 setState(() {
                                   load = true;
                                 });

                              },
                              child: new Container(
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
                      )),

                      //////////////////////////////////////////////////////////
//                      Container(
//                        width: 50.0,
//                      ),
                    ],
                  ),
                  SizedBox(height: 70.0),

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
                    builder: (BuildContext context){
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
  void _sendDataTransaction() async{
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idlavage = localStorage.getString('id_lavage');
      var id_user = localStorage.getInt('ID');
      var data = {
        'id_prestation': _mySelection3,
        'dateEnreg': date,
        'id_lavage': idlavage,
        'id_agent': _mySelection,
        'id_client': idclient,
        'id_commission': id_commission,
        'id_tarification': idTari,
        'tarification': data4,
        'id_matricule_vehicule': searchVal,

      };

      var dataLog = {
        'fenetre': '$fenetre',
        'tache': "Enregistrement des Transactions",
        'execution': "Enregistrer",
        'id_user': id_user,
        'dateEnreg': date,
        'id_lavage': idlavage,
        'type_user': statu,
      };

      var dataSolde = {
        'montant': '$commission',
        'id_agent': _mySelection,
        'id_user': id_user,
        'dateEnreg': date,
        'id_lavage': idlavage,
      };

      var dataSms = {
        'sms': 'MERCI POUR VOTRE PASSAGE AU LAVAGE $libLavage.\n\nPRESTATION : $libpresta\nCOUT : $data4 FCFA\nSOYEZ PRUDENT(E), A LA PROCHAINE !',
        'numero': contactClient,
      };

      var upDateDataSms = {
        'contenu': 'MERCI POUR VOTRE PASSAGE AU LAVAGE $libLavage.\n\nPRESTATION : $libpresta\nCOUT : $data4 FCFA\nSOYEZ PRUDENT(E), A LA PROCHAINE !',
        'nom_user': nameUser,
        'dateHeure': date,
        'id_lavage': idlavage,
      };

      if (success) {
        if((on_off == 'on' && int.parse(smsR) > 0 )) {
          if(int.parse(smsR) == int.parse(alerte)){
            _alertSMS();
          }
          var res = await CallApi().postAppData(data, 'create_transaction');

          if (res.statusCode == 200) {
            var resLog = await CallApi().postData(dataLog, 'create_log');
            var resSolde = await CallApi().postData(dataSolde, 'create_solde');

            if(contactClient != ""){
              var resSms = await CallApi().postAppData(dataSms, 'sendSMS');
            }

            setState(() {
              _mySelection = null;
              _mySelection3 = null;
              idmatricule = null;
              searchTextField.textField.controller.text = "";
              visible = false;
              affiche = false;
            });

            if(contactClient != ""){
              var res = await CallApi().postData(upDateDataSms, 'updateSmsEnvoyerEtRestant/$idlavage');
              smsConfig();
            }

            _showMsg("Donnees enregistrees avec succes");
          } else {
           // var res = await CallApi().getData('updateSmsEnvoyerEtRestant/$idlavage');

           //  smsConfig();
          _showMsg("Erreur d'enregistrement des donnees");
          }
        }else{
          var res = await CallApi().postAppData(data, 'create_transaction');

          if (res.statusCode == 200) {
            var resLog = await CallApi().postData(dataLog, 'create_log');
            var resSolde = await CallApi().postData(dataSolde, 'create_solde');
            //var resSms = await CallApi().postAppData(dataSms, 'sendSMS');

            setState(() {
              _mySelection = null;
              _mySelection3 = null;
              idmatricule = null;
              searchTextField.textField.controller.text = "";
              visible = false;
              affiche = false;
            });

            _showMsg("Donnees enregistrees avec succes");
          } else {
            _showMsg("Erreur d'enregistrement des donnees");
          }
        }
    }else{
          var res = await CallApi().postAppData(data, 'create_transaction');

          if (res.statusCode == 200) {
            var resLog = await CallApi().postData(dataLog, 'create_log');
            var resSolde = await CallApi().postData(dataSolde, 'create_solde');
            //var resSms = await CallApi().postAppData(dataSms, 'sendSMS');

            setState(() {
              _mySelection = null;
              _mySelection3 = null;
              idmatricule = null;
              searchTextField.textField.controller.text = "";
              visible = false;
              affiche = false;
            });

            _showMsg("Donnees enregistrees avec succes");
          } else {
            _showMsg("Erreur d'enregistrement des donnees");
          }


      }

    }
  }

  var libpresta;

  void getTarification() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('getTarification/$_mySelection3/$id');

    var resBody = json.decode(res.body)['data'];

    setState(() {
      idTari = resBody['id'];
      data4 = resBody['montant'];
      libpresta = resBody['libpresta'];
    });

    getCommission();

    //print('identi est $idTari');

  }

  void getCommission() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('getCommission/$idTari/$_mySelection/$id');

   // final String urlCommission = "http://192.168.43.217:8000/api/getCommission/$idTari/$_mySelection/$id";
   // final res = await http.get(Uri.encodeFull(urlCommission), headers: {"Accept": "application/json","Content-type" : "application/json",});

    if(res.statusCode == 200){
      var resBody = json.decode(res.body)['data'];
        if(resBody['success']){
        setState(() {
          commission = resBody['gain_agent'];
          id_commission = resBody['id'];
          visible = true;
        });
      }
    }else{

      setState((){
        visible = false;
        _mySelection3 = null;
        commission = '' ;
        data4 = '' ;
      });

      _showMsg("L' Agent que vous avez selectionner n'a pas de commission pour cette prestation");
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


class LogoTransactions extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/Transactions.jpg');
    Image image = Image(image: assetImage, width: 250.0,);

    return Container(child: image,);
  }

}




