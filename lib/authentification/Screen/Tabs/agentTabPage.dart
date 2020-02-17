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

class AgentTabPage extends StatefulWidget {

  final Widget child ;

  AgentTabPage({Key key, @required this.child}) : super(key: key);

  @override

  _AgentTabPageState createState() => _AgentTabPageState();
}

class _AgentTabPageState extends State<AgentTabPage> {
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

  Listagentfromsearch serchValue = Listagentfromsearch();
  ListagentTransaction serchValue2 = ListagentTransaction();
  ListagentNumTrans serchValue3 = ListagentNumTrans();
  var data ;
  List data2 = List() ;

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

        //visible = true;

      });
    }else{
      _showMsg("Erreur de recuperation des donnees !!!");

    }
    AgenttFromSearchTransa();

    //print('resulta : ${serchValue2.data.length}');

  }


  void AgenttFromSearchTransa() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    var res = await CallApi().getData('getAgentFromSearchTrans/$id/$_mySelection/$datEnreg1/$datEnreg2');
   // final String urlTrans = "http://192.168.43.217:8000/api/getAgentFromSearchTrans/$id/${serchValue.data.id}/$datEnreg1/$datEnreg2";
//    final res2 = await http.get(Uri.encodeFull(urlTrans), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    print(res.body);



    setState((){

      serchValue2 = listagentTransactionFromJson(res.body);

      commi = (serchValue2.data[0].totalCommissions != null) ? serchValue2.data[0].totalCommissions : 0;



    });

    if (res.statusCode == 200 && commi != 0) {

      setState(() {
        visible = true;
      });

    //print('resultacomm : ${serchValue2.data[0].totalCommissions}');

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

   // print('id est $_mySelection');

    return "success" ;

  }


  @override
  void initState(){
    super.initState();
    this.getAgent();
  }

  Widget build(BuildContext context){
    return  Scaffold(
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
              Row(
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
                  SizedBox(width: 10.0,),
                ],
              ),

              SizedBox(
                height: 20.2,
              ),

              Row(
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
                        onChanged: (choix){
                          setState(() {
                            _mySelection = choix ;
                          });
                          checkDate();
                        },
                        value: _mySelection,
                        isExpanded: false,
                        hint: Text('Selectionner l\'agent'),
                        style: TextStyle(color: Color(0xff11b719)),
                      ))
                ],

              ),

              SizedBox(
                height: 30.2,
              ),

              SizedBox(
                height: 20.2,
              ),

              visible ?
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child :
                Row(
                  children: <Widget>[
                    Text('NOM : '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('  ${serchValue.data.nom}'),)
                  ],
                ),

              ): Text(''),
              SizedBox(height: 20.0,),
              visible?
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child :
                Row(
                  children: <Widget>[
                    Text('CONTACT : '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('  ${serchValue.data.contact}'),)
                  ],
                ),

              ): Text(''),

              SizedBox(height: 20.0,),
              visible?
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child :
                Row(
                  children: <Widget>[
                    Text('CONTACT D\'URGENCE: '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('  ${serchValue.data.contactUrgence}'),)
                  ],
                ),

              ): Text(''),

              SizedBox(height: 20.0,),
              visible?
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child :
                Row(
                  children: <Widget>[
                    Text('QUARTIER : '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('  ${serchValue.data.quartier}'),)
                  ],
                ),

              ): Text(''),

              SizedBox(height: 20.0,),
              visible?
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child :
                Row(
                  children: <Widget>[
                    Text('NOMBRE DE PRESTATIONS : '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('  ${serchValue2.data.length}'),)
                  ],
                ),

              ): Text(''),
              SizedBox(height: 20.0,),
              visible?
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child :
                Row(
                  children: <Widget>[
                    Text('COMMISSIONS: '),
                   // SizedBox(width: 20.0,),
                    Text('  $commi Fcfa'),
                  ],
                ),

              ): Text(''),
              SizedBox(height: 20.0,),
              visible?  Divider() : Text(''),
              visible?
              ListView.builder(
                shrinkWrap: true,
                itemCount: (serchValue2 == null || serchValue2.data == null || serchValue2.data.length == 0 )? 0 : serchValue2.data.length,
                itemBuilder: (_,int index)=>ListTile(
                    title: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('DATE : '),
                            SizedBox(width: 20.0,),
                            Text('${serchValue2.data [index] .dateEnreg}'),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            Text('${serchValue2.data [index] .idPrestation}'),
                            SizedBox(width: 20.0,),
                            Text('${serchValue2.data [index] .idTarification} Fcfa'),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            Text('${serchValue2.data [index] .idAgent}'),
                            SizedBox(width: 20.0,),
                            Text('${serchValue2.data [index] .idCommission} Fcfa'),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            Text('PLAQUE D\'IMMATRICULATION'),
                            SizedBox(width: 20.0,),
                            Text('${serchValue2.data [index] .idMatricule}'),
                          ],
                        ),
                        SizedBox(height: 20.0,),
                        Divider(),
                      ],
                    )
                ),
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
        AgentFromSearch();
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



