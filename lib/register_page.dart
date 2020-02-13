import 'package:flutter/material.dart';
//import 'login_page.dart';


class RegisterPage extends StatefulWidget {
  static String tag = 'register_page';

  @override
  _RegisterPage createState() => new _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mot_pass = TextEditingController();
  TextEditingController numero = TextEditingController();
  @override
  Widget build(BuildContext context){
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(""),backgroundColor: Colors.red,),
      body: Form(
        key: formKey,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                MyLogo(),
                Padding(
                    padding: EdgeInsets.only(left: 20.0,right: 30.0),
                    child:Row(
                        children: <Widget>[
                          Expanded(
                              child: FlatButton(
                                onPressed: (){

                                },
                                padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
                                child:Text('Inscription',style: TextStyle(color: Colors.black, fontSize: 30.0),),
                              )),

                        ]

                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nom,
                      validator: (String value){
                        if(value.isEmpty){
                          return " ";
                        }
                        return " ";
                      },
                      decoration: InputDecoration(
                          prefixIcon: Material(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            child: IconButton(
                              onPressed: (){

                              },
                              padding: EdgeInsets.only(left: 10.0),
                              icon: Icon(Icons.border_color, color: Colors.red),
                            ),
                          ),
                          //labelText: "Email",
                          hintText: "Votre Nom",
                          contentPadding: EdgeInsets.fromLTRB(15.0, 22.0, 22.0, 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nom,
                      validator: (String value){
                        if(value.isEmpty){
                          return " ";
                        }
                        return "";
                      },
                      decoration: InputDecoration(
                          prefixIcon: Material(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            child: IconButton(
                              onPressed: (){

                              },
                              padding: EdgeInsets.only(left: 10.0),
                              icon: Icon(Icons.border_color, color: Colors.red),
                            ),
                          ),
                          //labelText: "Email",
                          hintText: "Votre Prenom(s)",
                          contentPadding: EdgeInsets.fromLTRB(15.0, 22.0, 22.0, 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: nom,
                      validator: (String value){
                        if(value.isEmpty){
                          return " ";
                        }
                        return "";
                      },
                      decoration: InputDecoration(
                          prefixIcon: Material(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            child: IconButton(
                              onPressed: (){},
                              padding: EdgeInsets.only(left: 10.0),
                              icon: Icon(Icons.phone, color: Colors.red),
                            ),
                          ),
                          //labelText: "Email",
                          hintText: "Votre Numero",
                          contentPadding: EdgeInsets.fromLTRB(15.0, 22.0, 22.0, 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      validator: (String value){
                        if(value.isEmpty){
                          return "saiaissez votre email";
                        }
                        return "";
                      },
                      decoration: InputDecoration(
                          prefixIcon: Material(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            child: IconButton(
                              onPressed: (){},
                              padding: EdgeInsets.only(left: 10.0),
                              icon: Icon(Icons.email, color: Colors.red),
                            ),
                          ),
                          //labelText: "Email",
                          hintText: "Votre email",
                          contentPadding: EdgeInsets.fromLTRB(15.0, 22.0, 22.0, 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )
                      ),
                    )),

                Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: mot_pass,
                      obscureText: true,
                      validator: (String value){
                        if(value.isEmpty){
                          return "saiaissez votre mot de passe";
                        }
                        return "";
                      },
                      decoration: InputDecoration(
                          prefixIcon: Material(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            child: IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.https, color: Colors.red),

                            ),
                          ),

                          //labelText: "Mot de passe",

                          hintText: "Votre mot de passe",
                          contentPadding: EdgeInsets.fromLTRB(15.0, 22.0, 22.0, 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )
                      ),
                    )),


                Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 70.0, right: 70.0),
                  child: RaisedButton(
                    elevation: 10.0,
                    color: Colors.red,
                    child: Text("VALIDER", style: TextStyle(color: Colors.white),),
                    onPressed: (){

                      // sendData();

                       //Navigator.of(context).pushNamed(LoginPage.tag);
                    },

                  ),
                ),
              ],
            )),
      ),
    );
  }

}


Widget MyLogo(){
  var assetimage = AssetImage("assets/logo.png");
  var image = Image(image: assetimage, width: 60.0, height: 60.0);

  return Container(child: image,);


}