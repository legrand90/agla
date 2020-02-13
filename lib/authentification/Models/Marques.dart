// To parse this JSON data, do
//
//     final listMarques = listMarquesFromJson(jsonString);

import 'dart:convert';

ListMarques listMarquesFromJson(String str) => ListMarques.fromJson(json.decode(str));

String listMarquesToJson(ListMarques data) => json.encode(data.toJson());

class ListMarques {
  List<Datum> data;

  ListMarques({
    this.data,
  });

  factory ListMarques.fromJson(Map<String, dynamic> json) => ListMarques(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String marque;
  bool success;
  String message;

  Datum({
    this.id,
    this.marque,
    this.success,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    marque: json["marque"],
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "marque": marque,
    "success": success,
    "message": message,
  };
}
