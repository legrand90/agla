// To parse this JSON data, do
//
//     final listsoldes = listsoldesFromJson(jsonString);

import 'dart:convert';

Listsoldes listsoldesFromJson(String str) => Listsoldes.fromJson(json.decode(str));

String listsoldesToJson(Listsoldes data) => json.encode(data.toJson());

class Listsoldes {
  List<Datum> data;

  Listsoldes({
    this.data,
  });

  factory Listsoldes.fromJson(Map<String, dynamic> json) => Listsoldes(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String montant;
  String dateEnreg;
  String idAgent;
  String idUser;
  String idLavage;

  Datum({
    this.id,
    this.montant,
    this.dateEnreg,
    this.idAgent,
    this.idUser,
    this.idLavage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    montant: json["montant"],
    dateEnreg: json["dateEnreg"],
    idAgent: json["id_agent"],
    idUser: json["id_user"],
    idLavage: json["id_lavage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "montant": montant,
    "dateEnreg": dateEnreg,
    "id_agent": idAgent,
    "id_user": idUser,
    "id_lavage": idLavage,
  };
}
