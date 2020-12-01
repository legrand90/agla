// To parse this JSON data, do
//
//     final listdepense = listdepenseFromJson(jsonString);

import 'dart:convert';

Listdepense listdepenseFromJson(String str) => Listdepense.fromJson(json.decode(str));

String listdepenseToJson(Listdepense data) => json.encode(data.toJson());

class Listdepense {
  Listdepense({
    this.data,
  });

  List<Datum> data;

  factory Listdepense.fromJson(Map<String, dynamic> json) => Listdepense(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.libelleDepense,
    this.quantite,
    this.prixUnitaire,
    this.dateEnreg,
    this.idLavage,
    this.prixTotal,
  });

  int id;
  String libelleDepense;
  String quantite;
  String prixUnitaire;
  DateTime dateEnreg;
  String idLavage;
  String prixTotal;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    libelleDepense: json["libelle_depense"],
    quantite: json["quantite"],
    prixUnitaire: json["prixUnitaire"],
    dateEnreg: DateTime.parse(json["dateEnreg"]),
    idLavage: json["id_lavage"],
    prixTotal: json["prixTotal"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle_depense": libelleDepense,
    "quantite": quantite,
    "prixUnitaire": prixUnitaire,
    "dateEnreg": dateEnreg.toIso8601String(),
    "id_lavage": idLavage,
    "prixTotal": prixTotal,
  };
}
