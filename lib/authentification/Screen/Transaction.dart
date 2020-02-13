import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Client.dart';
import 'package:lavage/authentification/Screen/Listes/listTransactions.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

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

  var texte = 'Selectionner prestation' ;

  var val ;
  var idclient ;
  List listmatri = List();
  var idmatricule ;

  bool loading = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _gainAgent = TextEditingController();
  //final TextEditingController _password = TextEditingController();

  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  String gainAgent;

//  final String urlAgent = "http://192.168.43.217:8000/api/agent";
//
//  final String urlTarification = "http://192.168.43.217:8000/api/getLastTarification";


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
    var res = await CallApi().getData('client/$id');
   // final String urlClient = "http://192.168.43.217:8000/api/client/$id";
   // final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
  //  final res2 = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
    //var resBody = json.decode(res.body)['data'];

    if(res.statusCode == 200){

      listclients = loadClients(res.body);

      setState(() {
        loading = false ;
        // data = resBody;
      });
    }

    //print('AGENTS : ${listclients.length}');

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
        Text(ag.nom, style: TextStyle(fontSize: 16.0),)
      ],
    );
  }


  List<Widget> createListClient(){
    List<Widget> widgets = [];

    for(Datu datu in listclients){
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

  void getMatriculeVehicule() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('matricule/$id/$idclient');
   // String url = "http://192.168.43.217:8000/api/matricule/$id/$idclient";
    //final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
     var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      listmatri = resBody;
    });

    print('les matriccules : $listmatri');

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


  @override
  void initState(){
    super.initState();
    this.getAgent();
    this.getClients();
    this.getUserName();
    this.getClient();
    //this.getLastTarification();
    this.getPrestation();
    //this.getRecette();
    //this.getMatriculeVehicule();
    //this.getTarification();

    //this.getLastCommission();

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
      backgroundColor: Color(0xFFDADADA),
      appBar: AppBar(
          title: Text('TRANSACTIONS')
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
                  Text("TRANSACTION",
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
                              idclient = searchVal;
                              getMatriculeVehicule();
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

                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton(
                            items: listmatri.map((value) => DropdownMenuItem(
                              child: Text(
                                value['matricule'],
                                style: TextStyle(color: Colors.black),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix){
                              setState(() {
                                idmatricule = choix ;
                              });


                            },
                            value: idmatricule,
                            isExpanded: false,
                            hint: Text('Selectionner Matricule'),
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
                                value['nom'],
                                style: TextStyle(color: Colors.black),
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
                            isExpanded: false,
                            hint: Text('Selectionner Agent'),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton(
                            items: data3.map((value) => DropdownMenuItem(
                              child: Text(
                                value['libelle_prestation'],
                                style: TextStyle(color: Colors.black),
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
                            isExpanded: false,
                            hint: Text('$texte'),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  ),

                  visible ?
                    Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Cout :'),
                            ),
                            Expanded(
                              child: Text('$data4'),
                            ),
                          ],
                        )) : Text(''),

                    visible ?
                    Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Commission :'),
                            ),
                            Expanded(
                              child: Text('$commission'),
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
                                    //widget.counter = widget.counter + 1;
                                     //visible = false ;
                                    _sendDataTransaction();

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

                          new Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              ),
                              color: Color(0xff11b719),
                              onPressed: (){
                                 Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ListTransaction();
                                      },
                                    ),
                                  );

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
  void _sendDataTransaction() async{
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idlavage = localStorage.getString('id_lavage');
      var data = {
        'id_prestation': _mySelection3,
        'dateEnreg': date,
        'id_lavage': idlavage,
        'id_agent': _mySelection,
        'id_client': searchVal,
        'id_commission': id_commission,
        'id_tarification': idTari,
        'id_matricule_vehicule': idmatricule,

      };

      var res = await CallApi().postAppData(data, 'create_transaction');

      if(res.statusCode == 200){

        setState(() {
          _mySelection = null;
          _mySelection3 = null;
          idmatricule = null;
          searchTextField.textField.controller.text = "";
          visible = false ;
        });

        _showMsg("Donnees enregistrees avec succes");

      }else{
        _showMsg("Erreur d'enregistrement des donnees");
      }

    }
  }

  void getTarification() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('getTarification/$_mySelection3/$id');

    var resBody = json.decode(res.body)['data'];

    setState(() {
      idTari = resBody['id'];
      data4 = resBody['montant'];
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


}



