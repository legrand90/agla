import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Commission.dart';
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

class ComptabiliteTabPage extends StatefulWidget {

  final Widget child ;

  ComptabiliteTabPage({Key key, @required this.child}) : super(key: key);

  @override

  _ComptabiliteTabPageTabPageState createState() => _ComptabiliteTabPageTabPageState();
}

class _ComptabiliteTabPageTabPageState extends State<ComptabiliteTabPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _Text = TextEditingController();
  final TextEditingController _date1 = TextEditingController();
  final TextEditingController _date2 = TextEditingController();
  final TextEditingController dateCtl = TextEditingController();
  final TextEditingController dateCtl2 = TextEditingController();

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

  bool loading = true;
  bool loader = true;

  Listagentfromsearch serchValue = Listagentfromsearch();
  ListagentTransaction serchValue2 = ListagentTransaction();
  ListagentNumTrans serchValue3 = ListagentNumTrans();
  var data ;
  List data2 = List() ;

  var recette ;
  var commissions ;
  var tarifications ;

  void getComptabilite() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var res = await CallApi().getData('comptabiliser/$id/$datEnreg1/$datEnreg2');

    var resBody = json.decode(res.body);

    if(resBody['recette'] != 0) {

      setState(() {
        recette = resBody['recette'];
        commissions = resBody['commissions'];
        tarifications = resBody['tarifications'];
        visible = true;
      });

    }else{
      _showMsg('Desole ! Pas de transactions effectuees au-cours de cette periode');
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



  void initDate()async{
    setState(() {
      dateCtl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      dateCtl2.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      mydate1 = DateFormat('dd-MM-yyyy').format(DateTime.now());
      mydate2 = DateFormat('dd-MM-yyyy').format(DateTime.now());
    });
  }


  @override
  void initState(){
    super.initState();
    this.initDate();
    //this.getAgent();
  }

  Widget build(BuildContext context){
    return  Scaffold(
      //height: 300.0,
      key: _scaffoldKey,

      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              LogoRecherche(),
              SizedBox(
                height: 30.2,
              ),


              SizedBox(
                height: 20.2,
              ),

              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                children: <Widget>[
                  Text("DE :"),
                  Expanded(child: Container(
                    // margin: EdgeInsets.only(right: 100.0, left: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: TextFormField(
                      controller: dateCtl,
                      decoration: InputDecoration(
                        labelText: "Selectionner date 1",
                        hintText: "DATE",),
                      onTap: () async{
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = await showDatePicker(
                            context: context,
                            initialDate:DateTime.now(),
                            firstDate:DateTime(1900),
                            lastDate: DateTime(2100));

                        dateCtl.text = DateFormat('yyyy-MM-dd').format(date);
                        mydate1 = DateFormat('dd-MM-yyyy').format(date);

                      },
                    ),
                  ),
                  ),

                  SizedBox(width: 10.0,),
                  Text("A :"),
                  SizedBox(width: 10.0,),

                  Expanded(
                    child: Container(
                      //margin: EdgeInsets.only(right: 100.0, left: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: TextFormField(
                        controller: dateCtl2,
                        decoration: InputDecoration(
                          labelText: "Selectionner date 2",
                          hintText: "DATE",),
                        onTap: () async{
                          DateTime date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate:DateTime.now(),
                              firstDate:DateTime(1900),
                              lastDate: DateTime(2100));

                          dateCtl2.text = DateFormat('yyyy-MM-dd').format(date);
                          mydate2 = DateFormat('dd-MM-yyyy').format(date);
                        },
                      ),
                    )
                    ,),
                  //SizedBox(width: 5.0,),

                ],
              )),

              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
                            visible = false;
                          });
                          await checkDate();
                          setState(() {
                            loader = true;
                          });
                        },
                        child: new Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                child: Text(
                                  "Rechercher",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0
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
              ),

              SizedBox(
                height: 30.2,
              ),

              SizedBox(
                height: 20.2,
              ),


              visible ? Container(
                  height: 150.0,
                  child:

                  Container(
                        child: Card(child: ListTile(
                            title: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('TOTAL PRESTATIONS : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('$tarifications FCFA')),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  children: <Widget>[
                                    Text('TOTAL COMMISSIONS : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('$commissions FCFA'),),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
                                Row(
                                  children: <Widget>[
                                    Text('RECETTE : '),
                                    SizedBox(width: 20.0,),
                                    Text('$recette FCFA'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                //Divider(),
                              ],
                            )
                        ), color: Color(0xff6fb4db),)),
                  ) : Text(''),
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
    getComptabilite();
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

  void checkDate(){
    DateTime d1;
    DateTime d2;
    int differ;
    Duration dur;
    setState(() {
      date1 = dateCtl.text;
      date2 = dateCtl2.text;
    });

    if(date1 != "" && date2 != "") {
      d1 = DateTime.parse(date1);
      d2 = DateTime.parse(date2);
      dur = d2.difference(d1);
      differ = int.parse((dur.inDays / 365).floor().toString());
    }

    if(dateCtl.text == "" || dateCtl2.text == ""){
      print("la date est $date1");
      _showMsg("Renseignez correctement les Dates...Merci !");
    }else if(differ < 0){
      _showMsg("Desole, la Date2 ne peut pas etre inferieur a la Date1...Merci de renseigner correctement ce champ !");
    }else{
      _getSearch();
    }

  }
}


class LogoRecherche extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/Recherche.jpg');
    Image image = Image(image: assetImage, width: 250.0,);

    return Container(child: image,);
  }

}
