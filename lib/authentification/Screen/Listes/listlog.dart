import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:json_table/json_table.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Logs.dart';
import 'package:lavage/authentification/Models/Listlavages.dart';
import 'package:lavage/authentification/Models/Transaction.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Transaction.dart';
import '../dashbord.dart';
import '../historique.dart';
import '../login_page.dart';
import '../register.dart';

class ListLogs extends StatefulWidget {
  @override
  _ListLogsState createState() => _ListLogsState();
}

class _ListLogsState extends State<ListLogs> {

  var json2 ;
  bool toggle = false;
  var affiche = false;
  bool load = true;
  bool chargement = false;
  var searchVal ;

  Listlogs logs = Listlogs();

  AutoCompleteTextField searchTextField;
  GlobalKey <AutoCompleteTextFieldState<Datux>> keys = GlobalKey();

  final TextEditingController dateCtl = TextEditingController();
  final TextEditingController dateCtl2 = TextEditingController();

  var datEnreg1 ;
  var datEnreg2 ;
  var mydate1;
  var mydate2;
  var date1 ;
  var date2 ;
  bool loading = true;

  static List <Datux> listlavages = List <Datux>()  ;

  static List <Datux> loadLavages(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datux>((json)=>Datux.fromJson(json)).toList();
  }

  void getLavages() async {

    var res = await CallApi().getData('getLavageOrderByName');

    if(res.statusCode == 200){

      listlavages = loadLavages(res.body);

      setState(() {
        loading  = false ;
      });

      print('les lavages $listlavages');

    }else{
      _showMsg('Liste vide');
    }

  }

  void getLogs() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    //final String urlTrans = "http://192.168.43.217:8000/api/Transaction/$id";
    var res = await CallApi().getData('Log');


    if(res.statusCode == 200){

      var resBody = json.decode(res.body)['data'];

      setState(() {
        logs = listlogsFromJson(res.body);
        toggle = true;
        affiche = true;
        chargement = true;

      });
    }


