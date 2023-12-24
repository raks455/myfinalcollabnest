
import 'package:flutter/material.dart';
import 'package:frontend/chatpage.dart';
import 'package:frontend/chhatpage.dart';
import 'package:frontend/emailpage.dart';
import 'package:frontend/product_list.dart';
import 'package:frontend/taskproject.dart';
import 'package:frontend/menupage.dart';
import 'config.dart';

import 'newsfeed.dart'; // Import your NewsFeed class

class HomeScreen extends StatefulWidget {
  final token;

  const HomeScreen({@required this.token, Key? key}) : super(key: key); 

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
     // ProductsList(token:widget.token),
      //  Newsfeed(token:widget.token),
      TaskProject(token: widget.token),
      //  ChatPage(token: widget.token),
      EmailSendPage(token:widget.token),
      Menupage(token:widget.token)
    
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor:Color.fromARGB(255, 150, 125, 241),
     unselectedItemColor:Color.fromARGB(255, 217, 204, 245),
        selectedItemColor:Color.fromARGB(255, 234, 234, 236),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            
          });
        },
        items: [
          
         /* BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'News Feed',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Tasks',
          ),
         BottomNavigationBarItem(icon:Icon(Icons.email),
         label:'Email'
         ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
