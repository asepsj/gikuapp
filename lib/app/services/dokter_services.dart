import 'package:dio/dio.dart';
import 'package:gikuapp/app/model/klinik.dart';
import 'package:gikuapp/app/model/user.dart';
import 'package:gikuapp/app/config/baseurl.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<User>> getDoctors(String token) async {
    if (token.isEmpty) {
      print('Token is empty');
      throw Exception('Token is empty');
    }

    try {
      final response = await _dio.get(
        '${Config.baseUrl}/api/pasien/doctors',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          if (responseData['data'] is List) {
            List<User> doctors = (responseData['data'] as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();
            return doctors;
          } else {
            print('Unexpected response format: data is not a list');
            throw Exception('Unexpected response format: data is not a list');
          }
        } else {
          print('Unexpected response format: $responseData');
          throw Exception('Unexpected response format');
        }
      } else {
        print('Failed to load doctors: ${response.statusCode}');
        print('Response: ${response.data}');
        throw Exception(
            'Failed to load doctors with status code ${response.statusCode}');
      }
    } on DioError catch (dioError) {
      print('Dio error during fetching doctors: ${dioError.message}');
      if (dioError.response != null) {
        print('Response: ${dioError.response!.data}');
        throw Exception(
            'Failed to load doctors: ${dioError.response!.statusCode} ${dioError.response!.statusMessage}');
      } else {
        throw Exception('Error during fetching doctors: ${dioError.message}');
      }
    } catch (e) {
      print('Unknown error during fetching doctors: $e');
      throw Exception('Unknown error during fetching doctors: $e');
    }
  }

  Future<User> GetDokterId(int doctorId, String token) async {
    try {
      // Buat instance Dio dengan konfigurasi default
      Dio dio = Dio(
        BaseOptions(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      Response response =
          await dio.get('${Config.baseUrl}/api/pasien/dokter/$doctorId');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load clinic');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Klinik> fetchKlinik(int doctorId, String token) async {
    try {
      // Buat instance Dio dengan konfigurasi default
      Dio dio = Dio(BaseOptions(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ));

      // Lakukan permintaan GET ke endpoint yang sesuai
      Response response =
          await dio.get('${Config.baseUrl}/api/doctors/$doctorId/clinics');

      if (response.statusCode == 200) {
        // Jika permintaan berhasil, konversi respons JSON menjadi objek Klinik
        return Klinik.fromJson(response.data);
      } else {
        // Jika terjadi kesalahan lainnya, tangani sesuai kebutuhan aplikasi Anda
        throw Exception('Failed to load clinic');
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau lainnya di sini
      throw Exception('Network error: $e');
    }
  }
}
