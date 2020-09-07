// To parse this JSON data, do
//
//     final listCouleurs = listCouleursFromJson(jsonString);

import 'dart:convert';

ListCouleurs listCouleursFromJson(String str) => ListCouleurs.fromJson(json.decode(str));

String listCouleursToJson(ListCouleurs data) => json.encode(data.toJson());

class ListCouleurs {
  List<Datum> data;

  ListCouleurs({
    this.data,
  });

  factory ListCouleurs.fromJson(Map<String, dynamic> json) => ListCouleurs(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String couleur;
  bool success;
  String message;

  Datum({
    this.id,
    this.couleur,
    this.success,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    couleur: json["couleur"],
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "couleur": couleur,
    "success": success,
    "message": message,
  };
}

class Datu2 {
  int id;
  String couleur;

  Datu2({
    this.id,
    this.couleur,

  });

  factory Datu2.fromJson(Map<String, dynamic> json) => Datu2(
    id: json["id"],
    couleur: json["couleur"] as String,

  );

//  Map<String, dynamic> toJson() => {
//    "id": id,
//    "nom": nom,
//  };
}
