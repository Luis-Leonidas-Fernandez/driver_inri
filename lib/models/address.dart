// To parse this JSON data, do
//
//     final addressResp = addressRespFromMap(jsonString);

import 'dart:convert';

class AddressResponse {
    AddressResponse({
        required this.address,
    });

    List<Address> address;

    factory AddressResponse.fromJson(String str) => AddressResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddressResponse.fromMap(Map<String, dynamic> json) => AddressResponse(
        address: List<Address>.from(json["address"].map((x) => Address.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "address": List<dynamic>.from(address.map((x) => x.toMap())),
    };
}

class Address {
    Address({
        this.id,
        this.nombre,
        this.email,
        this.online,
        this.estado,
        this.ubicacion,
        this.createdAt,
        this.updatedAt,
        this.idDriver,
    });

    String? id;
    String? nombre;
    String? email;
    bool? online;
    bool? estado;
    List<double>? ubicacion;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? idDriver;

    factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["_id"] ?? '',
        nombre: json["nombre"] ?? '',
        email: json["email"] ?? '',
        online: json["online"] ?? '',
        estado: json["estado"] ?? '',
        ubicacion: json["ubicacion"] == null ? null : List<double>.from(json["ubicacion"].map((x) => x.toDouble())),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        idDriver: json["idDriver"]?? '',
    );

    Map<String, dynamic> toMap() => {
        "idOrder": id,
        "nombre": nombre,
        "email": email,
        "online": online,
        "estado": estado,
        "ubicacion": List<dynamic>.from(ubicacion!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "idDriver": idDriver,
    };
}
