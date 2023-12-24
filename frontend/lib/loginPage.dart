// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:frontend/adminlogin.dart';
// import 'package:frontend/adminpanel.dart';
// import 'package:frontend/forgotpasswordpage.dart';
// import 'home.dart';
// import 'registration.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:http/http.dart' as http;
// import 'config.dart';

// class SignInPage extends StatefulWidget {
//   @override
//   _SignInPageState createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController useridController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool _isNotValidate = false;
//   late SharedPreferences prefs;
//   bool _isPasswordVisible = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initSharedPref();
//   }

//   void initSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//   }

//   void loginUser() async {
//     if (emailController.text.isNotEmpty &&
//         passwordController.text.isNotEmpty &&
//         useridController.text.isNotEmpty) {
//       var reqBody = {
//         "email": emailController.text,
//        "userid": useridController.text,
//         "password": passwordController.text
//       };

//       var response = await http.post(Uri.parse(adminlogin),
//           headers: {"Content-Type": "application/json"},
//           body: jsonEncode(reqBody));

//       var jsonResponse = jsonDecode(response.body);
//       if (jsonResponse['status']) {
//         var token = jsonResponse['token'];
//         prefs.setString('token', token);
//         if (isAuthorizedUser(emailController.text, passwordController.text,useridController.text)) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => AdminPanelScreen(token: token)));
//         } else {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => HomeScreen(
//                         token: token,
//                       )));
//         }
//       } else {
//         print('Something went wrong');
//       }
//     }
//   }

//   bool isAuthorizedUser(String email, String password,String userid) {
//     const String adminEmail = 'admin@example.com';
//     const String adminPassword = 'adminPassword12';
//         const String adminId = 'admin12@';
//     bool res1 = email == adminEmail && password == adminPassword;

//     return res1 && userid== adminId;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             color: Color.fromARGB(255, 150, 125, 241),
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 16,
//                 right: 16,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => AdminLogin()),
//                     );
//                   },
//                   child: VxBox(
//                     child: Column(
//                       children: [Icon(Icons.person), Text("Admin")],
//                     ),
//                   )
//                       .white
//                       .square(50)
//                       .border(
//                         color: const Color.fromARGB(255, 241, 240, 240),
//                         width: 1.1,
//                       )
//                       .width(90)
//                       .rounded
//                       .make()
//                       .px(16)
//                       .py(16),
//                 ),
//               ),
//               Center(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       HeightBox(10),
//                       "User Sign-In".text.size(22).yellow100.make(),
//                       SizedBox(height: 20),
//                       TextField(
//                         controller: emailController,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintText: "Email",
//                           errorText:
//                               _isNotValidate ? "Enter Proper Info" : null,
//                           prefixIcon: Icon(Icons.email, color: Colors.grey),
//                           border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                         ),
//                       ).p4().px24(),
//                       TextField(
//                         controller: useridController,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintText: "UserID",
//                           errorText:
//                               _isNotValidate ? "Enter Proper Info" : null,
//                           prefixIcon: Icon(Icons.email, color: Colors.grey),
//                           border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                         ),
//                       ).p4().px24(),
//                       TextField(
//                         controller: passwordController,
//                         obscureText: !_isPasswordVisible,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintText: "Password",
//                           errorText:
//                               _isNotValidate ? "Enter Proper Info" : null,
//                           prefixIcon: Icon(Icons.lock, color: Colors.grey),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                         ),
//                       ).p4().px24(),
//                       GestureDetector(
//                         onTap: () {
//                           loginUser();
//                         },
//                         child: HStack([
//                           VxBox(
//                             child: "Login".text.black.makeCentered().p16(),
//                           )
//                               .white
//                               .roundedLg
//                               .border(
//                                   color:
//                                       const Color.fromARGB(255, 241, 240, 240),
//                                   width: 1.5)
//                               .width(300)
//                               .make()
//                               .px(16)
//                               .py(16),
//                         ]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/adminlogin.dart';
import 'package:frontend/adminpanel.dart';
import 'package:frontend/config.dart';
import 'package:frontend/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  TextEditingController useridController = TextEditingController();

  bool _isNotValidate = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        useridController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "userid": useridController.text,
        "password": passwordController.text
      };

      var response = await http.post(
        Uri.parse(adminlogin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var token = jsonResponse['token'];
        prefs.setString('token', token);

        if (isAuthorizedUser(
          emailController.text,
          passwordController.text,
          useridController.text,
        )) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPanelScreen(token: token),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(token: token),
            ),
          );
        }
      } else {
        print('Invalid credentials');
      }
    }
  }

  bool isAuthorizedUser(String email, String password, String userid) {
    const String adminEmail = 'admin@example.com';
    const String adminPassword = 'adminPassword12';
    const String adminId = 'admin12@';
    return email == adminEmail && password == adminPassword && userid == adminId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 150, 125, 241),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLogin()),
                    );
                  },
                  child: VxBox(
                    child: Column(
                      children: [Icon(Icons.person), Text("Admin")],
                    ),
                  )
                      .white
                      .square(50)
                      .border(
                        color: const Color.fromARGB(255, 241, 240, 240),
                        width: 1.1,
                      )
                      .width(90)
                      .rounded
                      .make()
                      .px(16)
                      .py(16),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      HeightBox(10),
                      "User Sign-In".text.size(22).yellow100.make(),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Email",
                          errorText:
                              _isNotValidate ? "Enter Proper Info" : null,
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ).p4().px24(),
                      TextField(
                        controller: useridController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "UserID",
                          errorText:
                              _isNotValidate ? "Enter Proper Info" : null,
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ).p4().px24(),
                      TextField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
                          errorText:
                              _isNotValidate ? "Enter Proper Info" : null,
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ).p4().px24(),
                      GestureDetector(
                        onTap: () {
                          loginUser();
                        },
                        child: HStack([
                          VxBox(
                            child: "Login".text.black.makeCentered().p16(),
                          )
                              .white
                              .roundedLg
                              .border(
                                  color:
                                      const Color.fromARGB(255, 241, 240, 240),
                                  width: 1.5)
                              .width(300)
                              .make()
                              .px(16)
                              .py(16),
                        ]),
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
