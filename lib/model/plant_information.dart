// To parse this JSON data, do
//
//     final plantInformation = plantInformationFromJson(jsonString);

import 'dart:convert';

class PlantInformation {
  int id;
  int userId;
  double latitude;
  double longitude;
  String countryName;
  String clubName;
  String plantedAt;
  String createdBy;
  String updatedAt;
  String updatedBy;

  PlantInformation({
    this.id,
    this.userId,
    this.latitude,
    this.longitude,
    this.countryName,
    this.clubName,
    this.plantedAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory PlantInformation.fromJson(String str) => PlantInformation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlantInformation.fromMap(Map<String, dynamic> json) => new PlantInformation(
    id: json["id"] == null ? null : json["id"],
    userId: json["userID"] == null ? null : json["userID"],
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
    countryName: json["countryName"] == null ? null : json["countryName"],
    clubName: json["clubName"] == null ? null : json["clubName"],
    plantedAt: json["plantedAt"] == null ? null : json["plantedAt"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    updatedBy: json["updatedBy"] == null ? null : json["updatedBy"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "userID": userId == null ? null : userId,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "countryName": countryName == null ? null : countryName,
    "clubName": clubName == null ? null : clubName,
    "plantedAt": plantedAt == null ? null : plantedAt,
    "createdBy": createdBy == null ? null : createdBy,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "updatedBy": updatedBy == null ? null : updatedBy,
  };
}
