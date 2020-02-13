// To parse this JSON data, do
//
//     final listagentNumTrans = listagentNumTransFromJson(jsonString);

import 'dart:convert';

ListagentNumTrans listagentNumTransFromJson(String str) => ListagentNumTrans.fromJson(json.decode(str));

String listagentNumTransToJson(ListagentNumTrans data) => json.encode(data.toJson());

class ListagentNumTrans {
  Data data;

  ListagentNumTrans({
    this.data,
  });

  factory ListagentNumTrans.fromJson(Map<String, dynamic> json) => ListagentNumTrans(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String nom;
  String contact;
  String contactUrgence;
  String quartier;
  String dateEnreg;
  String idLavage;
  bool success;
  String message;

  Data({
    this.id,
    this.nom,
    this.contact,
    this.contactUrgence,
    this.quartier,
    this.dateEnreg,
    this.idLavage,
    this.success,
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    nom: json["nom"],
    contact: json["contact"],
    contactUrgence: json["contactUrgence"],
    quartier: json["quartier"],
    dateEnreg: json["dateEnreg"],
    idLavage: json["id_lavage"],
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "contact": contact,
    "contactUrgence": contactUrgence,
    "quartier": quartier,
    "dateEnreg": dateEnreg,
    "id_lavage": idLavage,
    "success": success,
    "message": message,
  };
}
