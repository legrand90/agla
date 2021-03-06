import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _identifiant = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _nomLavage = TextEditingController();

  String identifiant;
  String password;
  String nomLavage;

  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool loading = true;
  var nomUser ;

  var body;

  var fenetre = 'CONNEXION';

  String date = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  Future <void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
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

  Future<bool> _onBackPressed(){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Vous voulez vraiment quitter cette page ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Non"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Oui"),
              onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            )
          ],
        )
    );
  }

  Future<bool> _passwordForgot(){

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Pour la reinitialisation de votre mot de passe, veuillez contacter le service technique . Merci ! "),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok", style: TextStyle(fontSize: 20.0),),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  @override
  void initState(){
    super.initState();
    //this.getStatut();
    //timer = Timer.periodic(Duration(seconds: 5), (Timer t) => this.getClients());
    //this.getLastCommission();
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
    return WillPopScope(
        onWillPop:() =>_onBackPressed(),
        child : Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: loading ? LoadingScreen(
              child: Form(
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
                          LogoAgla(),
                          //SizedBox(height: 5.0),
                          Text("CONNEXION",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          SizedBox(height: 20.0),
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
                                    Icons.perm_identity,
                                    color: Colors.red,
                                  ),
                                ),
                                new Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    autofocus: false,
                                    controller: _identifiant,
                                    validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                                    onSaved: (value) => identifiant = value,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Identifiant",
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
                            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: Row(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal:20.0),
                                  child: Icon(
                                    Icons.lock_open,
                                    color: Colors.red,
                                  ),
                                ),
                                new Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    autofocus: false,
                                    controller: _password,
                                    validator: (value) => value.isEmpty ? 'invalide password' : null,
                                    onSaved: (value) => password = value,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Mot de passe",
                                      hintStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ////////////////////////////////////////////////////////////////
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                        loading = false;
                                      });
                                      await _login();
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
                                              "Se connecter",
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

                          //////////////////////////////////////////////////////////
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(30.0)
                                    ),
                                    color: Colors.white,
                                    onPressed: (){
                                      _passwordForgot();
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
                                              "Mot de passe oublié",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.red,
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

                          SizedBox(height: 50.0,),

                          //////////////////////////////////////////////////////////

                          Container(
                            color: Colors.white,
                            child: Center(
                              child: FlatButton(
                                onPressed: ()async{
                                  _launchMaxomURL();
                                },
                                child :Text("Un produit de MAXOM : (00225) 494 928 25", style: TextStyle(color: Color(0xff003372)),),),),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              inAsyncCall: _loadingVisible) : Center(child: CircularProgressIndicator(),),
        )
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

  var idLav;

  Future <void>  _login () async{

    if(validateAndSave()) {
      //try {
      var data = {
        'numero': _identifiant.text,
        'password': _password.text,
      };

      var res = await CallApi().postData(data, 'login');
      var body = json.decode(res.body);
      //print(body);
      if(body['success']){
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['token']);
        localStorage.setString('user', body['token']);
        localStorage.setString('id_lavage', body['user']['id_lavage']);
        localStorage.setString('nom', body['user']['name']);
        localStorage.setString('Admin', body['user']['admin']);
        localStorage.setInt('ID', body['user']['id']);

        setState(() {
          nomUser = localStorage.getString("nom");
          idLav = localStorage.getString("id_lavage");
        });

        var idUser = localStorage.getInt('ID');
        adm = localStorage.getString('Admin');

        if(adm == '0' || adm == '1'){
          var res = await CallApi().getData('getUser/$idUser');
          //print('le corps $res');
          var resBody = json.decode(res.body)['data'];

          if(resBody['success']){

            setState((){
              statu = resBody['status'];
              // libLavage = resBody['nomLavage'];

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

        if(localStorage.getString("Admin") == '0' || localStorage.getString("Admin") == '1'){

          var dataLog = {
            'fenetre': '$fenetre',
            'tache': "connexion",
            'execution': "connecter",
            'id_user': localStorage.getInt('ID'),
            'dateEnreg': date,
            'id_lavage': localStorage.getString('id_lavage'),
            'type_user': statu,
          };

          var resAbon = await CallApi().getData('isActive/$idLav');
          var bodyAbon = json.decode(resAbon.body);

          if(bodyAbon['success']){

            var resLog = await CallApi().postData(dataLog, 'create_log');

            localStorage.setString('dateFinAbonn', bodyAbon['date']);

            await Navigator.push(context,
              new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new DashbordScreen();
                  }
              ),
            );
          }else{
            _showMsg('Désolé...Vous n\'avez pas d\'abonnement actif !');
          }
        }else{

          var dataLog = {
            'fenetre': '$fenetre',
            'tache': "connexion",
            'execution': "connecter",
            'id_user': localStorage.getInt('ID'),
            'dateEnreg': date,
            'id_lavage': 'NULL',
            'type_user': statu,
          };

          var resLog = await CallApi().postData(dataLog, 'create_log');

          await Navigator.push(context,
            new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new DashbordScreen();
                }
            ),
          );
        }

      }else{
        _showMsg(body['message']);
//          setState(() {
//            loading = true;
//          });

      }

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

  var adm;
  var statu;
  var libLavage;

  Future <void> getStatut()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var idUser = localStorage.getInt('ID');
    adm = localStorage.getString('Admin');

    if(adm == '0' || adm == '1'){
      var res = await CallApi().getData('getUser/$idUser');
      //print('le corps $res');
      var resBody = json.decode(res.body)['data'];

      if(resBody['success']){

        setState((){
          statu = resBody['status'];
         // libLavage = resBody['nomLavage'];

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

class LogoAgla extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/logoAgla.png');
    Image image = Image(image: assetImage, width: 250.0, height: 250.0,);

    return Container(child: image,);
  }

}



