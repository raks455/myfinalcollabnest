import 'package:flutter/material.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;

  const UpdateUserScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    // Fetch user details based on widget.userId and populate the controllers
    // You can use this information to pre-fill the form
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            // Add form fields for other user details
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the function to update the user with the new details
                _updateUserDetails();
              },
              child: Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserDetails() {
    // Implement the logic to update user details using the API
    // You can use Dio or any other HTTP client for this purpose
  }
}
