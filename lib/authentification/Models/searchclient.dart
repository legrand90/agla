// To parse this JSON data, do
//
//     final listclientsearch = listclientsearchFromJson(jsonString);

import 'dart:convert';

Listclientsearch listclientsearchFromJson(String str) => Listclientsearch.fromJson(json.decode(str));

String listclientsearchToJson(Listclientsearch data) => json.encode(data.toJson());

class Listclientsearch {
  Data data;

  Listclientsearch({
    this.data,
  });

  factory Listclientsearch.fromJson(Map<String, dynamic> json) => Listclientsearch(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String nom;
  String contact;
  String email;
  String dateEnreg;
  String idMarque;
  String idLavage;
  String idCouleur;
  bool success;
  String message;

  Data({
    this.id,
    this.nom,
    this.contact,
    this.email,
    this.dateEnreg,
    this.idMarque,
    this.idLavage,
    this.idCouleur,
    this.success,
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    nom: json["nom"],
    contact: json["contact"],
    email: json["email"],
    dateEnreg: json["dateEnreg"],
    idMarque: json["id_marque"],
    idLavage: json["id_lavage"],
    idCouleur: json["id_couleur"],
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "contact": contact,
    "email": email,
    "dateEnreg": dateEnreg,
    "id_marque": idMarque,
    "id_lavage": idLavage,
    "id_couleur": idCouleur,
    "success": success,
    "message": message,
  };
}
