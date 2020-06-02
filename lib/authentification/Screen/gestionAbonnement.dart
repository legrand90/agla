import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Listlavages.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'dart:convert';
import 'package:lavage/authentification/widgets/loading.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Listes/listcouleurs.dart';
import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'historique.dart';
import 'login_page.dart';

class GestionAbonnement extends StatefulWidget {
  var idcouleur ;
  GestionAbonnement({Key key, @required this.idcouleur}) : super(key: key);

  @override
  _GestionAbonnementState createState() => new _GestionAbonnementState(this.idcouleur);
}
class _GestionAbonnementState extends State<GestionAbonnement> {
  var idcouleur ;
  _GestionAbonnementState(this.idcouleur);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomCouleur = TextEditingController();

  AutoCompleteTextField searchTextField;
  GlobalKey <AutoCompleteTextFieldState<Datux>> keys = GlobalKey();
  static List <Datux> listlavages = List <Datux>()  ;

  var searchVal ;

  Listlavages lavages = Listlavages()  ;

  String nomCouleur;

  String dateHeure = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());


  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool loading = true;
  bool loading2 = true;
  bool load = true;
  int selectedRadio ;

  var body;
  var fenetre = 'Gestion Abonnement';

  static List <Datux> loadLavages(String jsonString){
    final parsed = json.decode(jsonString)['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datux>((json)=>Datux.fromJson(json)).toList();
  }


  void getLavages() async {

    var res = await CallApi().getData('getLavageOrderByName');

    if(res.statusCode == 200){

      listlavages = loadLavages(res.body);

      setState(() {
        loading2  = false ;
      });

      print('les lavages $listlavages');

    }else{
      _showMsg('Liste vide');
    }

  }

  Future <void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
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

  setSelectRadio(int valeur){

    setState(() {
      selectedRadio = valeur;
    });
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
    this.getStatut();
    this.getLavages();
    selectedRadio = 0;
  }
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$fenetre'),
      ),
      body: load ?  Form(
              key: _formKey,
              //  autovalidate: _autoValidate,
              child: ListView(
                children: <Widget>[

                  SizedBox(
                    height: 30.2,
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: ButtonBar(
                      //alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          // title: Text("Nom"),
                          activeColor: Colors.black,
                          onChanged: (val){
                            setSelectRadio(val);
                            setState(() {

                            });
                            //visible = false ;
                          },
                        ),

                        Text("Renouveller"),
                        Radio(
                          value: 2,
                          groupValue: selectedRadio,
                          // title: Text("Matri"),
                          activeColor: Colors.black,
                          onChanged: (val){
                            setSelectRadio(val);
                            setState(() {

                            });
                          },
                        ),

                        Text("Annuler"),

                        SizedBox(
                          height: 30.2,
                        ),
                      ],
                    ),
                  ),

                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: loading2 ? Center(child: CircularProgressIndicator()) : searchTextField = AutoCompleteTextField<Datux>(
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

                  SizedBox(
                    height: 30.2,
                  ),

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
                              await _setOpera();
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
                                      "Valider",
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
                          ) : Center(child: CircularProgressIndicator(),),
                        )
                      ],
                    ),
                  ),

          ]),
    ) :  Center(child: CircularProgressIndicator()),

      drawer: load ? Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: (admin == '0' || admin == '1') ? ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('$nameUser'),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Color(0xff0200F4),
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
                await _alertDeconnexion();

                setState(() {
                  load = true;
                });
              },
            ),

          ],
        ) : ListView(
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
              margin: const EdgeInsets.only(top: 210.0,),
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
      ) : Center(child: CircularProgressIndicator(),),
    );
  }

  Future<void> smsError(String error) async {
    Text titre = new Text("Error:");
    Text soustitre = new Text(error);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(title: titre,
            content: soustitre,
            actions: <Widget>[okButton(buildContext)],);
        }
    );
  }

  FlatButton okButton(BuildContext context) {
    return new FlatButton(
        onPressed: () => Navigator.of(context).pop(), child: new Text("ok"));
  }

  //methode pour se connecter
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _setCouleur() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var id_user = localStorage.getInt('ID');
    if (validateAndSave()) {
      //try {
      var data = {
        'libelle_couleur': _nomCouleur.text.toUpperCase(),
        'id_lavage': id
      };

      var dataLog = {
        'fenetre': '$fenetre',
        'tache': "Ajout d'une Couleur",
        'execution': "Enregistrer",
        'id_user': id_user,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'type_user': statu,
      };


      var res = await CallApi().postDataCouleur(data, 'create_couleur');
      var body = json.decode(res.body)['data'];
      // print(body);

      if (res.statusCode == 200) {
        var res = await CallApi().postData(dataLog, 'create_log');

        setState(() {
          _nomCouleur.text = '';
        });


        _showMsg("Donnees enregistrees avec succes ");

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

  void checkCouleur()async{

    var resCouleur = await CallApi().getData('checkCouleur/${_nomCouleur.text}');
    var couleurBody = json.decode(resCouleur.body);

    if((couleurBody['success'])){

      // print('donnee 1 $matriculebody');
      //print('donnee 2 $contactbody');
      _showMsg("Cette couleur existe deja !!!");
    }else{
      //_showMsg("existe pas!!!");
      _setCouleur();

    }

  }

  var nameUser;
  var admin ;

  void getUserName() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userName = localStorage.getString('nom');

    setState(() {
      nameUser = userName;
      admin = localStorage.getString('Admin');
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

  void _setOpera() async {
    if (searchVal != null) {
      if (selectedRadio == 1) {
        var resAbon = await CallApi().getData('isActive/$searchVal');
        var bodyAbon = json.decode(resAbon.body);

        if (!bodyAbon['success']) {
          renouvellerAbonnement();
        } else {
          _showMsg("Désolé l'abonnement ne peut pas etre renouvelé");
        }
      } else if (selectedRadio == 2) {
        Annulerbonnement();
      } else {
        _showMsg("Désolé ! Aucun des boutons renouveller et annuler n'est sélectionné ");
      }
    }else{
      _showMsg("Sélectionnez le lavage !");
    }
  }

  void renouvellerAbonnement()async{

      var res = await CallApi().getData('renouvellerAbonnement/$searchVal');
      var resBody = json.decode(res.body)['data'];

      if (resBody['success']) {
        _showMsg("Abonnement renouvelé avec succes");
      } else {
        _showMsg("Erreur");
      }

  }

  void Annulerbonnement()async{
    var res = await CallApi().getData('annulerAbonnement/$searchVal');
    var resBody = json.decode(res.body);
    if(resBody['success']){
      _showMsg("Abonnement annuler avec succes");
    }else{
      _showMsg("Erreur");
    }
  }
}

