// To parse this JSON data, do
//
//     final modelPegawai = modelPegawaiFromJson(jsonString);

import 'dart:convert';

List<ModelPegawai> modelPegawaiFromJson(String str) => List<ModelPegawai>.from(
    json.decode(str).map((x) => ModelPegawai.fromJson(x)));

String modelPegawaiToJson(List<ModelPegawai> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelPegawai {
  String id;
  String nama;
  String noBp;
  String noHp;
  String email;
  DateTime tanggalInput;

  ModelPegawai({
    required this.id,
    required this.nama,
    required this.noBp,
    required this.noHp,
    required this.email,
    required this.tanggalInput,
  });

  factory ModelPegawai.fromJson(Map<String, dynamic> json) => ModelPegawai(
        id: json["id"],
        nama: json["nama"],
        noBp: json["no_bp"],
        noHp: json["no_hp"],
        email: json["email"],
        tanggalInput: DateTime.parse(json["tanggal_input"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "no_bp": noBp,
        "no_hp": noHp,
        "email": email,
        "tanggal_input": tanggalInput.toIso8601String(),
      };
}
