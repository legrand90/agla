import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/Listes/listDepense.dart';
import 'package:lavage/authentification/Screen/Tabs/clientPage.dart';
import 'package:lavage/authentification/Screen/Transaction.dart';
import 'package:lavage/authentification/Screen/apropos.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/historique.dart';
import 'package:lavage/authentification/Screen/login_page.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:lavage/authentification/Screen/tutoriel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class EditDepense extends StatefulWidget {
  var iddepense ;
  EditDepense({Key key, @required this.iddepense}) : super(key: key);
  @override
  _EditDepenseState createState() => new _EditDepenseState(iddepense);
}

class _EditDepenseState extends State<EditDepense> {
  var iddepense ;
  _EditDepenseState(this.iddepense);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _libelle = TextEditingController();
  final TextEditingController _prixUnit = TextEditingController();
  final TextEditingController _quantite = TextEditingController();
  final TextEditingController _totalPayer = TextEditingController();

  String nomPrestation;
  String descripPrestation;

  bool _autoValidate = false;
  bool _loadingVisible = false;
  String montant;
  var idPresta = 0;
  bool loading = true;
  bool load = true;
  bool aff = false;
  var val;

  var fenetre = 'MODIFICATION DEPENSE';

  Future <void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }


  final GlobalKey <ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();

  String dateHeure = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

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


  void getIdPresta() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');

    var res = await CallApi().getData('getLastIdPrestation/$id');

    //var urlClient = "http://192.168.43.217:8000/api/getClient/$id";
    //final res = await http.get(Uri.encodeFull(urlClient), headers: {"Accept": "application/json","Content-type" : "application/json",});
    var resBody = json.decode(res.body)['data'];

    if(resBody == null){
      setState(() {
        idPresta = 0;
      });
    }else{
      setState(() {
        idPresta = resBody[0]['id'];
      });
    }
    print('les donnees sont : $idPresta');

  }

  void UpdateDepense() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var id = localStorage.getString('id_lavage');
    var id_user = localStorage.getInt('ID');

    //try {
    var data = {
      'libelle_depense': _libelle.text,
      'quantite': _quantite.text,
      'prixUnitaire': _prixUnit.text,
      'prixTotal': int.parse(_quantite.text) * int.parse(_prixUnit.text),
    };

    var dataLog = {
      'fenetre': '$fenetre',
      'tache': "Modification d'une Dépense",
      'execution': "Update",
      'id_user': id_user,
      'dateEnreg': dateHeure,
      'id_lavage': id,
      'type_user': statu,
    };


    var res = await CallApi().postDataEdit(data, 'update_depense/$iddepense/$id');
    var body = json.decode(res.body);
    // print(body);

    if (res.statusCode == 200) {
      var res = await CallApi().postData(dataLog, 'create_log');

      //_showMsg('Donnees mises a jour avec succes');

      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return ListDepense();
          },
        ),
      );

    }else{
      _showMsg("Erreur d'enregistrement");
    }

  }

  void getDepense() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idlavage = localStorage.getString('id_lavage');
    // this.param = _mySelection3;

    // final String url = "http://192.168.43.217:8000/api/getAgent/$idagent/$idlavage"  ;

    var res = await CallApi().getData('getDepense/$iddepense/$idlavage');

