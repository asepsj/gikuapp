import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gikuapp/app/services/antrian_services.dart';
import 'package:gikuapp/app/views/alert/we_alert.dart';
import 'package:gikuapp/app/views/pages/other/navigation_bar.dart';
import 'package:gikuapp/app/views/pages/schedule/myschedule/myschedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gikuapp/app/views/components/button_date_schedule.dart';
import 'package:gikuapp/app/views/components/button_time_schedule.dart';
import 'package:gikuapp/app/views/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AddScheduleView extends StatefulWidget {
  final int doctorId;
  const AddScheduleView({super.key, required this.doctorId});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? nomorAntrian;
  final ApiService apiService = ApiService();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void addSchedule() async {
    final selectedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );
    final token = await _getToken();
    if (token != null) {
      apiService.tambahAntrian(token, widget.doctorId,
          DateFormat('yyyy-MM-dd').format(selectedDateTime), nomorAntrian!);

      // Menampilkan notifikasi
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Antrian Ditambahkan',
          body:
              'Antrian nomor $nomorAntrian berhasil ditambahkan untuk tanggal ${DateFormat('dd MMM yyyy').format(selectedDateTime)}.',
        ),
      );
    } else {
      print('Token tidak ditemukan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Dokter',
          style: TextStyle(
            fontSize: w * 0.05,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.only(left: w * 0.07),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: w * 0.05,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: w * 0.05, right: w * 0.05, left: w * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: w * 0.23,
                      height: w * 0.23,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.035),
                        color: Color(0xFFFE8F8FF),
                      ),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: BackdropFilter(
                              blendMode: BlendMode.srcOver,
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: w * 0.2,
                                height: h * 0.2,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      blueColor1.withOpacity(0.7),
                                      blueColor1.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: w * 0.025),
                            child: Center(
                              child: Image.asset('assets/other/doktor.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: w * 0.4,
                      padding: EdgeInsets.only(left: w * 0.04, top: w * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. Jenny Wilson',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: w * 0.04,
                            ),
                          ),
                          Text(
                            'Dokter Gigi',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: w * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: w * 0.05),
              Container(
                padding: EdgeInsets.only(top: w * 0.05, left: w * 0.05),
                child: Text(
                  'Tanggal',
                  style: TextStyle(
                    fontSize: w * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: ButtonDateView(
                  onDateSelected: (date) {
                    setState(
                      () {
                        selectedDate = date;
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: w * 0.02, left: w * 0.05),
                child: Text(
                  'Nomor antrian',
                  style: TextStyle(
                    fontSize: w * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(w * 0.05),
                child: Wrap(
                  spacing: w * 0.04, // Spasi antar tombol
                  runSpacing: w * 0.04, // Spasi antar baris tombol
                  children: List.generate(5, (index) {
                    int nomor = index + 1;
                    return ElevatedButton(
                      onPressed: () {
                        setState(
                          () {
                            nomorAntrian = nomor;
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary:
                            nomorAntrian == nomor ? blueColor1 : Colors.white,
                        onPrimary:
                            nomorAntrian == nomor ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(w * 0.09),
                          side: BorderSide(color: greyColor),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.04),
                        child: Text(
                          '$nomor',
                          style: TextStyle(
                            fontSize: w * 0.045,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: w * 0.05, top: w * 0.1),
                child: ElevatedButton(
                  onPressed: selectedDate != null && nomorAntrian != null
                      ? () {
                          addSchedule();
                        }
                      : null,
                  child: Text(
                    'Tambahkan Jadwal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(w * 0.7, w * 0.12),
                    backgroundColor: blueColor1,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
