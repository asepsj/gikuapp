import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gikuapp/app/views/pages/dokter/dokter_list/doctorlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gikuapp/app/model/user.dart';
import 'package:gikuapp/app/config/baseurl.dart';
import 'package:gikuapp/app/services/dokter_services.dart';
import 'package:gikuapp/app/views/styles/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<List<User>>? _futureDoctors;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final token = await _getToken();
    print(token);
    if (token != null && token.isNotEmpty) {
      setState(() {
        _futureDoctors = ApiService().getDoctors(token);
      });
    } else {
      setState(() {
        _futureDoctors = Future.error('Token is null or empty');
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: w,
                height: w * 0.35,
                padding: EdgeInsets.only(left: w * 0.05),
                decoration: BoxDecoration(
                  color: blueColor1,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(w * 0.08),
                    bottomRight: Radius.circular(w * 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi Stiven!',
                      style:
                          TextStyle(color: Colors.white, fontSize: w * 0.045),
                    ),
                    // SizedBox(height: w * 0.015),
                    Text(
                      'Ayo jaga',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.075,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Kebersihan gigimu!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.075,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              SizedBox(height: w * 0.05),
              FutureBuilder<List<User>>(
                future: _futureDoctors,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child:
                            Text('Failed to load doctors: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No doctors found'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        User doctor = snapshot.data![index];
                        return Container(
                          padding: EdgeInsets.only(
                            top: w * 0.05,
                            right: w * 0.02,
                            left: w * 0.02,
                          ),
                          child: DoctorList(
                            doctorId: doctor.id!,
                            imagePath: doctor.fullImagePath,
                            text1: doctor.name ?? 'No Name',
                            text2: doctor.email ?? 'No Email',
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