//    final res = await http.get(Uri.encodeFull(url), headers: {
//      "Accept": "application/json",
//      "Content-type": "application/json",
//    });

    var resBody = json.decode(res.body)['data'];

    setState(() {
      _libelle.text = resBody['libelle_depense'];
      _quantite.text = resBody['quantite'];
      _prixUnit.text = resBody['prixUnitaire'];
    });



    // print('identi est $idpresta');

  }

  @override
  void initState(){
    super.initState();
    this.getUserName();
    this.getIdPresta();
    this.getStatut();
    this.getDepense();

    _quantite.text = '1';
  }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$fenetre'),
      ),
      body: load ? Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // LogoPrestations(),
                  SizedBox(height: 40.0),
                  Text("SORTIE CAISSE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),
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
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            //autofocus: false,
                            controller: _libelle,
                            //validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            onSaved: (value) => nomPrestation = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Libellé Dépense",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

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
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.red,
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.number,
                            //autofocus: false,
                            controller: _quantite,
                           // validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            //onSaved: (value) => descripPrestation = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Quantité",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ////////////////////////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0,
                              horizontal: 15.0),
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.red,
                          ),
                        ),
                        new Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.number,
                            //autofocus: false,
                            controller: _prixUnit,
                            //validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                            //onSaved: (value) => montant = value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Prix Unitaire",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                            ),
                          ),
                        ),

                        //Container(width: 20.0,),
                        // Expanded(child: Text("Fcfa"),)
                      ],
                    ),
                  ),

                  Container(
                    //margin: const EdgeInsets.only(top: 20.0),
                    margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          child:  FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)
                            ),
                            color: Color(0xff003372),
                            onPressed: ()async{
                              setState(() {
                                val = int.parse(_quantite.text) * int.parse(_prixUnit.text) ;
                                aff = true ;
                              });

                            },
                            child: new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                    child: Text(
                                      "Voir le Total",
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
                          ),
                        )
                      ],
                    ),
                  ),

                  aff ? Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 20.0),
                    child: Text('Prix Total : $val FCFA', style: TextStyle(fontSize: 25.0),),
                  ) : Text(''),

                  ////////////////////////////////////////////////////////////////

                  Row(
                    children : <Widget>[
                      aff ? Expanded(child :Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: loading ? FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff003372),
                                onPressed: ()async{
                                  setState(() {
                                    loading = false;
                                    // aff = false ;
                                  });
                                  await UpdateDepense();

                                  setState(() {
                                    loading = true;
                                  });
                                },
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "ENREGISTRER",
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
                      )) : Text(''),

                      //////////////////////////////////////////////////////////
                      Container(
                        width: 15.0,
                      ),
                      Expanded(child : Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        //padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)
                                ),
                                color: Color(0xff003372),
                                child: new Container(
                                  //padding: const EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "AFFICHER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                onPressed: () async{
                                  setState(() {
                                    load = false;
                                  });
                                  await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ListDepense();
                                      },
                                    ),
                                  );
                                  setState(() {
                                    load = true;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),)],),

                  //////////////////////////////////////////////////////////

                ],
              ),
            ),

          ),
        ),
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
                await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Apropos();
                    },
                  ),
                );

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
  void _sendDataDepense()async{
    if(validateAndSave()) {

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      var id_user = localStorage.getInt('ID');
      //try {
      var data = {
        'libelle_depense': _libelle.text,
        'quantite': _quantite.text,
        'id_user': id_user,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'prixUnitaire': _prixUnit.text,
        'prixTotal': int.parse(_quantite.text) * int.parse(_prixUnit.text),
      };

      var dataLog = {
        'fenetre': '$fenetre',
        'tache': "Enregistrement sortie caisse depense",
        'execution': "Enregistrer",
        'id_user': id_user,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'type_user': statu,
      };

      var res = await CallApi().postDataPrestation(data, 'create_depense');
      var resLog = await CallApi().postData(dataLog, 'create_log');
      var body = json.decode(res.body)['data'];
      // print('les donnees de prestation: ${body}');

      if(res.statusCode == 200){

        setState(() {
          aff = false;
          _libelle.text = "";
          _quantite.text = "";
          _prixUnit.text = "";
          //idPresta = body[0]['id'];
        });

        _showMsg("Données enregistrées avec succès");
      }else{
        _showMsg("Erreur d'enregistrement des données");
      }

    }

    //print(' le type ${idPresta.runtimeType}');
    // print(' le type val ${idPresta}');
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


class LogoPrestations extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/Prestations.jpg');
    Image image = Image(image: assetImage, width: 250.0,);

    return Container(child: image,);
  }

}




