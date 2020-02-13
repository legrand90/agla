// To parse this JSON data, do
//
//     final listtransactions = listtransactionsFromJson(jsonString);

import 'dart:convert';

Listtransactions listtransactionsFromJson(String str) => Listtransactions.fromJson(json.decode(str));

String listtransactionsToJson(Listtransactions data) => json.encode(data.toJson());

class Listtransactions {
  List<Datum> data;

  Listtransactions({
    this.data,
  });

  factory Listtransactions.fromJson(Map<String, dynamic> json) => Listtransactions(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String date;
  String agent;
  String client;
  String tarification;
  String commission;
  String prestation;
  String plaqueImmatriculation;

  Datum({
    this.id,
    this.date,
    this.agent,
    this.client,
    this.tarification,
    this.commission,
    this.prestation,
    this.plaqueImmatriculation,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["ID"],
    date: json["DATE"],
    agent: json["AGENT"],
    client: json["CLIENT"],
    tarification: json["TARIFICATION"],
    commission: json["COMMISSION"],
    prestation: json["PRESTATION"],
      plaqueImmatriculation: json["PLAQUE_IMMATRICULATION"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "DATE": date,
    "AGENT": agent,
    "CLIENT": client,
    "TARIFICATION": tarification,
    "COMMISSION": commission,
    "PRESTATION": prestation,
    "PLAQUE_IMMATRICULATION": plaqueImmatriculation
  };
}
