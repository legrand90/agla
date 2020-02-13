// To parse this JSON data, do
//
//     final listclients = listclientsFromJson(jsonString);

import 'dart:convert';

Listclients listclientsFromJson(String str) => Listclients.fromJson(json.decode(str));

String listclientsToJson(Listclients data) => json.encode(data.toJson());

class Listclients {
  List<Datum> data;

  Listclients({
    this.data,
  });

  factory Listclients.fromJson(Map<String, dynamic> json) => Listclients(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String nom;
  String matricule;
  String contact;
  String email;
  String dateEnreg;
  String idMarque;
  String idLavage;
  String idCouleur;
  bool success;
  String message;

  Datum({
    this.id,
    this.nom,
    this.matricule,
    this.contact,
    this.email,
    this.dateEnreg,
    this.idMarque,
    this.idLavage,
    this.idCouleur,
    this.success,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nom: json["nom"],
    matricule: json["matricule"],
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
    "matricule": matricule,
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

class Datu {
  int id;
  String nom;

  Datu({
    this.id,
    this.nom,

  });

  factory Datu.fromJson(Map<String, dynamic> json) => Datu(
    id: json["id"],
    nom: json["nom"] as String,

  );

//  Map<String, dynamic> toJson() => {
//    "id": id,
//    "nom": nom,
//  };
}