import 'dart:convert';

import 'package:gikuapp/app/config/baseurl.dart';
import 'package:gikuapp/app/model/antrian.dart';
import 'package:gikuapp/app/views/alert/we_alert.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Antrian>> getAntrianByPasien(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/auth/pasien/antrian'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['antrians'] != null) {
          List<Antrian> antrians = List<Antrian>.from(
            responseData['antrians']
                .map((antrianJson) => Antrian.fromJson(antrianJson)),
          );
          return antrians;
        } else {
          throw Exception('Failed to load antrians');
        }
      } else {
        throw Exception(
            'Failed to load antrians with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching antrians: $e');
      throw Exception('Error fetching antrians: $e');
    }
  }

  Future<void> tambahAntrian(
    String token,
    int doctorId,
    String tanggalAntrian,
    int nomorAntrian,
  ) async {
    String apiUrl = '${Config.baseUrl}/api/auth/pasien/antrian/tambah';
    WeAlert.loading();
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'doctor_id': doctorId,
          'tanggal_antrian': tanggalAntrian,
          'nomor_antrian': nomorAntrian,
        }),
      );

      if (response.statusCode == 200) {
        print('Antrian berhasil ditambahkan:');
        WeAlert.close();
        WeAlert.success(description: 'Antrian berhasil ditambahkan');
      } else {
        var errorData = jsonDecode(response.body);
        print('Gagal menambahkan antrian: ${errorData['error']}');
        WeAlert.close();
        WeAlert.error(
            description: 'Gagal menambahkan antrian: ${errorData['error']}');
      }
    } catch (e) {
      print('Error: $e');
      WeAlert.close();
      WeAlert.error(description: 'Error: $e');
    }
  }
}
