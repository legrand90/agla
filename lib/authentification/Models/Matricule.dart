// To parse this JSON data, do
//
//     final listmatricule = listmatriculeFromJson(jsonString);

import 'dart:convert';

Listmatricule listmatriculeFromJson(String str) => Listmatricule.fromJson(json.decode(str));

String listmatriculeToJson(Listmatricule data) => json.encode(data.toJson());

class Listmatricule {
  List<Datum> data;

  Listmatricule({
    this.data,
  });

  factory Listmatricule.fromJson(Map<String, dynamic> json) => Listmatricule(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String matricule;
  String dateEnreg;
  String idClient;
  String idCouleur;
  String idMarque;
  String idLavage;


  Datum({
    this.id,
    this.matricule,
    this.dateEnreg,
    this.idClient,
    this.idCouleur,
    this.idMarque,
    this.idLavage,

  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    matricule: json["matricule"],
    dateEnreg: json["dateEnreg"],
    idClient: json["id_client"],
    idCouleur: json["id_couleur"],
    idMarque: json["id_marque"],
    idLavage: json["id_lavage"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "matricule": matricule,
    "dateEnreg": dateEnreg,
    "id_client": idClient,
    "id_couleur": idCouleur,
    "id_marque": idMarque,
    "id_lavage": idLavage,

  };
}

class Datu {
  int id;
  String matricule;

  Datu({
    this.id,
    this.matricule,

  });

  factory Datu.fromJson(Map<String, dynamic> json) => Datu(
    id: json["id"],
    matricule: json["matricule"] as String,

  );

//  Map<String, dynamic> toJson() => {
//    "id": id,
//    "nom": nom,
//  };
}
