import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Screen/client.dart';
import 'package:lavage/authentification/Screen/dashbord.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:lavage/authentification/Screen/tutoriel.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:lavage/authentification/Screen/Listes/listagents.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';


import 'Tabs/clientPage.dart';
import 'Transaction.dart';
import 'historique.dart';
import 'login_page.dart';
//import 'Listes/listagents.dart';

//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class Apropos extends StatefulWidget {
  @override
  _AproposState createState() => new _AproposState();
}

class _AproposState extends State<Apropos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAgent = TextEditingController();
  final TextEditingController _contactAgent = TextEditingController();
  final TextEditingController _domicilAgent = TextEditingController();
  final TextEditingController _contactUrgence = TextEditingController();
  final TextEditingController _numeroCNI = TextEditingController();
  final TextEditingController _photo = TextEditingController();
  final TextEditingController dateCtl = TextEditingController();


  String dateHeure = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now());

  String nomAgent;
  String contactAgent;
  String domicilAgent;
  String contactUrgence;

  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool loading = true;
  bool load = true;
  var mydate1;

  var urlPhoto;

  var fenetre = 'APROPOS';

  int _currentIndex = 0;
  final List<Widget> _children = [];

  var _currencies2 = <String>[
    '1-EN CONCUBINAGE',
    '2-CELIBATAIRE',
  ];

  int _mySelection2;

  var _currencies = <String>[
    '1-OUI',
    '2-NON',
  ];

  int _mySelection;

  var _currencies3 = <String>[
    '1-OUI',
    '2-NON',
  ];

  int _mySelection3;

  var _currencies4 = <String>[
    '1-OUI',
    '2-NON',
  ];

  int _mySelection4;

  File _imageFile;
  // To track the file uploading state
  bool _isUploading = false;
  String baseUrl = 'https://service.agla.app/api/savePhoto';


  // Listagents listagents = Listagents ()  ;

  Future <void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }


//  String url = "http://192.168.43.217:8000/api/agent";
//
//  Future<String> getPost() async{
//    final res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json","Content-type" : "application/json",});
//    var resBody = json.decode(res.body)['data'];
//   // final response = await http.get('$url');
//
//    setState(() {
//      listagents = listagentsFromJson(resBody);
//    });
//    return "success";
//  }