    //print('donnees json : ${logs.data.length}');

  }

  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  var recette;
  var commissions;
  var totalTarif;

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

  Widget row(Datux ag){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(ag.libelleLavage, style: TextStyle(fontSize: 20.0),)
      ],
    );
  }

  @override
  void initState(){
    super.initState();
    this.getUserName();
    this.getLogs();
    this.getStatut();
    this.getLavages();
  }
  Widget build(BuildContext context){
    var json = json2;

    //SystemChrome.setPreferredOrientations([
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight
    //]);

    return Scaffold(
      key: _scaffoldKey,
      //ackgroundColor: Color(0xFFDADADA),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                pinned: true,
                title: new Text('LOGS'),
              ),
            ];
          },
          body: ListView(
            //shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(height: 40.0,),
                Container(
                  margin: EdgeInsets.only(left: 20.0,),
                  child: Text("LISTE DES LOGS", style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
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

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: loading ? Center(child: CircularProgressIndicator()) : searchTextField = AutoCompleteTextField<Datux>(
                            key: keys,
                            clearOnSubmit: false,
                            suggestions: listlavages,
                            style: TextStyle(color: Colors.black, fontSize: 16.0),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
                                hintText: "Saisir le lavage",
                                hintStyle: TextStyle(color: Colors.black)
                            ),
                            itemFilter: (item, query){
                              return item.libelleLavage.toLowerCase().startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b){
                              return a.libelleLavage.compareTo(b.libelleLavage);
                            },
                            itemSubmitted: (item){
                              setState(() {
                                searchTextField.textField.controller.text = item.libelleLavage;
                                searchVal = item.id ;
                              });
                            },
                            itemBuilder: (context, item){
                              return row(item);
                            },

                          ),


                        ),


                      ],
                    )
                ),

                SizedBox(height: 20.0,),

                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)
                          ),
                          color: Color(0xff003372),
                          onPressed: ()async{

                            setState(() {
                              chargement = false;
                            });

                            await checkDate();

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
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 40.0,),

                Container(
                    height: 450.0,
                    child:

                    chargement ? ListView.builder(
                      // shrinkWrap: true,
                      //  physics: ClampingScrollPhysics(),
                      itemCount: (logs == null || logs.data == null || logs.data.length == 0 )? 0 : logs.data.length,
                      itemBuilder: (_,int index)=>Container(
                          child : Card(child :ListTile(
                            title: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('DATE : '),
                                    SizedBox(width: 20.0,),
                                    Text('${logs.data [index].dateEnreg}'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('FENETRE : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('${logs.data [index].fenetre}'),),

                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('TACHE : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('${logs.data [index].tache}'),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('EXECUTION : '),
                                    SizedBox(width: 20.0,),
                                    Text('${logs.data [index].execution}'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('NOM : '),
                                    SizedBox(width: 20.0,),
                                    Text('${logs.data [index].idUser}'),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('TYPE USER : '),
                                    SizedBox(width: 20.0,),
                                    Expanded(child: Text('${logs.data [index].typeUser}'),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('LAVAGE : '),
                                    SizedBox(width: 20.0,),
                                    Text('${logs.data [index].idLavage}'),
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
                    ) : Center(child: CircularProgressIndicator(),))

              ])
      ) ,

      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Color(0xff0200F4),
        //currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            //backgroundColor: Color(0xff0200F4),
            icon: new IconButton(
              color: Color(0xff0200F4),
              icon: Icon(Icons.settings),
              onPressed: (){
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
            title: new Text('Paramètre', style: TextStyle(color: Color(0xff0200F4))),
          ),
          BottomNavigationBarItem(
            icon: new IconButton(
              color: Color(0xff0200F4),
              icon: Icon(Icons.mode_edit),
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
            title: new Text('Nouvelle Entrée', style: TextStyle(color: Color(0xff0200F4))),
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                color: Color(0xff0200F4),
                icon: Icon(Icons.search),
                onPressed: (){
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
              title: Text('Recherche', style: TextStyle(color: Color(0xff0200F4)),)
          )
        ],
      ),
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
              title: Text('Historique'),
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
                // await Navigator.push(
                //  context,
                // new MaterialPageRoute(
                //   builder: (BuildContext context) {
                //    return Register();
                //  },
                // ),
                // );
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
      ) : Center(child: CircularProgressIndicator(),),);

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

  void checkDate()async{
    DateTime d1;
    DateTime d2;
    int differ;
    Duration dur;
    setState(() {
      date1 = dateCtl.text;
      date2 = dateCtl2.text;
      //chargement = false;
    });

    if(date1 != "" && date2 != "") {
      d1 = DateTime.parse(date1);
      d2 = DateTime.parse(date2);
      dur = d2.difference(d1);
      differ = int.parse((dur.inDays / 365).floor().toString());
    }

    if(dateCtl.text == "" || dateCtl2.text == ""){
      //print("la date est $date1");
      _showMsg("Renseignez correctement les Dates...Merci !");
    }else if(differ < 0){
      _showMsg("Desole, la Date2 ne peut pas etre inferieur a la Date1...Merci de renseigner correctement ce champ !");
    }else{
      _getSearch();
    }

  }

  void _getSearch() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idLav = localStorage.getString('id_lavage');

    datEnreg1 = mydate1;
    datEnreg2 = mydate2;
    //AgenttFromSearchTransa();

    if(searchTextField.textField.controller.text != "") {
      var res = await CallApi().getData('getLogForLavage/$searchVal/$datEnreg1/$datEnreg2');

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body)['data'];

        setState(() {
          logs = listlogsFromJson(res.body);
          toggle = true;
          affiche = true;
          chargement = true;
        });
      }
    }else{
      var res = await CallApi().getData('getLogAdmin/$datEnreg1/$datEnreg2');

      if (res.statusCode == 200) {
        var resBody = json.decode(res.body)['data'];

        setState(() {
          logs = listlogsFromJson(res.body);
          toggle = true;
          affiche = true;
          chargement = true;
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

