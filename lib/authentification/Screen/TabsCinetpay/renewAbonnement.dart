import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Commission.dart';
import 'package:lavage/authentification/Models/Paiement.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Models/listagentNum.dart';
import 'package:lavage/authentification/Models/searchAgent.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsCommission.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/Listes/listsearchagent.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../cinetpayPage.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class Abonnement extends StatefulWidget {

  final Widget child ;

  Abonnement({Key key, @required this.child}) : super(key: key);

  @override

  _AbonnementState createState() => _AbonnementState();
}

class _AbonnementState extends State<Abonnement> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController montant = TextEditingController();
  final TextEditingController _date1 = TextEditingController();
  final TextEditingController _date2 = TextEditingController();
  final TextEditingController dateCtl = TextEditingController();
  final TextEditingController dateCtl2 = TextEditingController();

  String dateHeure = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  var datEnreg1 ;
  var datEnreg2 ;
  var mydate1;
  var mydate2;
  var date1 ;
  var date2 ;
  var commi;
  var _mySelection;


  int selectedRadio ;

  bool visible = false ;

  bool visibleListPaiement = false ;

  bool loading = true;

  Timer timer ;

  Listagentfromsearch serchValue = Listagentfromsearch();
  ListagentTransaction serchValue2 = ListagentTransaction();
  ListagentNumTrans serchValue3 = ListagentNumTrans();
  var data ;
  List data2 = List();
  var EndPeriod;
  var JourRestant;
  var montantService;

  void getEndPeriod() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('getJourRestant/$id');
    var res2 = await CallApi().getData('getServiceMontant');
    var resBody = json.decode(res.body);
    var resBody2 = json.decode(res2.body);


    if(resBody['success']) {
      setState(() {
        EndPeriod = resBody['dateFinAbon'];
        montantService = resBody2['montant'];
        visible = true;
        JourRestant = resBody['nbjour'];
      });
    }
  }

  setSelectRadio(int valeur){

    setState(() {
      selectedRadio = valeur;
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

  Future<String> getAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('agent/$id');
    //final String urlAgent = "http://192.168.43.217:8000/api/agent/$id";

    //final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];


    setState(() {
      data2 = resBody;
      //_mySelection = resBody[0]['id'];
    });

    return "success";

  }

  var solde;

  Future<String> getSoldeAgent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('getAgentSolde/$_mySelection/$id');
    //final String urlAgent = "http://192.168.43.217:8000/api/agent/$id";

    //final res = await http.get(Uri.encodeFull(urlAgent), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body);


    setState(() {
      solde = resBody['montant'];
      //_mySelection = resBody[0]['id'];
      visible = true;
    });

    //print('sole $solde');

    return "success" ;
  }

  Future<bool> _alert(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Vous serez débité de $montantService FCFA. Cliquez sur Oui pour effectuer votre paiement !"),
            actions: <Widget>[
              FlatButton(
                child: Text("Non"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("Oui"),
                onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CinetpayPage();
                    },
                  ),
                ),
              )
            ]
        )
    );
  }


  @override
  void initState(){
    super.initState();
    this.getEndPeriod();
    this.getStatut();
    //this.getSoldeAgent();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getEndPeriod());
  }

  Widget build(BuildContext context){
    return  Scaffold(
      //height: 300.0,
      key: _scaffoldKey,

      backgroundColor: Color(0xFFDADADA),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 80.0,),
              Container(
                margin: EdgeInsets.only(left: 20.0,),
                child: Text("FIN ABONNEMENT : $EndPeriod", style: TextStyle(fontSize: 18.0)),
              ),

              SizedBox(height: 40.0,),
              Container(
                margin: EdgeInsets.only(left: 15.0,),
                child: Text("NOBRE DE JOURS RESTANTS : $JourRestant", style: TextStyle(fontSize: 18.0)),
              ),

              SizedBox(height: 80.0,),

              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                        ),
                        color: Color(0xff003372),
                        onPressed: ()async{

                          await _alert();

                        },
                        child: new Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 14.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "Payer",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),)

                    )
                  ],
                ),
              ),
              visible?  Divider() : Text(''),
              SizedBox(height: 10.0,),
              visibleListPaiement? Container(child: Center(
                child: Text("5 dernières transactions ", style: TextStyle(fontSize: 20.0),),
              ),) : Text(''),
              SizedBox(height: 10.0,),
              visibleListPaiement? Container(
                  height: 300.0,
                  child:

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: (listpaiement == null || listpaiement.data == null || listpaiement.data.length == 0 )? 0 : listpaiement.data.length,
                    itemBuilder: (_,int index)=>Container(
                        child: Card(child: ListTile(
                            title: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('DATE : '),
                                    SizedBox(width: 20.0,),
                                    Text('${listpaiement.data [index] .dateEnreg}'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('TYPE DE TRANSACTION'),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('${listpaiement.data [index].typeTransaction}'),)

                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('MONTANT'),
                                    SizedBox(width: 20.0,),
                                    Text('${listpaiement.data [index] .montant} Fcfa'),
                                  ],
                                ),

                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('ANCIEN SOLDE'),
                                    SizedBox(width: 20.0,),
                                    Text('${listpaiement.data [index] .ancienSolde} FCFA'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('NOUVEAU SOLDE'),
                                    SizedBox(width: 20.0,),
                                    Text('${listpaiement.data [index] .nouveauSolde} FCFA'),
                                  ],
                                ),

                                SizedBox(height: 20.0,),
                                //Divider(),
                              ],
                            )
                        ), color: Color(0xff11b719),)),
                  )) : Text(''),
            ],
          )
      ),
    );
  }

  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }


  void _logout() async{
    var res = await CallApi().getData('logout');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('token');
      localStorage.remove('user');
      await Navigator.push(context,
          new MaterialPageRoute(
              builder: (BuildContext context){
                return new LoginPage();
              }
          ));
    }

  }

  Listpaiement listpaiement = Listpaiement();

  void _sendDataPaiement() async{

    if(validateAndSave()) {
      var type = "PAIEMENT";

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      var id_user = localStorage.getInt('ID');
      print('val $dateHeure');
      var data = {
        'type_transaction': type,
        'ancien_solde': solde,
        'nouveau_solde': int.parse(solde) - int.parse(montant.text),
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'id_agent': _mySelection,
        'id_user': id_user,
        'montant': montant.text,
      };

      var dataSolde = {
        'montant': int.parse(solde) - int.parse(montant.text),
      };

      var dataLog = {
        'fenetre': 'PAIEMENT',
        'tache': "Paiement Agent",
        'execution': "Enregistrer",
        'id_user': id_user,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'type_user': statu,
      };

      if(int.parse(solde) >= int.parse(montant.text)) {
        var res = await CallApi().postData(data, 'create_paiement');
        var body = json.decode(res.body)['data'];
        // print('les donnees de l\'Agent: ${body}');

        if (res.statusCode == 200) {
          var res = await CallApi().postData(dataLog, 'create_log');
          var resSolde = await CallApi().postDataEdit(dataSolde, 'update_solde/$_mySelection/$id');
          var resTrans = await CallApi().getData('getLast10TansactionPaiementAgent/$id/$_mySelection/$type');

          await getSoldeAgent();

          setState(() {
            //solde = int.parse(solde) - int.parse(montant.text);
            listpaiement = listpaiementFromJson(resTrans.body);
            montant.text = '';
            visibleListPaiement = true;

          });

          _showMsg("Donnees enregistrees avec succes");
        } else {
          _showMsg("Erreur d'enregistrement");
        }
      }else{
        _showMsg("Désolé...Cet agent ne dispose pas de solde ou a un solde insuffisant !");
      }
    }
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


}