//   createAgentList(){
//
//     ListView.builder(
//         //itemBuilder: (_,int index)=>Listagents(this.data[index]),
//         itemCount: (listagents == null || listagents.data == null || listagents.data.length == 0 )? 0 : listagents.data.length,
//       itemBuilder: (_,int index)=>ListTile(
//         title: Text(listagents.data [index] .nom),
//       ),
//     );
//
//
////    for(agent agt in Agents){
////      widgets.add(Text('Nom agent : ${agt.nom}'));
////    }
//
////     FutureBuilder<Listagents>(
////        future: getPost(),
////        builder: (context, snapshot) {
////          return Text('${snapshot.data.nom}');
////        }
////    );
//
//
//  }


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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  LogoApropos(),
                  SizedBox(height: 25.0),
                  Text("AGLA, Application de Gestion des Lavages Autos, est une application mobile et sécurisée qui facilite votre quotidien .",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 25.0),
                  //////////////////////////////////////////////////////////
                  Container(
                    //margin: const EdgeInsets.only(top: 270.0,),
                    //padding: EdgeInsets.symmetric(horizontal:20.0),
                    child: Text('Développée par', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 16.0),),
                        //SizedBox(width: 170,),
                  ),
                  Container(child:Center(child: LogoMaxom())),
                  SizedBox(height: 20,),
                  Container(
                    //margin: const EdgeInsets.only(top: 270.0,),
                    //padding: EdgeInsets.symmetric(horizontal:20.0),
                    child: Row(
                      children: <Widget>[
                      IconButton(
                      iconSize: 30.0,
                      //color: Colors.red,
                      icon: FaIcon(FontAwesomeIcons.phone),
                    ),
                        //SizedBox(width: 170,),
                        SizedBox(width: 10,),
                        Text('(00225) 22 544 924 \n(00225) 49 492 825', style: TextStyle(color: Colors.blue,),),
                      ],
                    ),
                  ),

                  Container(
                    //margin: const EdgeInsets.only(top: 270.0,),
                    //padding: EdgeInsets.symmetric(horizontal:20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          iconSize: 30.0,
                          //color: Colors.blue,
                          icon: FaIcon(FontAwesomeIcons.mailBulk),
                        ),
                        //SizedBox(width: 170,),
                        SizedBox(width: 10,),
                        Text('agla@maxom.ci', style: TextStyle(color: Colors.blue,),),
                      ],
                    ),
                  ),

                  Container(
                    //margin: const EdgeInsets.only(top: 270.0,),
                    //padding: EdgeInsets.symmetric(horizontal:20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          iconSize: 30.0,
                          //color: Colors.blue,
                          icon: FaIcon(FontAwesomeIcons.home),
                        ),
                        //SizedBox(width: 170,),
                        SizedBox(width: 10,),
                        Text('Côte d\'Ivoire, Abidjan. \nCocody, Riviera', style: TextStyle(color: Colors.blue,),),
                      ],
                    ),
                  ),
                ],
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

  void _sendDataAgent() async{

    if(validateAndSave()) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var id = localStorage.getString('id_lavage');
      var id_user = localStorage.getInt('ID');
      var data = {
        'nom': _nomAgent.text.toUpperCase(),
        'contact': _contactAgent.text,
        'quartier': _domicilAgent.text.toUpperCase(),
        'contactUrgence': _contactUrgence.text,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'numero_cni': _numeroCNI.text,
        'photo': urlPhoto,
        'dateNaiss': mydate1,
      };

      var dataLog = {
        'fenetre': '$fenetre',
        'tache': "Enregistrement d'un Agent",
        'execution': "Enregistrer",
        'id_user': id_user,
        'dateEnreg': dateHeure,
        'id_lavage': id,
        'type_user': statu,
      };

      var res = await CallApi().postDataAgent(data, 'create_agent');
      var body = json.decode(res.body)['data'];
      // print('les donnees de l\'Agent: ${body}');

      if(res.statusCode == 200) {
        var res = await CallApi().postData(dataLog, 'create_log');
        setState(() {
          _nomAgent.text = '';
          _contactAgent.text = '';
          _domicilAgent.text = '';
          _contactUrgence.text = '';
          _imageFile = null;
          dateCtl.text = '';
          _numeroCNI.text = '';
        });

        _showMsg("Donnees enregistrees avec succes");

      }else{
        _showMsg("Erreur d'enregistrement");
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

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Faire un Choix',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Utiliser la Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);

                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Utiliser la Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);

                  },
                ),
              ],
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {

    final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(baseUrl));

    final file = await http.MultipartFile.fromPath('photo', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.fields['photo'] = mimeTypeData[1];

    imageUploadRequest.files.add(file);


    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      //_resetState();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _startUploading() async {

    if(validateAndSave()) {
      if((_imageFile != null) && (mydate1 != null)) {
        final Map<String, dynamic> response = await _uploadImage(_imageFile);
        // Check if any error occured
        if (response == null) {
          _showMsg("Erreur d'enregistrement de la photo .");
        } else {
          print("contenu ${response['nomImage']}");

          setState(() {
            urlPhoto = response['nomImage'];
          });

          print('imageFile: $urlPhoto');

          if (urlPhoto != '') {
            _sendDataAgent();

          }
        }

      }else {
        _showMsg('Erreur: la photo et la date de naissance de l\'agent sont requises. Vérifier si elles sont bien renseignées...Merci!');
      }
    }
  }
}


class LogoApropos extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/apropos.jpg');
    Image image = Image(image: assetImage, width: 250.0,);

    return Container(child: image,);
  }

}

class LogoMaxom extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/logomaxom.jpg');
    Image image = Image(image: assetImage, width: 150.0,);

    return Container(child: image,);
  }

}








