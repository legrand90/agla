import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
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
import 'Tabs/clientPage.dart';
import 'client.dart';


class Transac extends StatefulWidget {

  int counter = 0 ;

  Transac({Key key, @required this.counter}) : super(key: key);

  @override
  _TransacState createState() => new _TransacState(counter);
}

class _TransacState extends State<Transac> {

  AutoCompleteTextField searchTextField;
  GlobalKey <AutoCompleteTextFieldState<Datu>> key = GlobalKey();

  String param ;

  int counter = 0 ;

  _TransacState(this.counter);

  var texte = 'Selectionner prestation' ;

  var val ;

  bool loading = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _gainAgent = TextEditingController();
  //final TextEditingController _password = TextEditingController();

  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  String gainAgent;

  final String urlAgent = "http://192.168.43.217:8000/api/agent";



  final String urlTarification = "http://192.168.43.217:8000/api/getLastTarification";



  Listclients listclient = Listclients();
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
    final String urlAgent = "http://192.168.43.217:8000/api/agent/$id";
    final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
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
    final String urlClient = "http://192.168.43.217:8000/api/client/$id";
    // final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
    final res2 = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
    //var resBody = json.decode(res.body)['data'];

    if(res2.statusCode == 200){

      listclient = listclientsFromJson(res2.body);

      setState(() {
        loading = false ;
        // data = resBody;
      });
    }

    print('AGENTS : ${res2.body}');

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
    final String urlPrestation = "http://192.168.43.217:8000/api/prestation/$id";
    final res = await http.get(Uri.encodeFull(urlPrestation), headers: {
      "Accept": "application/json",
      "Content-type": "application/json",
    });
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
    final String urlClient = "http://192.168.43.217:8000/api/client/$id";
    final res = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
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


  Widget createListClient(){

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
   // return widgets ;
  }

  @override
  void initState(){
    super.initState();
    this.getAgent();
    this.getClients();
    this.getClient();
    //this.getLastTarification();
    this.getPrestation();
    //this.getTarification();

    //this.getLastCommission();

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
          title: Text('TRANSACTIONS')
      ),
      body:  ListView.builder(
        itemCount: (listclient == null || listclient.data == null || listclient.data.length == 0 )? 0 : listclient.data.length,
        itemBuilder: (_,int index)=>ListTile(
          title: Row(
            children: <Widget>[
              Text(listclient.data[index].nom),
              SizedBox(width: 20.0,),
              Text(listclient.data[index].id.toString()),
              SizedBox(width: 20.0,),
              Text(listclient.data[index].email),
            ],
          ),
          onTap: (){
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => DetailsPrestation(idpresta: listprestations.data[index].id),
//                    ));
          },
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
              accountName: Text('Legrand Koffi'),
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
                      return Transac();
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
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
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
              title: Text('Rapport'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('A propos'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Deconnexion'),
              onTap: () {
                //_logout();
              },
            )
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

      };


      var res = await CallApi().postAppData(data, 'create_transaction');
      if(res.statusCode == 200){
        //var body = json.decode(res.body)['data'];
        _showMsg("Donnees enregistrees avec succes");

      }else{
        _showMsg("Erreur d'enregistrement des donnees");
      }

    }
  }

  void getTarification() async {

    // this.param = _mySelection3;

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    final String urlTari = "http://192.168.43.217:8000/api/getTarification/$_mySelection3/$id"  ;

//    setState(() {
//      param = _mySelection3;
//    });

    //var chaine = param + urlTari ;

    final res = await http.get(Uri.encodeFull(urlTari), headers: {
      "Accept": "application/json",
      "Content-type": "application/json",
    });
    var resBody = json.decode(res.body)['data'];

    setState(() {
      idTari = resBody['id'];
      data4 = resBody['montant'];
    });

    getCommission();



    print('identi est $idTari');

  }

  void getCommission() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    final String urlCommission = "http://192.168.43.217:8000/api/getCommission/$idTari/$_mySelection/$id";
    final res = await http.get(Uri.encodeFull(urlCommission), headers: {"Accept": "application/json","Content-type" : "application/json",});

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

      setState(() {
        visible = false;
        _mySelection3 = null;
        commission = '' ;
        data4 = '' ;
      });

      _showMsg("L' Agent que vous avez selectionner n'a pas de commission pour cette prestation");
    }




  }


}



