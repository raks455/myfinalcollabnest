import 'dart:convert';
import 'package:frontend/adminpanel.dart';
import 'package:frontend/config.dart';
import 'package:http/http.dart'as http;
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:frontend/aboutapp.dart';
import 'package:frontend/aboutus.dart';
import 'package:frontend/contactus.dart';
import 'package:frontend/loginPage.dart';
import 'package:frontend/team.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Menupage extends StatefulWidget {
  final token;
  const Menupage({@required this.token, Key? key}) : super(key: key);

  @override
  State<Menupage> createState() => _MenupageState();
}

class Menu {
  const Menu({required this.title});
  final String title;

  @override
  String toString() => title;
}

const List<Menu> menu = const <Menu>[
  const Menu(title: 'About App'),
  const Menu(title: 'About Us'),
  const Menu(title:'Team'),
  const Menu(title:'Contact Us')
];

class _MenupageState extends State<Menupage> {
  late String userId;
  late String userName;
  late String fullname;
  late String organization;
  late String userEmail;
  int taskCount = 0;
  List<String> projects = [];

  @override
  void initState() {
    super.initState();
    Map<String, dynamic>? jwtDecodedToken = JwtDecoder.decode(widget.token);

    if (jwtDecodedToken != null) {
      userId = jwtDecodedToken['_id'] ?? '';
      userName = jwtDecodedToken['username'] ?? '';
      userEmail = jwtDecodedToken['email'] ?? '';
      organization = jwtDecodedToken['organization'] ?? '';
      fullname = jwtDecodedToken['fullname'] ?? '';
    } else {
      userId = '';
      userName = '';
      userEmail = '';
      organization = '';
      fullname = '';
    }

    taskCount = 3;
    projects = ["Make Button"];
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
   void _onMenuItemSelected(Menu selectedMenu) {
    if (selectedMenu.title == 'About App') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutApp()),
      );
    } else if (selectedMenu.title == 'About Us') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUs()),
      );
    }
    else if (selectedMenu.title == 'Team') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Team()),
      );
    }
    else if (selectedMenu.title == 'Contact Us') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactUs()),
      );
    }
  }
  void _deleteAccount() async {
    try {
      // Implement the API call to delete the user account using the user's ID (userId)
    
      var response = await http.delete(
        Uri.parse(deleteUser),
        headers: {"Content-Type": "application/json"},
        
      );
 
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
       
        _logout(); 
      } else {
    
        print('Failed to delete account');
      }
    } catch (error) {
      print('Error deleting account: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 150, 125, 241),
          title: Text("Profile"),
          actions: [
          
                PopupMenuButton<Menu>(itemBuilder:(BuildContext context){
                  return menu.map((Menu menu){
                    return PopupMenuItem<Menu>(value:menu,child:Text(menu.title));
                  }).toList();
                },onSelected:_onMenuItemSelected
                ),
          ]),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),

         Center(
            widthFactor: 320,
            child: Container(
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 224, 114, 197),
                  onPrimary: Colors.black12,
                  minimumSize: Size(300, 50),
                ),
                onPressed: _logout,
                child: Text('Log out', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          
                Container(
                    height: 470,
                    width: MediaQuery.of(context).size.width * 2,
                    padding: EdgeInsets.only(top: 20, left: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color.fromARGB(255, 186, 162, 235),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: ClipOval(
                                child: Container(
                                    width: 80.0,
                                    height: 80.0,
                                    color: Colors.white,
                                    child: /* Replace this with your image widget */
                                        Image.network(
                                            "https://imgs.search.brave.com/yoPGy4_1Imz6F4qYC28dkah9LiUaiSQKXsa2U6TrrxA/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9idXJz/dC5zaG9waWZ5Y2Ru/LmNvbS9waG90b3Mv/d29tYW4taW4tZmxv/d2VyLWJsb3Nzb21z/LmpwZz93aWR0aD0x/MDAwJmZvcm1hdD1w/anBnJmV4aWY9MCZp/cHRjPTA")),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            "@" + userName,
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.blueGrey),
                          ),
                        ),
                        Center(
                          child: Text(
                            fullname,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 150, 125, 241),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            width: 270,
                            height: 120,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(children: [
                              Column(
                                children: [
                                  Text("Email:",
                                      style: TextStyle(color: Colors.black54)),
                                  Text(userEmail)
                                ],
                              ),
                              Divider(height: 10),
                              Column(
                                children: [
                                  Text("Organization:",
                                      style: TextStyle(color: Colors.black54)),
                                  Text(organization)
                                ],
                              )
                            ]),
                            padding: EdgeInsets.only(top: 20)),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 224, 114, 197),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            width: 270,
                            height: 120,
                            padding: EdgeInsets.only(top: 20, right: 0),
                            margin: EdgeInsets.only(top: 10),
                            child: Column(children: [
                              Column(
                                children: [
                                  Text("Projects:",
                                      style: TextStyle(color: Colors.black54)),
                                  Text('$projects')
                                ],
                              ),
                              Divider(height: 10),
                              Column(children: [
                                Text(
                                  "Tasks",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(" Pending:$taskCount ")
                              ])
                            ])),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(height: 25),
          Center(
            widthFactor: 320,
            child: Container(
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 224, 114, 197),
                  onPrimary: Colors.black12,
                  minimumSize: Size(300, 50),
                ),
                onPressed: _logout,
                child: Text('Log out', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
