// To parse this JSON data, do
//
//     final listinfoVehicule = listinfoVehiculeFromJson(jsonString);

import 'dart:convert';

ListinfoVehicule listinfoVehiculeFromJson(String str) => ListinfoVehicule.fromJson(json.decode(str));

String listinfoVehiculeToJson(ListinfoVehicule data) => json.encode(data.toJson());

class ListinfoVehicule {
  List<Datum> data;

  ListinfoVehicule({
    this.data,
  });

  factory ListinfoVehicule.fromJson(Map<String, dynamic> json) => ListinfoVehicule(
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
