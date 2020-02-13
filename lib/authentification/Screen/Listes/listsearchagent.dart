// To parse this JSON data, do
//
//     final listagentTransaction = listagentTransactionFromJson(jsonString);

import 'dart:convert';

ListagentTransaction listagentTransactionFromJson(String str) => ListagentTransaction.fromJson(json.decode(str));

String listagentTransactionToJson(ListagentTransaction data) => json.encode(data.toJson());

class ListagentTransaction {
  List<Datum> data;

  ListagentTransaction({
    this.data,
  });

  factory ListagentTransaction.fromJson(Map<String, dynamic> json) => ListagentTransaction(
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
  int totalCommissions;
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
    this.totalCommissions,
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
    totalCommissions: json["totalCommission"],
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
    "totalCommissions": totalCommissions,
    "id_matricule_vehicule": idMatricule,
  };
}
