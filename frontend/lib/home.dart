import 'package:flutter/material.dart';
import 'package:frontend/chattpage.dart';

import 'package:frontend/emailpage.dart';
import 'package:frontend/message.services.dart';
import 'package:frontend/newsfeedpage.dart';
import 'package:frontend/taskproject.dart';
import 'package:frontend/menupage.dart';
import 'config.dart';

class HomeScreen extends StatefulWidget {
  final token;

  const HomeScreen({@required this.token, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  late MessageService messageService; // Initialize messageService here

  @override
  void initState() {
    super.initState();

    messageService = MessageService(); // Initialize messageService

    _pages = [
      TaskProject(token: widget.token),
      NewsFeed(token: widget.token),
     // ChatPage(token: widget.token),
      ChattPage(token:widget.token),
      EmailSendPage(token: widget.token),
      Menupage(token: widget.token),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color.fromARGB(255, 166, 150, 223),
        unselectedItemColor: Color.fromARGB(255, 200, 171, 233),
        selectedItemColor: Color.fromARGB(255, 129, 80, 219),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article), // Change to your preferred icon
            label: 'NewsFeed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Email'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
