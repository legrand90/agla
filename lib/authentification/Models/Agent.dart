// To parse this JSON data, do
//
//     final listagents = listagentsFromJson(jsonString);

import 'dart:convert';

Listagents listagentsFromJson(String str) => Listagents.fromJson(json.decode(str));

String listagentsToJson(Listagents data) => json.encode(data.toJson());



class Listagents {
  List<Datum> data;

  Listagents({
    this.data,
  });

  factory Listagents.fromJson(Map<String, dynamic> json) => Listagents(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String nom;
  String contact;
  String contactUrgence;
  String quartier;
  String dateEnreg;
  String idLavage;
  bool success;
  String message;
  String dateNaiss;
  String numeroCni;
  String salaire;

  Datum({
    this.id,
    this.nom,
    this.contact,
    this.contactUrgence,
    this.quartier,
    this.dateEnreg,
    this.idLavage,
    this.success,
    this.message,
    this.dateNaiss,
    this.numeroCni,
    this.salaire,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nom: json["nom"],
    contact: json["contact"],
    contactUrgence: json["contactUrgence"],
    quartier: json["quartier"],
    dateEnreg: json["dateEnreg"],
    idLavage: json["id_lavage"],
    success: json["success"],
    message: json["message"],
    dateNaiss: json["dateNaiss"],
    numeroCni: json["numeroCni"],
    salaire: json["salaire"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "contact": contact,
    "contactUrgence": contactUrgence,
    "quartier": quartier,
    "dateEnreg": dateEnreg,
    "id_lavage": idLavage,
    "success": success,
    "message": message,
    "dateNaiss": dateNaiss,
    "numeroCni": numeroCni,
    "salaire": salaire,
  };
}


