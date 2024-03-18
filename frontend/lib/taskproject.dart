
import 'package:flutter/material.dart';
import 'package:frontend/projectlist.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'taskpage.dart'; 
import 'projectpage.dart'; 

class TaskProject extends StatefulWidget {
  final token;
  const TaskProject({@required this.token, Key? key}) : super(key: key);

  @override
  State<TaskProject> createState() => _TaskProjectState();
}

class _TaskProjectState extends State<TaskProject> {
  late String userId;
  


  @override
  void initState() {
    
      
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    
  }

  
  @override
  Widget build(BuildContext context) {
   

    return DefaultTabController(
      length: 2, // specify the number of tabs
      child: Scaffold(
      appBar: AppBar(backgroundColor:  Color.fromARGB(255, 150, 125, 241),
          title: Text('Add Tasks and Projects'),
          bottom: TabBar(indicatorColor:Colors.white,
            tabs: [
              Tab(text: 'Tasks'),
              Tab(text: 'Projects'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskPage(token: widget.token),
            ProjectPage(token: widget.token),
          ],
        ),
      
      ),
    );
  }

 
}
