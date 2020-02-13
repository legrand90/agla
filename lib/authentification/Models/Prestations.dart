// To parse this JSON data, do
//
//     final listprestations = listprestationsFromJson(jsonString);

import 'dart:convert';

Listprestations listprestationsFromJson(String str) => Listprestations.fromJson(json.decode(str));

String listprestationsToJson(Listprestations data) => json.encode(data.toJson());

class Listprestations {
  List<Datum> data;

  Listprestations({
    this.data,
  });

  factory Listprestations.fromJson(Map<String, dynamic> json) => Listprestations(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String libellePrestation;
  String descripPrestation;
  String idLavage;
  bool success;
  String message;

  Datum({
    this.id,
    this.libellePrestation,
    this.descripPrestation,
    this.idLavage,
    this.success,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    libellePrestation: json["libelle_prestation"],
    descripPrestation: json["descrip_prestation"],
    idLavage: json["id_lavage"],
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle_prestation": libellePrestation,
    "descrip_prestation": descripPrestation,
    "id_lavage": idLavage,
    "success": success,
    "message": message,
  };
}
