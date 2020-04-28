// To parse this JSON data, do
//
//     final listlogs = listlogsFromJson(jsonString);

import 'dart:convert';

Listlogs listlogsFromJson(String str) => Listlogs.fromJson(json.decode(str));

String listlogsToJson(Listlogs data) => json.encode(data.toJson());

class Listlogs {
  List<Datum> data;

  Listlogs({
    this.data,
  });

  factory Listlogs.fromJson(Map<String, dynamic> json) => Listlogs(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String fenetre;
  String tache;
  String execution;
  String idUser;
  String idLavage;
  DateTime dateEnreg;
  bool success;
  String typeUser;

  Datum({
    this.id,
    this.fenetre,
    this.tache,
    this.execution,
    this.idUser,
    this.idLavage,
    this.dateEnreg,
    this.success,
    this.typeUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    fenetre: json["fenetre"],
    tache: json["tache"],
    execution: json["execution"],
    idUser: json["idUser"],
    idLavage: json["idLavage"],
    dateEnreg: DateTime.parse(json["dateEnreg"]),
    success: json["success"],
    typeUser: json["typeUser"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fenetre": fenetre,
    "tache": tache,
    "execution": execution,
    "idUser": idUser,
    "idLavage": idLavage,
    "dateEnreg": dateEnreg.toIso8601String(),
    "success": success,
    "typeUser": typeUser,
  };
}
