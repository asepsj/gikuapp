import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gikuapp/app/views/alert/we_alert.dart';
import 'package:gikuapp/app/model/user.dart';
import 'package:gikuapp/app/config/baseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Network {
  static Future<void> signUp({
    required BuildContext context,
    String? username,
    String? password,
    String? email,
    String? phone,
  }) async {
    try {
      WeAlert.loading();

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "name_pasien": username,
            "email_pasien": email,
            "nomor_hp": phone,
            "password": password,
          },
        ),
      );

      if (response.statusCode == 200) {
        WeAlert.close();
        WeAlert.success(description: "You have created a new account");
        // Navigate to login page
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/auth/login', (route) => false);
        print("success");
      } else {
        WeAlert.close();
        WeAlert.error(description: "Registration failed");
        print("fail");
      }
    } catch (error) {
      // Handle exceptions if any
      print("Error during registration: $error");
      WeAlert.close();
      WeAlert.error(description: "An error occurred during registration");
    }
  }

  static Future<void> login({
    required BuildContext context,
    String? email,
    String? password,
  }) async {
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      WeAlert.error(description: "Silahkan isi formulir dengan benar");
      return;
    }

    try {
      WeAlert.loading();

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "email_pasien": email,
            "password": password,
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        WeAlert.close();
        WeAlert.success(description: "You have successfully logged in");
        final data = json.decode(response.body);
        final token = data['data']['token'];

        final prefs = await SharedPreferences.getInstance();
        if (token != null && token is String) {
          await prefs.setString('token', token);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/main', (route) => false);
          print("success");
        } else {
          print("Token is null or not a string");
          WeAlert.error(description: "Login failed: invalid token");
        }
      } else {
        WeAlert.close();
        final data = json.decode(response.body);
        final errorMessage = data['error'] ?? 'Login failed';
        WeAlert.error(description: errorMessage);
        print("fail");
      }
    } catch (error) {
      print("Error during login: $error");
      WeAlert.close();
      WeAlert.error(description: 'Please enter the correct details');
    }
  }

  static Future<void> signOut(String token) async {
    try {
      WeAlert.loading();

      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        WeAlert.close();
        WeAlert.success(description: "You have successfully logged out");
        print("Success: ${response.body}");
      } else {
        WeAlert.close();
        WeAlert.error(description: "Logout failed: ${response.reasonPhrase}");
        print("Failed: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (error) {
      WeAlert.close();
      WeAlert.error(description: "An error occurred during logout");
      print("Error during logout: $error");
    }
  }
}
