import 'package:gikuapp/app/config/baseurl.dart';

class User {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  dynamic foto;
  dynamic deskripsi;
  String alamat;
  String nomorHp;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.foto,
    required this.deskripsi,
    required this.alamat,
    required this.nomorHp,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        foto: json["foto"],
        deskripsi: json["deskripsi"],
        alamat: json["alamat"],
        nomorHp: json["nomor_hp"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "foto": foto,
        "deskripsi": deskripsi,
        "alamat": alamat,
        "nomor_hp": nomorHp,
        "role": role,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  String? get fullImagePath {
    if (foto != null && foto!.isNotEmpty) {
      return '${Config.baseUrl}/storage/fotos/$foto';
    }
    return null;
  }
}
