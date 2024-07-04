import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gikuapp/app/model/klinik.dart';
import 'package:gikuapp/app/model/user.dart';
import 'package:gikuapp/app/services/dokter_services.dart';
import 'package:gikuapp/app/views/pages/schedule/addSchedule/add_schedule.dart';
import 'package:gikuapp/app/views/styles/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DokterDetail extends StatefulWidget {
  final int doctorId;
  const DokterDetail({
    super.key,
    required this.doctorId,
  });

  @override
  State<DokterDetail> createState() => _DokterDetailState();
}

class _DokterDetailState extends State<DokterDetail> {
  Future<User>? _GetDokter;
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _GetDokterId() async {
    final token = await _getToken();
    print(token);
    if (token != null && token.isNotEmpty) {
      try {
        final dokter = await ApiService().GetDokterId(widget.doctorId, token);
        setState(() {
          _GetDokter = Future.value(dokter);
        });
      } catch (e) {
        setState(() {
          _GetDokter = Future.error('Failed to load clinic: $e');
        });
      }
    } else {
      setState(
        () {
          _GetDokter = Future.error('Token is null or empty');
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _GetDokterId();
  }

  final List<Map<String, String>> schedule = [
    {'day': 'Senin', 'time': '00.00 - 00.00'},
    {'day': 'Selasa', 'time': '01.00 - 02.00'},
    {'day': 'Rabu', 'time': '03.00 - 04.00'},
    {'day': 'Kamis', 'time': '05.00 - 06.00'},
    {'day': 'Jumat', 'time': '07.00 - 08.00'},
  ];
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder<User>(
        future: _GetDokter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final dokter = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  leading: Container(
                    padding: EdgeInsets.only(left: w * 0.025, top: w * 0.025),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: false,
                  expandedHeight: w * 0.9,
                  flexibleSpace: Container(
                    padding: EdgeInsets.only(top: w * 0.19),
                    child: FlexibleSpaceBar(
                      background: Image(
                        image: AssetImage('assets/other/doktor.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(w * 0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(w * 0.08),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: w * 0.08, left: w * 0.08, right: w * 0.08),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                dokter.name ?? "-",
                                style: TextStyle(
                                  fontSize: w * 0.065,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                dokter.email ?? "-",
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Divider(
                              height: w * 0.05,
                            ),
                            SizedBox(height: w * 0.07),
                            Container(
                              child: Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: ExpandableText(
                                dokter.deskripsi ?? "-",
                                expandText: 'selengkapnya',
                                collapseText: 'Read Less',
                                linkColor: blueColor1,
                                textAlign: TextAlign.justify,
                                maxLines: 5,
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Container(
                              child: Text(
                                'Jadwal',
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...schedule.map(
                              (item) => Container(
                                child: Text(
                                  '${item['day']} : ${item['time']}',
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: w * 0.05),
                            Container(
                              child: Text(
                                'Lokasi',
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                dokter.alamat,
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: Container(
        height: w * 0.15,
        child: Center(
          child: SizedBox(
            width: w * 0.9,
            height: w * 0.1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddScheduleView(
                      doctorId: widget.doctorId,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.05),
                ),
              ),
              child: Text(
                'Buat Antrian',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
