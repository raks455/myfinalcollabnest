import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;

  const ResetPasswordScreen({
    Key? key,
    required this.resetToken,
  }) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 150, 125, 241),
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the function to reset the password
                _resetPassword();
              },
              child: Text('Reset Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 150, 125, 241),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword() async {
    try {
      var resetBody = {
        "token": widget.resetToken,
        "newPassword": _newPasswordController.text,
      };

      var response = await http.post(
        Uri.parse(url + 'resetpassword'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(resetBody),
      );

      if (response.statusCode == 200) {
        // Password reset successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset successfully'),
          ),
        );

        // Pop the screen to go back to the login screen
        Navigator.pop(context);
      } else {
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to reset password. Error: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during password reset: $e');
    }
  }
}
