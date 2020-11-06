import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lavage/authentification/Screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CallApi{
  //var test = 50;
  final String url = 'http://192.168.1.11:8000/api/';
  //final String urlAgent = 'http://192.168.43.223:8000/api/..https://service.agla.app/api/';
     postData(data, apiUrl) async {
    var fullUrl = url + apiUrl + await _getToken();
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }
    getData(apiUrl) async {
      var fullUrl = url + apiUrl + await _getToken();
      return await http.get(
        fullUrl,
        headers: _setHeaders()
      );
    }

    _setHeaders() => {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
    };

     _getToken() async{
       SharedPreferences localStorage = await SharedPreferences.getInstance();
       var token = localStorage.getString('token');
       return '?token=$token';
     }

  postDataAgent(data, apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  postDataLavage(data, apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  postDataCouleur(data, apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }


  postDataEdit(data, apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.put(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  postDataDelete(apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.delete(
        fullUrl,
        headers: _setHeaders()
    );
  }

  postDataMarque(data, apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  postDataPrestation(data, apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  postAppData(data, apiUrl) async {
    var fullUrl = url + apiUrl ;
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }



  }
