import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

import 'loginPage.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  bool _isNotValidate = false;
  bool _isPasswordVisible = false;
  bool _isRegistered = false;
  void registerUser() async {
  setState(() {
    _isNotValidate = false; // Reset validation flag
  });

  if (emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      usernameController.text.isNotEmpty &&
      fullnameController.text.isNotEmpty &&
      organizationController.text.isNotEmpty) {

    bool isEmailValid = isValidEmail(emailController.text);
    bool isPasswordValid = isValidPassword(passwordController.text);

    if (!isEmailValid || !isPasswordValid) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    var regBody = {
      "email": emailController.text,
      "username": usernameController.text,
      "password": passwordController.text,
      "fullname": fullnameController.text,
      "organization": organizationController.text
    };

    var response = await http.post(Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if (jsonResponse['status']) {
      setState(() {
        print(jsonResponse);
        _isRegistered = true;
      });
    } else {
      print("Something Went Wrong");
    }
  } else {
    setState(() {
      _isNotValidate = true;
    });
  }
}

/*
 void registerUser() async {
  setState(() {
    _isNotValidate = false; // Reset validation flag
  });

  if (emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      usernameController.text.isNotEmpty &&
      fullnameController.text.isNotEmpty &&
      organizationController.text.isNotEmpty) {
    if (!isValidEmail(emailController.text)) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    if (!isValidPassword(passwordController.text)) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    var regBody = {
      "email": emailController.text,
      "username": usernameController.text,
      "password": passwordController.text,
      "fullname": fullnameController.text,
      "organization": organizationController.text
    };

    var response = await http.post(Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if (jsonResponse['status']) {
      setState(() {
        print(jsonResponse);
        _isRegistered = true;
      });
    } else {
      print("Something Went Wrong");
    }
  } else {
    setState(() {
      _isNotValidate = true;
    });
  }
}*/

  bool isValidEmail(String email) {
  // Regular expression for a valid email address
  final emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}
bool isValidPassword(String password) {
  // Validate password criteria (e.g., minimum length, at least one number, and one capital letter)
  final hasNumber = RegExp(r'\d').hasMatch(password);
  final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);

  return password.length >= 8 && hasNumber && hasCapitalLetter;
}



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color:  Color.fromARGB(255, 150, 125, 241)
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HeightBox(10),
                  "CREATE YOUR ACCOUNT".text.size(22).yellow100.make(),
                  SizedBox(height: 20),
                  TextField(
                    controller: fullnameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                    //  errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "Full name",
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Email must be entered in abc@xyz.com format" : null,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                  //    errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: organizationController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                  //    errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "Organization",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? (isValidPassword(passwordController.text))? null:"Password must be of at least 8 characters cosisting of at least one upper character and number":null ,
                      hintText: "Password",
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  GestureDetector(
                    onTap: () {
                      registerUser();
                    },
                    child: VxBox(
                      child: "Register".text.black.makeCentered().p16(),
                    )
                        .white
                        .roundedLg
                        .border(color: const Color.fromARGB(255, 238, 236, 236), width: 1.5)
                        .width(300)
                        .make()
                        .px16()
                        .py16(),
                  ),
                  if (_isRegistered)
                    
                      Card(
                        color: Colors.green,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          title: "Successfully Registered!".text.white.make(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        child: HStack([
                          "Already Registered?".text.make(),
                          " Sign In".text.white.make()
                        ]).centered(),
                      )
                    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';

  String password = '';

  int passLength = 20;

  String seed = upper + lower + numbers + symbols;

  List<String> list = seed.split('').toList();

  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}
