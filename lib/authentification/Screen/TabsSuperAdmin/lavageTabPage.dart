import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Listlavages.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsUsers.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailslavages.dart';
import 'package:lavage/authentification/Screen/Listes/listUsersByIdLavage.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../Transaction.dart';
import '../login_page.dart';




class LavageSearch extends StatefulWidget {

  @override
  _LavageSearchState createState() => new _LavageSearchState();
}

class _LavageSearchState extends State<LavageSearch> {

  AutoCompleteTextField searchTextField;
  GlobalKey <AutoCompleteTextFieldState<Datux>> keys = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _matricule = TextEditingController();
  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  static List <Datux> listlavages = List <Datux>()  ;
  List data = List() ;
  List data2 = List() ;
  List data3 = List() ;//edited line
  var data4 ;
  var commission;
  var tarification;
  var id ;
  var idTari ;
  var id_commission;

  var searchVal ;

  var matricule ;
  String _mySelection;
  String _mySelection2;


  bool visible = false;

  bool loading = true;

  bool loader = true;

  bool load = true;

  Listlavages lavages = Listlavages()  ;


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

  Future<dynamic> getLavage() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('getLavageOrderByName');
    // String url = "http://192.168.43.217:8000/api/prestation/$id";
    // final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
     var resBody = json.decode(res.body)['data'];
    // final response = await http.get('$url');

    setState(() {
      lavages = listlavagesFromJson(res.body);
    });

    if(lavages.data.length != 0){
      resBody = json.decode(res.body)['data'];
    }else{
      _showMsg("Liste vide !!!");
    }
    return lavages;
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
    this.getLavages();
    this.getLavage();
    this.getUserName();
    super.initState();
    this.getStatut();
  }

  @override
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
      body: load ? Form(
        key: _formKey,
        // autovalidate: _autoValidate,
              child: ListView(
               // mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  SizedBox(height: 50.0),

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

                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){

                          (searchVal != null) ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsersListByIdLavage(idlav: searchVal ),
                              )) : _showMsg('Veuillez selectionner un lavage !');
                        },
                      )

                    ],
                  )),

                  ////////////////////////////////////////////////////////////////////////////
                  SizedBox(
                    height: 50.0,
                  ),

        Container(
          height: 300.0,
          child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (lavages == null || lavages.data == null || lavages.data.length == 0 )? 0 : lavages.data.length,
                    itemBuilder: (_,int index)=>Container(
                        child: Card(child:ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text(lavages.data [index] .libelleLavage),),
                          // SizedBox(width: 170,),

                          SizedBox(width: 30.0,),


                        ],
                      ),

                      onTap: ()async{
                        setState(() {
                          load = false;
                        });
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsersListByIdLavage(idlav: lavages.data [index] .id),
                            ));
                        setState(() {
                          load = true;
                        });
                      },
                    ))),
                  ))

                  //////////////////////////////////////////////////////////

                ],
              ),

      ) : Center(child: CircularProgressIndicator(),),

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
                color: Color(0xff11b719),
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
              title: Text('Deconnexion'),
              onTap: () async{
                setState(() {
                  load = false;
                });
                await _logout();

                setState(() {
                  load = true;
                });
              },
            ),


          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),

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
  void _sendDataMatricule() async{
    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var idlavage = localStorage.getString('id_lavage');
      var data = {
        'id_client': searchVal,
        'libelle_matricule': _matricule.text,
        'dateEnreg': date,
        'id_lavage': idlavage,
        'id_couleur': _mySelection,
        'id_marque': _mySelection2,
      };

      var res = await CallApi().postAppData(data, 'create_matricule');
      // var body = json.decode(res.body)['data'];

      if(res.statusCode == 200){
        setState(() {
          _matricule.text = '';
          _mySelection = null;
          _mySelection2 = null;
          searchTextField.textField.controller.text = '';
          searchVal = '' ;
        });
        _showMsg('Donnees enregistrees avec success');

      }else{
        _showMsg("Erreur d'enregistrement ");
      }
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


//  final String urlCouleur = "http://192.168.43.217:8000/api/couleur";
//  final String urlMarque = "http://192.168.43.217:8000/api/marque";

  Future<String> getCouleur() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('couleur');
    // final res = await http.get(Uri.encodeFull(urlCouleur), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    setState(() {
      data = resBody;
    });

    //print(resBody);
    return "Success";
  }

  Future<String> getMarque() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');


    var res = await CallApi().getData('marque');
    // final res = await http.get(Uri.encodeFull(urlMarque), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    setState(() {
      data2 = resBody;
    });

    print(data2);
    return "Success";
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



