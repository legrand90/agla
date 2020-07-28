import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Cinetpay.dart';
import 'package:lavage/authentification/Models/Commission.dart';
import 'package:lavage/authentification/Models/Paiement.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Models/Transaction.dart';
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

class HistoriqueTrans extends StatefulWidget {

  final Widget child ;

  HistoriqueTrans({Key key, @required this.child}) : super(key: key);

  @override

  _HistoriqueTransState createState() => _HistoriqueTransState();
}

class _HistoriqueTransState extends State<HistoriqueTrans> {
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
  bool chargement = false;
  bool toggle = false;
  bool affiche = false;
  bool load = true;

  int selectedRadio ;

  bool visible = false ;

  bool visibleListPaiement = false ;

  bool loading = true;

  Listtransactions listtransa = Listtransactions();
  ListcinetpayTrans listcynetpay = ListcinetpayTrans();
  var data ;
  List data2 = List();


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

  void getCynetpayTransactions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //final String urlTrans = "http://192.168.43.217:8000/api/Transaction/$id";
    var res = await CallApi().getData('getCinetpayTrans/$id');

    if(res.statusCode == 200){
      var resBody = json.decode(res.body)['data'];
      setState(() {
        listcynetpay = listcinetpayTransFromJson(res.body);
        toggle = true;
        affiche = true;
        chargement = true;
      });
    }
  }


  @override
  void initState(){
    super.initState();
    this.getCynetpayTransactions();
    //this.getSoldeAgent();
  }

  Widget build(BuildContext context){
    return  Scaffold(
      //height: 300.0,
      key: _scaffoldKey,

      backgroundColor: Color(0xFFDADADA),
      body: ListView(
            //shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(height: 40.0,),
                Center(
                  //margin: EdgeInsets.only(left: 20.0,),
                  child: Text("INFOS TRANSACTIONS", style: TextStyle(fontSize: 18.0)),
                ),

                SizedBox(height: 40.0,),

                chargement ? Container(
                    height: 360.0,
                    child:

                    ListView.builder(
                      // shrinkWrap: true,
                      //  physics: ClampingScrollPhysics(),
                      itemCount: (listcynetpay == null || listcynetpay.data == null || listcynetpay.data.length == 0 )? 0 : listcynetpay.data.length,
                      itemBuilder: (_,int index)=>Container(
                          child : Card(child :ListTile(
                            title: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('DATE : '),
                                    SizedBox(width: 20.0,),
                                    Text('${listcynetpay.data [index].dateEnreg}'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('LAVAGE : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('${listcynetpay.data [index].lavage}'),)
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('NUMERO : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('${listcynetpay.data [index].tel}'),)
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('ID TRANSACTION : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('${listcynetpay.data [index].idTransaction}'),)

                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('MOYEN DE PAIEMENT : '),
                                    SizedBox(width: 20.0,),
                                    Text('${listcynetpay.data [index].moyenPaiement}'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('NOMBRE JOUR(S) AVANT : '),
                                    SizedBox(width: 20.0,),
                                    Text('${listcynetpay.data [index].jourAvant} '),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('NOMBRE JOUR(S) APRES : '),
                                    SizedBox(width: 20.0,),
                                    Text('${listcynetpay.data [index].jourApres}'),
                                  ],
                                ),
                                // SizedBox(height: 20.0,),
                                // Divider(color: Colors.white, height: 10.0,),
                              ],
                            ),



//                onTap: (){
////                  Navigator.push(
////                      context,
////                      MaterialPageRoute(
////                        builder: (context) => DetailsPrestation(idpresta: listprestations.data[index].id),
////                      ));
//                },
                          ), color: Color(0xff6fb4db),)
                      ),
                    )) : Center(child: CircularProgressIndicator(),)

              ])

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



