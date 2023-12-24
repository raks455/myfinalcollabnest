
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/registration.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:frontend/config.dart';
import 'package:frontend/updateuserscreen.dart';
import 'package:frontend/userlistwidget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart'as http;
class AdminPanelScreen extends StatefulWidget {
  final token;

  const AdminPanelScreen({@required this.token, Key? key}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late Future<List<dynamic>> _users;

  @override
  void initState() {
    super.initState();
    _users = getAllUsers();
  }

  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await Dio().get(
        getalluserlist,
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );

      print('Raw Response: ${response}');
      print('Content-Type: ${response.headers['content-type']}');
      print('Response Data Type: ${response.data.runtimeType}');
      print('Response Body: ${response.data}');

      if (response.data is List) {
        return response.data;
      } else {
        throw Exception('Failed to load users. Unexpected response data type.');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load users: $e');
    }
  }

  Future<void> updateUser(String _id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateUserScreen(userId: _id),
      ),
    );
  }

  Future<void> deleteUser(String _id) async {
    print('Deleting User ID: $_id');
    try {
      final response = await Dio().delete(
        '$deleteUser$_id',
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );
      print('Delete Response: $response');
      print(response.realUri.toString());
      _refreshUserList();
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        print('Response Data: ${e.response?.data}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete user. Error: ${e.response?.statusCode}'),
          ),
        );
      } else {
        print('Exception: $e');
      }
    }
  }

  Future<void> _refreshUserList() async {
    setState(() {
      _users = getAllUsers();
      print(_users);
    });
  }

  // Navigate to the screen where the admin can register a new user
  void _navigateToRegisterUser() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Registration(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:  Color.fromARGB(255, 150, 125, 241),
        title: Text('Admin Panel'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final user = snapshot.data?[index];
                return Dismissible(
                  key: Key(user['_id'].toString()),
                  onDismissed: (direction) {
                    // Handle swipe-to-delete
                    deleteUser(user?['_id']);
                  },
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(user?['userid'] ?? ''),
                    subtitle: Text(user?['email'] ?? ''),
                    onTap: () {
                      // Handle tapping on a user item
                      updateUser(user?['_id']);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(selectedItemColor:  Color.fromARGB(255, 150, 125, 241),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'User List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Register User',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation bar taps
          if (index == 1) {
            _navigateToRegisterUser();
          }
        },
      ),
    );
  }
}


