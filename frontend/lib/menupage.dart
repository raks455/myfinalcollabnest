import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/loginPage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Menupage extends StatefulWidget {
  final token;
  const Menupage({@required this.token, Key? key}) : super(key: key);

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  late String userId;
  late String userName;
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
    } else {
      userId = '';
      userName = '';
      userEmail = '';
    }

    taskCount = 3;
    projects = ['Make Button'];
  }
 void _logout() {
    // Implement any logout logic if needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Text(
                        userName,
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'User Profile',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    "Email :" + userName,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Center(
                  child: Text(
                    "Email :" + userEmail,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    '$taskCount Tasks',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 5.0),
                Center(
                  child: Text(
                    'Projects: ${projects.join(", ")}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child:ElevatedButton(
                      onPressed: _logout,
                      child: Text('Logout'),
                    ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
