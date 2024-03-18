import 'package:flutter/material.dart';

import 'package:frontend/adminpanel.dart'; // Import your existing AdminPanelScreen
import 'package:frontend/projectlist.dart';
import 'package:frontend/registration.dart';
import 'package:frontend/adminprofile.dart';
import 'package:frontend/taskprojectlistpage.dart';

class AdminHomePage extends StatefulWidget {
  final token;

  const AdminHomePage({@required this.token, Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  int _userCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 150, 125, 241),
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people,
                color: _selectedIndex == 0
                    ? Color.fromARGB(255, 150, 125, 241)
                    : Colors.grey),
            label: 'User List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add,
                color: _selectedIndex == 1
                    ? Color.fromARGB(255, 150, 125, 241)
                    : Colors.grey),
            label: 'Register User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work,
                color: _selectedIndex == 2
                    ? Color.fromARGB(255, 150, 125, 241)
                    : Colors.grey),
            label: 'Task & Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 3
                    ? Color.fromARGB(255, 150, 125, 241)
                    : Colors.grey),
            label: 'Profile',
          )
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return AdminPanelScreen(
          token: widget.token,
          onUserListReceived: (userList) {
            // Handle the received user list here
            print('Received User List: $userList.length');
            setState(() {
              _userCount = userList.length;
            });
          },
        );

      case 1:
        return Registration(token: widget.token);
      case 2:
        return TaskProjectListPage();
      case 3:
        return AdminProfile(token: widget.token, userCount: _userCount);
      default:
        return Container(); // Fallback to an empty container for unknown index
    }
  }
}
