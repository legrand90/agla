// To parse this JSON data, do
//
//     final listclientmatriculesearch = listclientmatriculesearchFromJson(jsonString);

import 'dart:convert';

Listclientmatriculesearch listclientmatriculesearchFromJson(String str) => Listclientmatriculesearch.fromJson(json.decode(str));

String listclientmatriculesearchToJson(Listclientmatriculesearch data) => json.encode(data.toJson());

class Listclientmatriculesearch {
  Data data;

  Listclientmatriculesearch({
    this.data,
  });

  factory Listclientmatriculesearch.fromJson(Map<String, dynamic> json) => Listclientmatriculesearch(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String matricule;
  String dateEnreg;
  String nomClient;
  String idLavage;
  int idClient;

  Data({
    this.id,
    this.matricule,
    this.dateEnreg,
    this.nomClient,
    this.idLavage,
    this.idClient,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    matricule: json["matricule"],
    dateEnreg: json["dateEnreg"],
    nomClient: json["nomClient"],
    idLavage: json["id_lavage"],
    idClient: json["id_client"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "matricule": matricule,
    "dateEnreg": dateEnreg,
    "nomClient": nomClient,
    "id_lavage": idLavage,
    "id_client": idClient,
  };
}
