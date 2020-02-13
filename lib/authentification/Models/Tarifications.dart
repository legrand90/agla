// To parse this JSON data, do
//
//     final listTarifications = listTarificationsFromJson(jsonString);

import 'dart:convert';

ListTarifications listTarificationsFromJson(String str) => ListTarifications.fromJson(json.decode(str));

String listTarificationsToJson(ListTarifications data) => json.encode(data.toJson());

class ListTarifications {
  List<Datum> data;

  ListTarifications({
    this.data,
  });

  factory ListTarifications.fromJson(Map<String, dynamic> json) => ListTarifications(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String idPrestation;
  String idLavage;
  String montant;
  String prestationMontant;

  Datum({
    this.id,
    this.idPrestation,
    this.idLavage,
    this.montant,
    this.prestationMontant,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idPrestation: json["id_prestation"],
    idLavage: json["id_lavage"],
    montant: json["montant"],
    prestationMontant: json["prestation_montant"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_prestation": idPrestation,
    "id_lavage": idLavage,
    "montant": montant,
    "prestation_montant": prestationMontant,
  };
}
