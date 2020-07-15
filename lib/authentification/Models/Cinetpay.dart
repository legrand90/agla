// To parse this JSON data, do
//
//     final listcinetpayTrans = listcinetpayTransFromJson(jsonString);

import 'dart:convert';

ListcinetpayTrans listcinetpayTransFromJson(String str) => ListcinetpayTrans.fromJson(json.decode(str));

String listcinetpayTransToJson(ListcinetpayTrans data) => json.encode(data.toJson());

class ListcinetpayTrans {
  ListcinetpayTrans({
    this.data,
  });

  List<Datum> data;

  factory ListcinetpayTrans.fromJson(Map<String, dynamic> json) => ListcinetpayTrans(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.dateEnreg,
    this.montant,
    this.idTransaction,
    this.lavage,
    this.moyenPaiement,
    this.idLavage,
    this.tel,
    this.message,
    this.jourAvant,
    this.jourApres,
  });

  int id;
  DateTime dateEnreg;
  String montant;
  String idTransaction;
  String lavage;
  String moyenPaiement;
  String idLavage;
  String tel;
  String message;
  String jourAvant;
  String jourApres;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    dateEnreg: DateTime.parse(json["dateEnreg"]),
    montant: json["montant"],
    idTransaction: json["idTransaction"],
    lavage: json["lavage"],
    moyenPaiement: json["moyenPaiement"],
    idLavage: json["id_lavage"],
    tel: json["Tel"],
    message: json["message"],
    jourAvant: json["jourAvant"],
    jourApres: json["jourApres"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dateEnreg": dateEnreg.toIso8601String(),
    "montant": montant,
    "idTransaction": idTransaction,
    "lavage": lavage,
    "moyenPaiement": moyenPaiement,
    "id_lavage": idLavage,
    "Tel": tel,
    "message": message,
    "jourAvant": jourAvant,
    "jourApres": jourApres,
  };
}
