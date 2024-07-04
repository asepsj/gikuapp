class Antrian {
  final int id;
  final int pasienId;
  final int doctorId;
  final String namePasien;
  final String nameDoctor;
  final int nomborAntrian;
  final String status;
  final String tanggalAntrian;

  Antrian({
    required this.id,
    required this.pasienId,
    required this.doctorId,
    required this.namePasien,
    required this.nameDoctor,
    required this.nomborAntrian,
    required this.status,
    required this.tanggalAntrian,
  });

  factory Antrian.fromJson(Map<String, dynamic> json) {
    return Antrian(
      id: json['id'],
      pasienId: json['pasien_id'],
      doctorId: json['doctor_id'],
      namePasien: json['name_pasien'],
      nameDoctor: json['name_doctor'],
      nomborAntrian: json['nombor_antrian'],
      status: json['status'],
      tanggalAntrian: json['tanggal_antrian'],
    );
  }
}
