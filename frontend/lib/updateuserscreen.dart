import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  String _selectedRole = 'regular';

  String get selectedRole => _selectedRole;

  void setSelectedRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }
}

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  final Function() onUserUpdated;

  const UpdateUserScreen({
    Key? key,
    required this.userId,
    required this.onUserUpdated,
  }) : super(key: key);

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _useridController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _organizationController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    if (_roleController.text.isEmpty && roles.isNotEmpty) {
      _roleController.text = roles.first;
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      var response = await http.get(
        Uri.parse(url + 'getuserbyid/${widget.userId}'),
        headers: {"Content-Type": "application/json"},
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print(url + 'getuserbyid/${widget.userId}');

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        print(userData);

        _fullNameController.text = userData['user']['fullname'] ?? '';
        _emailController.text = userData['user']['email'] ?? '';
        _useridController.text = userData['user']['userid'] ?? '';
        _passwordController.text = userData['user']['password'] ?? '';
        _organizationController.text = userData['user']['organization'] ?? '';
        String retrievedRole = userData['user']['role'] ?? '';
        if (roles.contains(retrievedRole)) {
          _roleController.text = retrievedRole;
        } else {
          // If not, set it to the first role in the list
          _roleController.text = roles.first;
        }

        // } else {
        //   // If not, set it to the first role in the list
        //   _roleController.text = roles.first;
        // }

        print('Unhashed Password: ${_passwordController.text}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to fetch user details. Error: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during user details fetch: $e');
    }
  }

  bool _validatePassword(String password) {
    // Password should be at least 8 characters, contain a number, and a capital letter
    RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');
    return passwordRegex.hasMatch(password);
  }

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
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 150, 125, 241),
        title: Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _useridController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              controller: _organizationController,
              decoration: InputDecoration(labelText: 'Organization'),
            ),
             TextFormField(
              controller: _roleController,
              decoration: InputDecoration(labelText:'Current role'),
            ),
            DropdownButtonFormField<String>(
              //  value: userProvider.selectedRole,
              value: _roleController.text.isNotEmpty
                  ? _roleController.text
                  : _roleController.text,
              //userProvider.selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  //  _roleController.text = newValue!;
                  _roleController.text = newValue!;
                  userProvider.setSelectedRole(newValue!);
                });
              },
              items: roles.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Available Role'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the function to update the user with the new details
                _updateUserDetails();
              },
              child: Text('Update User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 150, 125, 241),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateUsername(String userid) {
    // Username should contain '@' and numbers
    RegExp useridRegex = RegExp(r'[@\d]');
    return useridRegex.hasMatch(userid);
  }

  void _updateUserDetails() async {
    try {
      if (!_validatePassword(_passwordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Password must be at least 8 characters, contain a number, and a capital letter',
            ),
          ),
        );
        return;
      }
      if (!_validateUsername(_useridController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Username must be in form of characters along with at least a number',
            ),
          ),
        );
        return;
      }
      var updateBody = {
        "fullname": _fullNameController.text,
        "email": _emailController.text,
        "userid": _useridController.text,
        "password": _passwordController.text,
        "role": _roleController.text
      };
    
      // Hash the password before updating
      var hashedPassword = await BCrypt.hashpw(
        _passwordController.text,
        BCrypt.gensalt(),
      );
      updateBody["password"] = hashedPassword;
  print(updateBody['role']);
      var response = await http.put(
        Uri.parse(url + 'updateuser/${widget.userId}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updateBody),
      );

      if (response.statusCode == 200) {
        // User details updated successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('User details updated successfully'),
          ),
        );

        // Call the callback function to refresh the user list
        widget.onUserUpdated();

        // Pop the screen to go back to the AdminPanelScreen
        Navigator.pop(context);
      } else {
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to update user details. Error: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during user update: $e');
    }
  }
}
