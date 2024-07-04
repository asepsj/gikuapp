import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gikuapp/app/views/pages/dokter/dokter_detail/dokter_detail.dart';
import 'package:gikuapp/app/views/styles/colors.dart';

class DoctorList extends StatelessWidget {
  final int doctorId;
  final String? imagePath;
  final String text1;
  final String text2;

  const DoctorList({
    Key? key,
    required this.doctorId,
    required this.imagePath,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      height: width * 0.23,
      width: width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.035),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: width * 0.02,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DokterDetail(
                doctorId: doctorId,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.035),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width * 0.23,
                height: height * 0.23,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.035),
                  color: Color(0xFFFE8F8FF),
                ),
                child: Stack(
                  children: [
                    ClipOval(
                      child: BackdropFilter(
                        blendMode: BlendMode.srcOver,
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          width: width * 0.2,
                          height: height * 0.2,
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
                      padding: EdgeInsets.only(top: width * 0.025),
                      child: Center(
                        child: imagePath != null
                            ? Image.network(
                                imagePath!,
                                width: width * 0.2,
                                height: height * 0.2,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person, size: width * 0.1);
                                },
                              )
                            : Icon(Icons.person, size: width * 0.1),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width * 0.7,
                padding: EdgeInsets.all(width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      text1,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.04,
                      ),
                    ),
                    Text(
                      text2,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: width * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
