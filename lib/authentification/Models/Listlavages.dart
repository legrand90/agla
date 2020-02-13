// To parse this JSON data, do
//
//     final listlavages = listlavagesFromJson(jsonString);

import 'dart:convert';

Listlavages listlavagesFromJson(String str) => Listlavages.fromJson(json.decode(str));

String listlavagesToJson(Listlavages data) => json.encode(data.toJson());

class Listlavages {
  List<Datum> data;

  Listlavages({
    this.data,
  });

  factory Listlavages.fromJson(Map<String, dynamic> json) => Listlavages(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String libelleLavage;
  String situationGeo;
  String dateEnreg;
  bool success;

  Datum({
    this.id,
    this.libelleLavage,
    this.situationGeo,
    this.dateEnreg,
    this.success,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    libelleLavage: json["libelle_lavage"],
    situationGeo: json["situation_geo"],
    dateEnreg: json["dateEnreg"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle_lavage": libelleLavage,
    "situation_geo": situationGeo,
    "dateEnreg": dateEnreg,
    "success": success,
  };
}


class Datux {
  int id;
  String libelleLavage;

  Datux({
    this.id,
    this.libelleLavage,

  });

  factory Datux.fromJson(Map<String, dynamic> json) => Datux(
    id: json["id"],
    libelleLavage: json["libelle_lavage"] as String,

  );

}
