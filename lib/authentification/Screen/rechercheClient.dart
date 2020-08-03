import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Commission.dart';
import 'package:lavage/authentification/Models/Matriculesearch.dart';
import 'package:lavage/authentification/Models/Numerosearch.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Models/searchclient.dart';
import 'package:lavage/authentification/Models/searchclientTrans.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsCommission.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:lavage/authentification/Screen/tutoriel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'dashbord.dart';
import 'historique.dart';
import 'login_page.dart';

class RechercheClient extends StatefulWidget {

  final Widget child ;

  RechercheClient({Key key, @required this.child}) : super(key: key);

  @override
  _RechercheClientState createState() => _RechercheClientState();
}

class _RechercheClientState extends State<RechercheClient> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _Text = TextEditingController();
  final TextEditingController _date1 = TextEditingController();
  final TextEditingController _date2 = TextEditingController();
  final TextEditingController dateCtl = TextEditingController();
  final TextEditingController dateCtl2 = TextEditingController();

  int selectedRadio ;
  Listclientsearch serchValue = Listclientsearch();
  ListclientsearchTrans serchValue2 = ListclientsearchTrans();
  Listclientmatriculesearch serchValue3 = Listclientmatriculesearch();
  Listclientnumerosearch serchValue4 = Listclientnumerosearch();
  var data ;
  var date1 ;
  var date2 ;
  var datEnreg1 ;
  var datEnreg2 ;
  var mydate1;
  var mydate2;
  bool visible = false;
  bool load = true;

  void ClientFromSearch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    // final String urlClient = "http://192.168.43.217:8000/api/getClientFromSearch/$id/$data";

    var res = await CallApi().getData('getClientFromSearch/$id/$data');

//    final res = await http.get(Uri.encodeFull(urlClient), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });
    //var resBody = listclientsearchFromJson(res.body);

    if(res.statusCode == 200) {
      setState(() {
        serchValue = listclientsearchFromJson(res.body);

        //visible = true;

      });

      ClientFromSearchTransa();
    }else{
      _showMsg("Erreur de recuperation des donnees !!!");
    }
    //print('resulta : ${serchValue2.data.length}');

  }

  void ClientFromSearchTransa() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    //final String urlTrans = "http://192.168.43.217:8000/api/getClientFromSearchTrans/$id/${serchValue.data.id}/$datEnreg1/$datEnreg2";

    var res2 = await CallApi().getData('getClientFromSearchTrans/$id/${serchValue.data.id}/$datEnreg1/$datEnreg2');
//    final res2 = await http.get(Uri.encodeFull(urlTrans), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    if(res2.statusCode == 200) {
      setState(() {
        serchValue2 = listclientsearchTransFromJson(res2.body);

        visible = true;
      });
    }else{
      _showMsg("Erreur de recuperation des donnees !!!");
    }
    // print('resulta : ${serchValue2.data.length}');

  }


  void MatriculeClientFromSearch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    //final String urlMatri = "http://192.168.43.217:8000/api/getClientMatricule/$id/$data";

    var res2 = await CallApi().getData('getClientMatricule/$id/$data');
//    final res2 = await http.get(Uri.encodeFull(urlMatri), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    if(res2.statusCode == 200) {
      setState(() {
        serchValue3 = listclientmatriculesearchFromJson(res2.body);

        //visible = true;

      });

      //final String urlClient = "http://192.168.43.217:8000/api/getClientFromSearch/$id/${serchValue3.data.nomClient}";
      var res = await CallApi().getData(
          'getClientFromSearch/$id/${serchValue3.data.nomClient}');
//    final res = await http.get(Uri.encodeFull(urlClient), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

      setState(() {
        serchValue = listclientsearchFromJson(res.body);

        //visible = true;

      });
    }else{
      _showMsg("Erreur de recuperation des donnees !!!");

    }

    MatriculeClientTransaFromSearch();

    //print('resulta : ${serchValue3}');

  }

  void MatriculeClientTransaFromSearch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    //final String urlMatri = "http://192.168.43.217:8000/api/getClientFromSearchTrans/$id/${serchValue3.data.idClient}/$datEnreg1/$datEnreg2";
    var res2 = await CallApi().getData('getClientFromSearchTransMatricule/$id/${serchValue3.data.idClient}/${serchValue3.data.id}/$datEnreg1/$datEnreg2');
//    final res2 = await http.get(Uri.encodeFull(urlMatri), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    if(res2.statusCode == 200) {
      setState(() {
        serchValue2 = listclientsearchTransFromJson(res2.body);

        visible = true;
      });
    }else{
      _showMsg("Erreur de recuperation des donnees !!!");

    }
    //print('resulta : ${serchValue2}');

  }


  void NumeroClientFromSearch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //  final String urlNum = "http://192.168.43.217:8000/api/getNumeroClientFromSearch/$id/$data";

    var res = await CallApi().getData('getNumeroClientFromSearch/$id/$data');
//    final res = await http.get(Uri.encodeFull(urlNum), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });
    //var resBody = listclientsearchFromJson(res.body);

    if(res.statusCode == 200) {
      setState(() {
        serchValue4 = listclientnumerosearchFromJson(res.body);

        //visible = true;

      });

      //final String urlClient = "http://192.168.43.217:8000/api/getClientFromSearch/$id/${serchValue4.data.nom}";
      var res2 = await CallApi().getData(
          'getClientFromSearch/$id/${serchValue4.data.nom}');
//    final res2 = await http.get(Uri.encodeFull(urlClient), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

      setState(() {
        serchValue = listclientsearchFromJson(res2.body);

        //visible = true;

      });
    }else{
      _showMsg("Erreur de recuperation des donnees !!!");

    }

    NumeroClientTransaFromSearch();

    //  print('resulta : ${serchValue2}');

  }


  void NumeroClientTransaFromSearch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //var resBody = listclientsearchFromJson(res.body);
    //final String urlClient = "http://192.168.43.217:8000/api/getClientFromSearchTrans/$id/${serchValue4.data.id}/$datEnreg1/$datEnreg2";
    var res2 = await CallApi().getData('getClientFromSearchTrans/$id/${serchValue4.data.id}/$datEnreg1/$datEnreg2');
