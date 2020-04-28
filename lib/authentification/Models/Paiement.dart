// To parse this JSON data, do
//
//     final listpaiement = listpaiementFromJson(jsonString);

import 'dart:convert';

Listpaiement listpaiementFromJson(String str) => Listpaiement.fromJson(json.decode(str));

String listpaiementToJson(Listpaiement data) => json.encode(data.toJson());

class Listpaiement {
  List<Datum> data;

  Listpaiement({
    this.data,
  });

  factory Listpaiement.fromJson(Map<String, dynamic> json) => Listpaiement(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String typeTransaction;
  String montant;
  DateTime dateEnreg;
  String idAgent;
  String idUser;
  String ancienSolde;
  String nouveauSolde;
  String idLavage;
  bool success;

  Datum({
    this.id,
    this.typeTransaction,
    this.montant,
    this.dateEnreg,
    this.idAgent,
    this.idUser,
    this.ancienSolde,
    this.nouveauSolde,
    this.idLavage,
    this.success,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    typeTransaction: json["typeTransaction"],
    montant: json["montant"],
    dateEnreg: DateTime.parse(json["dateEnreg"]),
    idAgent: json["id_agent"],
    idUser: json["id_user"],
    ancienSolde: json["ancien_solde"],
    nouveauSolde: json["nouveau_solde"],
    idLavage: json["id_lavage"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "typeTransaction": typeTransaction,
    "montant": montant,
    "dateEnreg": dateEnreg.toIso8601String(),
    "id_agent": idAgent,
    "id_user": idUser,
    "ancien_solde": ancienSolde,
    "nouveau_solde": nouveauSolde,
    "id_lavage": idLavage,
    "success": success,
  };
}
