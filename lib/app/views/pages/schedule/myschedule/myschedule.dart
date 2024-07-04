import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gikuapp/app/model/antrian.dart';
import 'package:gikuapp/app/services/antrian_services.dart';
import 'package:gikuapp/app/views/pages/other/schedule_list.dart';
import 'package:gikuapp/app/views/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyScheduleView extends StatefulWidget {
  const MyScheduleView({Key? key}) : super(key: key);

  @override
  State<MyScheduleView> createState() => _MyScheduleViewState();
}

class _MyScheduleViewState extends State<MyScheduleView>
    with SingleTickerProviderStateMixin {
  Future<List<Antrian>>? _antrian;
  final ApiService apiService = ApiService();
  late TabController _tabController;
  final _selectedColor = Colors.black;
  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [
    Tab(text: 'Selesai'),
    Tab(text: 'Berlangsung'),
  ];

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _getAntrian() async {
    final token = await _getToken();
    print(token);
    if (token != null && token.isNotEmpty) {
      setState(() {
        _antrian = apiService.getAntrianByPasien(token);
      });
    } else {
      setState(() {
        _antrian = Future.error('Token is null or empty');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAntrian();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(w * 0.1),
            bottomRight: Radius.circular(w * 0.1),
          ),
        ),
        title: Text(
          'Riwayat antrian',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.045,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: blueColor1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        padding: EdgeInsets.only(top: w * 0.035),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: _tabs,
              labelColor: _selectedColor,
              indicatorColor: _selectedColor,
              unselectedLabelColor: _unselectedColor.withOpacity(0.3),
              dividerColor: _unselectedColor.withOpacity(0.2),
              dividerHeight: w * 0.005,
              indicatorWeight: w * 0.005,
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.04),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: FutureBuilder<List<Antrian>>(
                      future: _antrian,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Failed to load antrian: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No antrian found'));
                        } else {
                          List<Antrian> filteredList = snapshot.data!.where(
                            (antrian) {
                              return antrian.status == 'batal' ||
                                  antrian.status == 'selesai';
                            },
                          ).toList();
                          if (filteredList.isEmpty) {
                            return Center(
                              child: Text(
                                'Tidak ada antrian',
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              Antrian antrian = filteredList[index];
                              return Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03),
                                child: ScheduleList(
                                  imagePath: "imagePath",
                                  text1: antrian.nameDoctor,
                                  text2: antrian.tanggalAntrian,
                                  text3: antrian.status,
                                  status: antrian.status,
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  FutureBuilder<List<Antrian>>(
                    future: _antrian,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Failed to load antrian: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No antrian found'));
                      } else {
                        // Filter the list based on status
                        List<Antrian> filteredList = snapshot.data!.where(
                          (antrian) {
                            return antrian.status == 'berlangsung' ||
                                antrian.status == 'dibuat';
                          },
                        ).toList();
                        if (filteredList.isEmpty) {
                          return Center(
                            child: Text(
                              'Tidak ada antrian',
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            Antrian antrian = filteredList[index];
                            return Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.03),
                              child: ScheduleList(
                                imagePath: "imagePath",
                                text1: antrian.nameDoctor,
                                text2: antrian.tanggalAntrian,
                                text3: antrian.status,
                                status: antrian.status,
                              ),
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