//    final res2 = await http.get(Uri.encodeFull(urlClient), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    if(res2.statusCode == 200) {
      setState(() {
        serchValue2 = listclientsearchTransFromJson(res2.body);

        visible = true;
      });

      // print('resulta : ${serchValue2}');
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
  _showMsg(msg){
    final snackBar = SnackBar(
        content: Text(msg),
        action : SnackBarAction(
          label: 'Fermer',
          onPressed: (){

          },
        )
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState(){
    super.initState();
    this.getUserName();
    this.getStatut();
    selectedRadio = 0;
  }

  Widget build(BuildContext context){
    return  Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('RECHERCHE'),
      ),
      backgroundColor: Colors.white,
      body: load ? Form(
          key: _formKey,
          //  autovalidate: _autoValidate,
          child: ListView(
            children: <Widget>[
              LogoRecherche(),
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
                        _Text.text = "";
                        dateCtl.text = "";
                        dateCtl2.text = "";
                      });
                      //visible = false ;
                    },
                  ),

                  Text("Nom"),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    // title: Text("Matri"),
                    activeColor: Colors.black,
                    onChanged: (val){
                      setSelectRadio(val);
                      setState(() {
                        visible = false ;
                        _Text.text = "";
                        dateCtl.text = "";
                        dateCtl2.text = "";
                      });
                    },
                  ),

                  Text("Matri"),

                  Radio(
                    value: 3,
                    groupValue: selectedRadio,
                    // title: Text("Tel"),
                    activeColor: Colors.black,
                    onChanged: (val){
                      setSelectRadio(val);
                      setState(() {
                        visible = false ;
                        _Text.text = "";
                        dateCtl.text = "";
                        dateCtl2.text = "";
                      });
                    },
                  ),
                  Text("Tel"),
                ],
              ),
              SizedBox(
                height: 30.2,
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

                          //var date2 = DateFormat('dd-MM-yyyy').format(date.day+1).toString();
                          //mydate2.Jiffy().add(days: 1);
                        },

                      ),
                    )
                    ,),
                  SizedBox(width: 10.0,),
                ],
              ),


//            SizedBox(
//              height: 15.2,
//            ),


              SizedBox(
                height: 30.2,
              ),

              Container(
                child: Center(
                  child: Text('INFORMATIONS CLIENT'),
                ),
              ),

              Container(
                child:  Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    children: <Widget>[

                      new Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          //autofocus: false,
                          controller: _Text,
                          //  validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                          // onSaved: (value) => nomPrestation = value,
                          decoration: InputDecoration(
                            //border: InputBorder,
                            hintText: "Saisir votre recherche",
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){
                          checkDate();
                          //_getSearch();
                          // _Text.text = "";
                        },
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(
                height: 20.2,
              ),

              visible ? //Center(child: ,),
              Container(
                margin: EdgeInsets.only(left: 15.0,),
                child :
                Row(
                  children: <Widget>[
                    Text('NOM : '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('${serchValue.data.nom}'),)

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
                    Expanded(child: Text('${serchValue.data.contact}'),)
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
                    Text('EMAIL : '),
                    //SizedBox(width: 20.0,),
                    Expanded(child: Text('${serchValue.data.email}'),)
                  ],
                ),

              ): Text(''),

              SizedBox(height: 20.0,),
              visible?  Divider() : Text(''),
              visible? Container(
                  height: 300,
                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: (serchValue2 == null || serchValue2.data == null || serchValue2.data.length == 0 )? 0 : serchValue2.data.length,
                    itemBuilder: (_,int index)=>Container(
                        child:Card(child:ListTile(
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
                                    Text('${serchValue2.data [index] .idTarification}'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('${serchValue2.data [index] .idAgent}'),
                                    SizedBox(width: 20.0,),
                                    Text('${serchValue2.data [index] .idCommission}'),
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
                                //Divider(),
                              ],
                            )

//                onTap: (){
////                  Navigator.push(
////                      context,
////                      MaterialPageRoute(
////                        builder: (context) => DetailsPrestation(idpresta: listprestations.data[index].id),
////                      ));
//                },
                        ), color: Color(0xff6fb4db),)),
                  )) : Text(''),
            ],
          )
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
              title: Text('Nouvelle Entree'),
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
              title: Text('Parametre'),
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
                //await _alertDeconnexion();

                setState(() {
                  load = true;
                });
              },
            ),
            ListTile(
              title: Text('Deconnexion'),
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

                      _launchMaxomURL();
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

  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

//  void checkDate(){
//
//    date1 = DateFormat('dd-MM-yyyy').format(datEnreg1);
//  }

  void _getSearch() async {

    if (validateAndSave()) {
      if (selectedRadio == 1) {
        data = _Text.text;
        datEnreg1 = mydate1;
        datEnreg2 = mydate2;
        ClientFromSearch();
      } else if (selectedRadio == 2) {
        data = _Text.text;
        datEnreg1 = mydate1;
        datEnreg2 = mydate2;
        MatriculeClientFromSearch();
      } else if (selectedRadio == 3) {
        data = _Text.text;
        datEnreg1 = mydate1;
        datEnreg2 = mydate2;
        NumeroClientFromSearch();
      }

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
    const url = 'https://maxom.ci';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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

