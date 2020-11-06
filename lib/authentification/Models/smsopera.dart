// To parse this JSON data, do
//
//     final smsopera = smsoperaFromJson(jsonString);

import 'dart:convert';

Smsopera smsoperaFromJson(String str) => Smsopera.fromJson(json.decode(str));

String smsoperaToJson(Smsopera data) => json.encode(data.toJson());

class Smsopera {
  Smsopera({
    this.data,
  });

  List<Datum> data;

  factory Smsopera.fromJson(Map<String, dynamic> json) => Smsopera(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.contenu,
    this.nom,
    this.smsEnvoyer,
    this.smsRestant,
    this.dateEnreg,
  });

  int id;
  String contenu;
  String nom;
  String smsEnvoyer;
  String smsRestant;
  DateTime dateEnreg;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    contenu: json["contenu"],
    nom: json["nom"],
    smsEnvoyer: json["smsEnvoyer"],
    smsRestant: json["smsRestant"],
    dateEnreg: DateTime.parse(json["dateEnreg"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contenu": contenu,
    "nom": nom,
    "smsEnvoyer": smsEnvoyer,
    "smsRestant": smsRestant,
    "dateEnreg": dateEnreg.toIso8601String(),
  };
}
