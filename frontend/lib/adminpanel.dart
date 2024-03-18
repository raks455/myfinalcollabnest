import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:frontend/adminprofile.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/registration.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:frontend/config.dart';
import 'package:frontend/updateuserscreen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class AdminPanelScreen extends StatefulWidget {
  final token;
 final Function(List<String>) onUserListReceived; // Callback function

  const AdminPanelScreen({@required this.token, Key? key,required this.onUserListReceived}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late Future<List<dynamic>> _users;
  Map<String, dynamic>? _selectedUser;
    bool _isCardSelected = false;
   int _selectedIndex = 0;
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
        builder: (context) =>  UpdateUserScreen(userId: _id, onUserUpdated: _refreshUserList),
      
         //   
      ),
    );
  }

  Future<void> deleteUser(String _id) async {
    if (_id == null) {
      print('User ID is null. Unable to delete.');
      return;
    }
    print('Deleting User ID: $_id');
    try {
      final response = await Dio().delete(
        url + 'deleteuser/$_id',
        options: Options(
          headers: {'Authorization': 'Bearer ${widget.token}'},
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green,
            content: Text('User deleted successfully'),
          ),
        );
        _refreshUserList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to delete user. Error: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        print(e);
        print('DioError: ${e.error}');
        print('DioError Stack Trace: ${e.stackTrace}');
        print(
            'DioError: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        print('Response Data: ${e.response?.data}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to delete user. Error: ${e.response?.statusCode}'),
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
    });
  }

  void _navigateToRegisterUser() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Registration(token:widget.token,),
      ),
    );
  }
void _toggleCardSelection() {
    setState(() {
        _selectedUser = _selectedUser == null ? null : null;
    });
  }


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 150, 125, 241),
        title: Text('Admin Panel'),   leading:ElevatedButton(
            onPressed: () {
           
            _users.then((userList) {
      widget.onUserListReceived(userList.map<String>((user) => user['fullname'] as String).toList());
    });
            },style:ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 150, 125, 241), elevation: 0),
            child: Text(' '),
          )
      ),
      body: Stack(
        children: [
          Card(
            elevation: 4.0,
            margin: EdgeInsets.all(16.0),
            child: FutureBuilder<List<dynamic>>(
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
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedUser = user;
                        });
                      },
                      child: Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(user?['fullname'] ?? ''),
                              subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${user?['email'] ?? ''}'),
                               Text('Username:${user?['userid'] ?? ''}'),
                                Text(
                                    'Organization: ${user?['organization'] ?? ''}'),
                                 Text('Role:${user?['role']??''}')
                             ],
                           ), trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Handle edit button click
                                    updateUser(user?['_id']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Handle delete button click
                                    deleteUser(user?['_id']);
                                  },
                                ),
                              ],
                            ),
                            ),
                            Divider(height: 1.0, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                );}
              },
            ),
          ),
          if (_selectedUser != null)
            Positioned.fill(
              child: GestureDetector(onTap: _toggleCardSelection,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 400,
                      height: 220,
                      child: Padding(
                        padding: EdgeInsets.only(left:46.0,top:50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Full Name: ${_selectedUser!['fullname']}'),
                            Text('Email: ${_selectedUser!['email']}'),
                            Text('Username: ${_selectedUser!['userid']}'),
                            Text('Organization: ${_selectedUser!['organization']}'),
                          Text('Role:${_selectedUser!['role']}'),
                             Text(
                          'Registered Date: ${_formatDate(_selectedUser!['createdAt'])}',
                        ),
                         Text(
                          'Updated Date: ${_formatDate(_selectedUser!['updatedAt'])}',
                        ),
                          
                            
                       ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ), 
        ],
      ),

      
      
    
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm a').format(dateTime);
  }
}
