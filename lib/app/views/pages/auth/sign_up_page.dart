import 'package:flutter/material.dart';
import 'package:gikuapp/app/views/components/button_component.dart';
import 'package:gikuapp/app/views/components/input_component.dart';
import 'package:gikuapp/app/views/components/input_password_component.dart';
import 'package:gikuapp/app/services/auth_services.dart';
import 'package:gikuapp/app/views/pages/auth/widget/widget_register.dart';
import 'package:gikuapp/app/views/styles/colors.dart';

final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _reenterPasswordController = TextEditingController();
final _phoneController = TextEditingController();

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool passwordVisible = false;
  String _selectedRole = 'Pasien';
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Container(child: WidgetRegister()),
          Positioned(
            top: w * 0.7,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputComponent(
                      labelText: 'Nama',
                      hintText: 'Nama Lengkap',
                      controller: _nameController,
                      icon: Icons.person_outlined,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputComponent(
                      labelText: 'Email',
                      hintText: 'Email',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputComponent(
                      labelText: 'phone',
                      hintText: 'Nomor Handphone',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputPassword(
                      labelText: "Password",
                      hintText: "Password",
                      visible: passwordVisible,
                      controller: _passwordController,
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: InputPassword(
                      labelText: "Reenter Password",
                      hintText: "Reenter Password",
                      controller: _reenterPasswordController,
                      visible: passwordVisible,
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: w * 0.05),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.only(top: w * 0.05),
                    child: ButtonWidget(
                        text: "Daftar",
                        textColor: Colors.white,
                        onClicked: () {
                          Network.signUp(
                            context: context,
                            username: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            password: _passwordController.text,
                          );
                        }),
                  ),
                  //   SizedBox(height: w * 0.05),
                  //   Container(
                  //     child: RichText(
                  //       text: TextSpan(
                  //         children: [
                  //           WidgetSpan(
                  //             child: Text(
                  //               'Sudah memiliki akun?',
                  //               style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: w * 0.035,
                  //                   fontWeight: FontWeight.w500),
                  //             ),
                  //           ),
                  //           WidgetSpan(
                  //             child: Padding(
                  //               padding: EdgeInsets.only(left: w * 0.01),
                  //               child: InkWell(
                  //                   onTap: () {
                  //                     Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: (context) => LoginView()),
                  //                     );
                  //                   },
                  //                   child: Text(
                  //                     'Masuk',
                  //                     style: TextStyle(
                  //                         color: Colors.black,
                  //                         fontSize: w * 0.035,
                  //                         fontWeight: FontWeight.w700),
                  //                   )),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
