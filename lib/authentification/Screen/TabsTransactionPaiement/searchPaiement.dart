import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class SearchPaiement extends StatefulWidget {

  final Widget child ;

  SearchPaiement({Key key, @required this.child}) : super(key: key);

  @override

  _SearchPaiementState createState() => _SearchPaiementState();
}

class _SearchPaiementState extends State<SearchPaiement> {
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

  bool visible2 = false;

  bool visible3 = false;

  bool _checkBoxVal = false ;

  bool loading = true;

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
        visible = true;
      });


    }


  }

  Listpaiement listpaiement = Listpaiement();


  void AgenttFromSearchPaiement() async {
    var resBody;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    var res2 = await CallApi().getData('getTansactionPaiementAgentByAccordingPeriod/$id/$_mySelection/$datEnreg1/$datEnreg2');
    // final String urlTrans = "http://192.168.43.217:8000/api/getAgentFromSearchTrans/$id/${serchValue.data.id}/$datEnreg1/$datEnreg2";
//    final res2 = await http.get(Uri.encodeFull(urlTrans), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    setState(() {
      listpaiement = listpaiementFromJson(res2.body);
      visible3 = true;
    });


    if(listpaiement.data.length == 0){

      _showMsg("Erreur de recuperation des donnees !!!");

    }

  }

  void AgenttFromSearchPaiementAll() async {
    var resBody;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    var res2 = await CallApi().getData('getTansactionPaiementAgentByAccordingPeriodAll/$id/$datEnreg1/$datEnreg2');
    // final String urlTrans = "http://192.168.43.217:8000/api/getAgentFromSearchTrans/$id/${serchValue.data.id}/$datEnreg1/$datEnreg2";
//    final res2 = await http.get(Uri.encodeFull(urlTrans), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    setState(() {
      listpaiement = listpaiementFromJson(res2.body);
      visible3 = true;
    });


    if(listpaiement.data.length == 0){

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
    this.getAgent();
    selectedRadio = 0;
  }

  Widget build(BuildContext context){
    return  Scaffold(
      //height: 300.0,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("INFOS PAIEMENT"),
      ),

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
                height: 30.2,
              ),

              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[

                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    // title: Text("Nom"),
                    activeColor: Colors.black,
                    onChanged: (val){
                      setSelectRadio(val);
                      setState(() {
                        visible = false ;
                        visible2 = true ;
                        visible3 = false ;
                      });
                      //visible = false ;
                    },
                  ),

                  Text("Selon l'Agent"),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    // title: Text("Matri"),
                    activeColor: Colors.black,
                    onChanged: (val){
                      setSelectRadio(val);
                      setState(() {
                        visible = false;
                        visible2 = false;
                        visible3 = false ;
                      });
                    },
                  ),

                  Text("Tout"),

                ],
              ),

              visible2 ? Container(
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
                                _mySelection = choix;
                              });
                              //await checkDate();
                            },
                            value: _mySelection,
                            isExpanded: true,
                            hint: Text('Selectionner l\'agent'),
                            style: TextStyle(color: Color(0xff11b719)),
                          ))
                    ],

                  )
              ) : Text(""),

              Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(left: 60.0, right: 60.0),
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
                           await checkDate();
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
                                  "Lancer",
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
              ),

              SizedBox(
                height: 20.2,
              ),

              visible?  Divider() : Text(''),
              visible3 ? Container(
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
                                    Text('TYPE TRANSACTION'),
                                    SizedBox(width: 20.0,),
                                    Text('${listpaiement.data[index].typeTransaction}'),
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
                                    Text('AGENT'),
                                    SizedBox(width: 20.0,),
                                    Text('${listpaiement.data [index] .idAgent}'),
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
                                    Text('${listpaiement.data [index] .nouveauSolde} FCFA '),
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
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there is't enough vertical
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
                  color: Color(0xff0200F4),
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
                title: Text('Tutoriel'),
                onTap: () async{

                },
              ),
              ListTile(
                title: Text('A propos'),
                onTap: () async{

                },
              ),
              ListTile(
                title: Text('Deconnexion'),
                onTap: () {
                  _alertDeconnexion();
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
        )
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
    if (selectedRadio == 1) {
      datEnreg1 = mydate1;
      datEnreg2 = mydate2;
      AgenttFromSearchPaiement();
    } else if (selectedRadio == 2) {
      datEnreg1 = mydate1;
      datEnreg2 = mydate2;
      AgenttFromSearchPaiementAll();
    }
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

  void checkDate() async{
    DateTime d1;
    DateTime d2;
    int differ;
    Duration dur;
    setState(() {
      date1 = dateCtl.text;
      date2 = dateCtl2.text;
    });

    if (date1 != "" && date2 != "") {
      d1 = DateTime.parse(date1);
      d2 = DateTime.parse(date2);
      dur = d2.difference(d1);
      differ = int.parse((dur.inDays / 365).floor().toString());
    }

    if (dateCtl.text == "" || dateCtl2.text == "") {
      print("la date est $date1");
      _showMsg("Renseignez correctement les Dates...Merci !");
    } else if (differ < 0) {
      _showMsg(
          "Desole, la Date2 ne peut pas etre inferieur a la Date1...Merci de renseigner correctement ce champ !");
    } else {
      _getSearch();
    }
  }
    var nameUser;
    var isadmin;

    void getUserName() async{
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userName = localStorage.getString('nom');

      setState(() {
        nameUser = userName;
        isadmin = localStorage.getString('Admin');
      });

      print('la valeur de admin est : $isadmin');

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
      const url = 'https://maxom.ci';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

  }






