import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavage/api/api.dart';
import 'package:lavage/authentification/Models/Agent.dart';
import 'package:lavage/authentification/Models/Commission.dart';
import 'package:lavage/authentification/Models/Tarifications.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsCommission.dart';
import 'package:lavage/authentification/Screen/DetailSreen/detailsagent.dart';
import 'package:lavage/authentification/Screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Transaction.dart';
import '../login_page.dart';
import 'package:http/http.dart' as http;

class PrestationTabPage extends StatefulWidget {

  final Widget child ;

  PrestationTabPage({Key key, @required this.child}) : super(key: key);

  @override
  _PrestationTabPageState createState() => _PrestationTabPageState();
}

class _PrestationTabPageState extends State<PrestationTabPage> {

  @override

  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor: Color(0xFFDADADA),
      body: Form(
          child: ListView(
            children: <Widget>[

              SizedBox(
                height: 30.2,
              ),

              Container(
                child: Center(
                  child: Text('INFORMATIONS PRESTATION'),
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
                          //controller: _nomPrestation,
                          validator: (value) => value.isEmpty ? 'Ce champ est requis' : null,
                          // onSaved: (value) => nomPrestation = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Saisir la Prestation",
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          )
      ),
    );


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
}



