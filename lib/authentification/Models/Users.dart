// To parse this JSON data, do
//
//     final listusers = listusersFromJson(jsonString);

import 'dart:convert';

Listusers listusersFromJson(String str) => Listusers.fromJson(json.decode(str));

String listusersToJson(Listusers data) => json.encode(data.toJson());

class Listusers {
  List<Datum> data;

  Listusers({
    this.data,
  });

  factory Listusers.fromJson(Map<String, dynamic> json) => Listusers(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String nom;
  String numero;
  String email;
  String dateEnreg;
  String idLavage;
  dynamic nomLavage;
  dynamic situation;
  String admin;
  dynamic status;
  bool success;
  String message;

  Datum({
    this.id,
    this.nom,
    this.numero,
    this.email,
    this.dateEnreg,
    this.idLavage,
    this.nomLavage,
    this.situation,
    this.admin,
    this.status,
    this.success,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nom: json["nom"],
    numero: json["numero"],
    email: json["email"],
    dateEnreg: json["dateEnreg"],
    idLavage: json["id_lavage"],
    nomLavage: json["nomLavage"],
    situation: json["situation"],
    admin: json["admin"],
    status: json["status"],
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "numero": numero,
    "email": email,
    "dateEnreg": dateEnreg,
    "id_lavage": idLavage,
    "nomLavage": nomLavage,
    "situation": situation,
    "admin": admin,
    "status": status,
    "success": success,
    "message": message,
  };
}
