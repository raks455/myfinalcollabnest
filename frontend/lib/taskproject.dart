
import 'package:flutter/material.dart';
import 'package:frontend/projectpage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'taskpage.dart'; // Import your TaskPage and ProjectPage here
import 'projectpage.dart'; // Import your TaskPage and ProjectPage here

class TaskProject extends StatefulWidget {
  final token;
  const TaskProject({@required this.token, Key? key}) : super(key: key);

  @override
  State<TaskProject> createState() => _TaskProjectState();
}

class _TaskProjectState extends State<TaskProject> {
  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    getTodoList(userId);
  }

  void addTodo() async {
    // Implementation remains the same
  }

  void getTodoList(userId) async {
    // Implementation remains the same
  }

  void deleteItem(id) async {
    // Implementation remains the same
  }

  @override
  Widget build(BuildContext context) {
    int taskCount = items?.length ?? 0;

    return DefaultTabController(
      length: 2, // specify the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('ToDo App'),
          bottom: TabBar(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayTextInputDialog(context),
          child: Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color:Color.fromARGB(255, 5, 53, 92)
            ),
            child: Text(
              "Add Task",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          tooltip: 'Add ToDo',
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    // Implementation remains the same
  }
}
