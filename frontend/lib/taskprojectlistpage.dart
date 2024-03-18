
import 'package:flutter/material.dart';
import 'package:frontend/projectlist.dart';
import 'package:frontend/tasklist.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class TaskProjectListPage extends StatefulWidget {
 
  const TaskProjectListPage({ Key? key}) : super(key: key);

  @override
  State<TaskProjectListPage> createState() => _TaskProjectListPageState();
}

class _TaskProjectListPageState extends State<TaskProjectListPage> {
  late String userId;
  


  @override
  void initState() {
    
      
    super.initState();
    
    
  }

  
  @override
  Widget build(BuildContext context) {
   

    return DefaultTabController(
      length: 2, // specify the number of tabs
      child: Scaffold(
      appBar: AppBar(backgroundColor:  Color.fromARGB(255, 150, 125, 241),automaticallyImplyLeading: false,
          title: Text('Manage Tasks and Projects'),
          bottom: TabBar(indicatorColor:Colors.white,
            tabs: [
              Tab(text: 'Tasks'),
              Tab(text: 'Projects'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskListPage(),
            ProjectListPage(),
          ],
        ),
      
      ),
    );
  }

 
}
