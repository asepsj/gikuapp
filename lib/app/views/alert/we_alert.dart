import 'package:flutter/material.dart';
import 'package:gikuapp/app/views/components/custom_button.dart';
import 'package:gikuapp/app/views/styles/colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class WeAlert {
  static loading() {
    return showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        final w = MediaQuery.of(context).size.width;
        return WillPopScope(
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Center(
              child: Container(
                height: w * 0.5,
                width: w * 0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: white,
                ),
                child: CircularProgressIndicator(
                  color: blueColor1,
                ),
              ),
            ),
          ),
          onWillPop: () async {
            return false;
          },
        );
      },
    );
  }

  static error({String? description}) {
    showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: true,
      builder: (context) {
        final w = MediaQuery.of(context).size.width;
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Center(
            child: Container(
              height: w * 0.7,
              width: w * 0.75,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: w * 0.15,
                    child: Image.asset('assets/allert/error.png'),
                  ),
                  Text(
                    "Gagal",
                    style: TextStyle(
                      color: redColor,
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.08,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    width: w * 0.55,
                    child: Text(
                      description ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: w * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: w * 0.06),
                  CustomButton(
                    buttonColor: redColor,
                    title: "Oke",
                    onTap: () {
                      close();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static success({String? description}) {
    return showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: true,
      builder: (context) {
        final w = MediaQuery.of(context).size.width;
        return AlertDialog(
          icon: Icon(Icons.access_alarm),
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Center(
            child: Container(
              height: w * 0.7,
              width: w * 0.75,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: w * 0.15,
                    child: Image.asset('assets/allert/success.png'),
                  ),
                  Text(
                    "Berhasil",
                    style: TextStyle(
                      color: successColor,
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.08,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    width: w * 0.55,
                    child: Text(
                      description ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: w * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: w * 0.06),
                  CustomButton(
                    buttonColor: successColor,
                    title: "Oke",
                    onTap: () {
                      close();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static close() {
    navigatorKey.currentState!.pop();
  }
}
