// To parse this JSON data, do
//
//     final listclientsearchTrans = listclientsearchTransFromJson(jsonString);

import 'dart:convert';

ListclientsearchTrans listclientsearchTransFromJson(String str) => ListclientsearchTrans.fromJson(json.decode(str));

String listclientsearchTransToJson(ListclientsearchTrans data) => json.encode(data.toJson());

class ListclientsearchTrans {
  List<Datum> data;

  ListclientsearchTrans({
    this.data,
  });

  factory ListclientsearchTrans.fromJson(Map<String, dynamic> json) => ListclientsearchTrans(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String dateEnreg;
  String idAgent;
  String idClient;
  String idTarification;
  String idLavage;
  String idCommission;
  String idPrestation;
  String idMatricule;

  Datum({
    this.id,
    this.dateEnreg,
    this.idAgent,
    this.idClient,
    this.idTarification,
    this.idLavage,
    this.idCommission,
    this.idPrestation,
    this.idMatricule,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    dateEnreg: json["dateEnreg"],
    idAgent: json["id_agent"],
    idClient: json["id_client"],
    idTarification: json["id_tarification"],
    idLavage: json["id_lavage"],
    idCommission: json["id_commission"],
    idPrestation: json["id_prestation"],
    idMatricule: json["id_matricule_vehicule"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dateEnreg": dateEnreg,
    "id_agent": idAgent,
    "id_client": idClient,
    "id_tarification": idTarification,
    "id_lavage": idLavage,
    "id_commission": idCommission,
    "id_prestation": idPrestation,
    "id_matricule_vehicule": idMatricule,
  };
}
