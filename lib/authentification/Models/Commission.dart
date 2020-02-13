// To parse this JSON data, do
//
//     final listCommissions = listCommissionsFromJson(jsonString);

import 'dart:convert';

ListCommissions listCommissionsFromJson(String str) => ListCommissions.fromJson(json.decode(str));

String listCommissionsToJson(ListCommissions data) => json.encode(data.toJson());

class ListCommissions {
  List<Datum> data;

  ListCommissions({
    this.data,
  });

  factory ListCommissions.fromJson(Map<String, dynamic> json) => ListCommissions(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String idAgent;
  String idTarification;
  String idLavage;
  String gainAgent;
  String dateEnreg;
  bool success;
  String prestationMontant;

  Datum({
    this.id,
    this.idAgent,
    this.idTarification,
    this.idLavage,
    this.gainAgent,
    this.dateEnreg,
    this.success,
    this.prestationMontant,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idAgent: json["id_agent"],
    idTarification: json["id_tarification"],
    idLavage: json["id_lavage"],
    gainAgent: json["gain_agent"],
    dateEnreg: json["dateEnreg"],
    success: json["success"],
    prestationMontant: json["prestation_montant"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_agent": idAgent,
    "id_tarification": idTarification,
    "id_lavage": idLavage,
    "gain_agent": gainAgent,
    "dateEnreg": dateEnreg,
    "success": success,
    "prestation_montant": prestationMontant,
  };
}
