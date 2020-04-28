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
import '../login_page.dart';
import 'package:http/http.dart' as http;

class CreditAgent extends StatefulWidget {

  final Widget child ;

  CreditAgent({Key key, @required this.child}) : super(key: key);

  @override

  _CreditAgentState createState() => _CreditAgentState();
}

class _CreditAgentState extends State<CreditAgent> {
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

  Listagentfromsearch serchValue = Listagentfromsearch();
  ListagentTransaction serchValue2 = ListagentTransaction();
  ListagentNumTrans serchValue3 = ListagentNumTrans();
  var data ;
  List data2 = List();

  void AgentFromSearch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('getAgentFromSearch/$id/$_mySelection');
    // final String urlAgent = "http://192.168.43.217:8000/api/getAgentFromSearch/$id/$data";

//    final res = await http.get(Uri.encodeFull(urlAgent), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });
    //var resBody = listclientsearchFromJson(res.body);

    if(res.statusCode == 200) {
      setState(() {
        serchValue = listagentfromsearchFromJson(res.body);
        visible = true;
      });
    }
  }


  void AgenttFromSearchTransa() async {
    var resBody;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    var res2 = await CallApi().getData('getAgentFromSearchTrans/$id/$_mySelection/$datEnreg1/$datEnreg2');

    setState(() {
      serchValue2 = listagentTransactionFromJson(res2.body);
    });

    if(serchValue2.data.length != 0){

      setState(() {

        commi = serchValue2.data[0].totalCommissions ;
        AgentFromSearch();

      });

      //print('resultacomm : ${}');
      //_showMsg("Erreur de  !!!");

    }else{
      _showMsg("Erreur de recuperation des donnees !!!");

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


  @override
  void initState(){
    super.initState();
    this.getAgent();
    //this.getSoldeAgent();
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
              SizedBox(
                height: 30.2,
              ),

              SizedBox(
                height: 20.2,
              ),


              SizedBox(
                height: 30.2,
              ),

              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(width: 5.0,),
                      Expanded(
                          child : DropdownButton(
                            items: data2.map((value) => DropdownMenuItem(
                              child: Text(
                                value['nom'],
                                style: TextStyle(color: Colors.black),
                              ),
                              value: value['id'].toString(),
                            )).toList(),
                            onChanged: (choix)async{
                              setState(() {
                                visible = false;
                                visibleListPaiement = false;
                                _mySelection = choix;
                              });
                              await getSoldeAgent();
                            },
                            value: _mySelection,
                            isExpanded: true,
                            hint: Text('Selectionner l\'agent'),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  )),

              SizedBox(
                height: 20.2,
              ),

              visible ?
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child :
                Row(
                  children: <Widget>[
                    Text('Solde : '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('  $solde FCFA'),)
                  ],
                ),

              ): Text(''),
              SizedBox(height: 20.0,),


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
                    new Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        controller: montant,
                        validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                        // onSaved: (value) => identifiant = value,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Entrez le montant",
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0,),

              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: loading ? FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)
                        ),
                        color: Color(0xff0200F4),
                        onPressed: ()async{
                          setState(() {
                            loading = false;
                          });
                          await _sendDataPaiement();
                          setState(() {
                            loading = true;
                          });
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
                                  "Enregistrer",
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
                      ): Center(child: CircularProgressIndicator(),),
                    )
                  ],
                ),
              ) ,
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
                                    Text('${listpaiement.data [index] .montant} FCFA'),
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

  void _getSearch() async {
    datEnreg1 = mydate1;
    datEnreg2 = mydate2;
    AgenttFromSearchTransa();
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
      var type = "CREDIT";

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
        'fenetre': 'CREDIT',
        'tache': "Credit Agent",
        'execution': "Enregistrer",
        'id_user': id_user,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'type_user': statu,
      };

      if(int.parse(solde) < int.parse(montant.text)) {
        var res = await CallApi().postData(data, 'create_paiement');
        var body = json.decode(res.body)['data'];
        // print('les donnees de l\'Agent: ${body}');

        if (res.statusCode == 200) {
          var res = await CallApi().postData(dataLog, 'create_log');
          var resSolde = await CallApi().postDataEdit(
              dataSolde, 'update_solde/$_mySelection/$id');
          var resTrans = await CallApi().getData(
              'getLast10TansactionPaiementAgent/$id/$_mySelection/$type');

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
        _showMsg("Crédit refusé...Cet agent dispose suffisamment de solde !");
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



