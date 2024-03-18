import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:frontend/adminpanel.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:frontend/adminprofile.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:velocity_x/velocity_x.dart';

class Registration extends StatefulWidget {
  final token;
  const Registration({@required this.token, Key? key}) : super(key: key);
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController useridController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  bool _isNotValidate = false;
  int _selectedIndex = 0;
  bool _isPasswordVisible = false;
  bool _isRegistered = false;
  void sendRegistrationEmail(
      String userid, String email, String password) async {
    final smtpServer =
        gmail("santusharma1278@gmail.com", "oehc yjfl rbek ayuy");

    // Create the email message
    final message = Message()
      ..from = Address("santusharma1278@gmail.com", "Santu Sharma")
      ..recipients.add('rakshyabastola32@gmail.com')
      ..subject = 'Welcome to Your App!'
      ..text = 'Hello $userid,\n\n'
          'Thank you for registering with Your App!\n\n'
          'Your login credentials:\n'
          'Username: $userid\n'
          'Password: $password\n\n'
          'You can now log in using these credentials.\n  Team , \n Collabnest' ;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  void registerUser() async {
    setState(() {
      _isNotValidate = false; // Reset validation flag
    });

    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        useridController.text.isNotEmpty &&
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
        "userid": useridController.text,
        "password": passwordController.text,
        "fullname": fullnameController.text,
        "organization": organizationController.text,
        "roles":selectedRole
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);
      print('Decoded Response: $jsonResponse');
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

  bool isValidEmail(String email) {
    // Regular expression for a valid email address
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Validate password criteria (e.g., minimum length, at least one number, and one capital letter)
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);

    return password.length >= 8 && hasNumber && hasCapitalLetter;
  }
String selectedRole = 'regular'; // Default role

  List<String> roles = [
    'regular',
    'admin',
    'super admin',
    'project manager',
    'ceo',
    'senior developer',
    'intern',
    'hr'
  ];
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Register User"),
          backgroundColor: Color.fromARGB(255, 150, 125, 241),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Color.fromARGB(255, 203, 194, 236)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HeightBox(10),
              
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
                      errorText: _isNotValidate
                          ? "Email must be entered in abc@xyz.com format"
                          : null,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: useridController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      //    errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "UserID",
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
                        prefixIcon: Icon(Icons.business, color: Colors.grey),
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
                      errorText: _isNotValidate
                          ? (isValidPassword(passwordController.text))
                              ? null
                              : "Password must be of at least 8 characters cosisting of at least one upper character and number"
                          : null,
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
                  ).p4().px24(),SizedBox(height:5,),Container(
                    
  decoration: BoxDecoration(color: Colors.white,
    border: Border.all(
      color: Color.fromARGB(255, 75, 74, 74),
      width: 1.0, // Adjust the width as needed
    ),
    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
  ),child:Column(children:[ SizedBox(child:Padding(padding:EdgeInsets.only(right:150,top:10),child:Text("Select User Role",textAlign:TextAlign.left,))
  ),Container(
    width: 298,decoration:BoxDecoration(color:  Colors.white,borderRadius:BorderRadius.circular(10)),
    child: DropdownButton<String>(
      value: selectedRole,
      onChanged: (String? newValue) {
        setState(() {
          selectedRole = newValue!;
        });
      },
      items: roles.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ).p4().px24(),
  ),])
 
),
                  GestureDetector(
                    onTap: () {
                      registerUser();
                    },
                    child: VxBox(
                      child: "Register".text.black.makeCentered().p16(),
                    )
                        .white
                        .roundedLg
                        .border(
                            color: const Color.fromARGB(255, 238, 236, 236),
                            width: 1.5)
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
