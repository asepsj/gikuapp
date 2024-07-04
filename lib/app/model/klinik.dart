class Klinik {
  int id;
  int userId;
  String namaKlinik;
  String alamatKlinik;
  String deskripsiKlinik;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> photos;

  Klinik({
    required this.id,
    required this.userId,
    required this.namaKlinik,
    required this.alamatKlinik,
    required this.deskripsiKlinik,
    required this.createdAt,
    required this.updatedAt,
    required this.photos,
  });

  factory Klinik.fromJson(Map<String, dynamic> json) => Klinik(
        id: json["id"],
        userId: json["user_id"],
        namaKlinik: json["nama_klinik"],
        alamatKlinik: json["alamat_klinik"],
        deskripsiKlinik: json["deskripsi_klinik"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        photos: List<dynamic>.from(json["photos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nama_klinik": namaKlinik,
        "alamat_klinik": alamatKlinik,
        "deskripsi_klinik": deskripsiKlinik,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "photos": List<dynamic>.from(photos.map((x) => x)),
      };
}
