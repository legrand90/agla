// To parse this JSON data, do
//
//     final listpaiement = listpaiementFromJson(jsonString);

import 'dart:convert';

Listsalaire listsalaireFromJson(String str) => Listsalaire.fromJson(json.decode(str));

String listsalaireToJson(Listsalaire data) => json.encode(data.toJson());

class Listsalaire {
  List<Datum> data;

  Listsalaire({
    this.data,
  });

  factory Listsalaire.fromJson(Map<String, dynamic> json) => Listsalaire(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String idAgent;
  String montant;
  DateTime dateEnreg;
  String idLavage;
  String idUser;


  Datum({
    this.id,
    this.idAgent,
    this.montant,
    this.dateEnreg,
    this.idLavage,
    this.idUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idAgent: json["id_agent"],
    montant: json["montant"],
    dateEnreg: DateTime.parse(json["dateEnreg"]),
    idLavage: json["id_lavage"],
    idUser: json["id_user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_agent": idAgent,
    "montant": montant,
    "dateEnreg": dateEnreg.toIso8601String(),
    "id_lavage": idLavage,
    "id_user": idUser,
  };
}
