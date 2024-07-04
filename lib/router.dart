import 'package:flutter/material.dart';
import 'package:gikuapp/app/views/pages/auth/login_page.dart';
import 'package:gikuapp/app/views/pages/auth/sign_up_page.dart';
import 'package:gikuapp/app/views/pages/home/home.dart';
import 'package:gikuapp/app/views/pages/other/navigation_bar.dart';
import 'package:gikuapp/app/views/pages/schedule/myschedule/myschedule.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    // case "/onboarding":
    //   return MaterialPageRoute(builder: (context) => OnboardingPage1());
    case "/auth/login":
      return MaterialPageRoute(builder: (context) => LoginView());
    case "/auth/register":
      return MaterialPageRoute(builder: (context) => RegisterView());
    case "/home":
      return MaterialPageRoute(builder: (context) => HomeView());
    case "/main":
      return MaterialPageRoute(builder: (context) => MainPage());
    case "/SchedulePage":
      return MaterialPageRoute(builder: (context) => MyScheduleView());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Page Name"),
          ),
          body: const Center(child: Text("Page Not found")),
        ),
      );
  }
}
