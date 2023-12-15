


import 'dart:async';
import 'dart:convert';
import 'package:frontend/menupage.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProjectPage extends StatefulWidget {
  final token;
  const ProjectPage({@required this.token, Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  
  void quickSort(List list, int left, int right) {
  if (left < right) {
    int pivotIndex = partition(list, left, right);

    quickSort(list, left, pivotIndex - 1);
    quickSort(list, pivotIndex + 1, right);
  }
}
  int partition(List list, int left, int right) {
  String pivotValue = list[right]['timestamp']; // Use the timestamp for comparison
  int partitionIndex = left;

  for (int i = left; i < right; i++) {
    if (list[i]['timestamp'].compareTo(pivotValue) >= 0) {
      swap(list, i, partitionIndex);
      partitionIndex++;
    }
  }

  swap(list, partitionIndex, right);

  return partitionIndex;
}
   void swap(List list, int i, int j) {
    Map temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
  late String userId;
  TextEditingController _projectTitle = TextEditingController();
  TextEditingController _projectDescription = TextEditingController();
  List? items;
  Stopwatch _stopwatch = Stopwatch()..start();
  late String _formattedTime = '';
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    getProjectList(userId);

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_isRunning) {
        setState(() {
          _formattedTime = _stopwatch.elapsed.inHours
                  .toString()
                  .padLeft(2, '0') +
              ':' +
              (_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
              ':' +
              (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
        });
      }
    });
  }

  void addProject() async {
    if (_projectTitle.text.isNotEmpty && _projectDescription.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _projectTitle.text,
        "description": _projectDescription.text
      };

      var response = await http.post(Uri.parse(addproject),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        _projectDescription.clear();
        _projectTitle.clear();
        Navigator.pop(context);
        getProjectList(userId);
      } else {
        print("SomeThing Went Wrong");
      }
    }
  }

  void getProjectList(userId) async {
    var regBody = {"userId": userId};

    var response = await http.post(Uri.parse(getprojectList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];

    setState(() {});
  }

  void deleteItem(id) async {
    var regBody = {"id": id};

    var response = await http.post(Uri.parse(deleteproject),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      getProjectList(userId);
    }
  }

  void toggleStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  late String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    items?.sort((a, b) => a['title'].compareTo(b['title']));
   
        List filteredItems = binarySearch(searchQuery);
    int projectCount = items?.length ?? 0;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 177, 163, 231),
    
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Timer',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
        width: 80,
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 150, 125, 241),
          focusColor: Colors.white,
          foregroundColor: Colors.white,
          onPressed: () {
       
            toggleStopwatch();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          elevation: 5,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 2.0),
              child: Text(
                _isRunning ? 'Pause' : 'Play',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          tooltip: 'Toggle Stopwatch',
        ),
      ),
                SizedBox(height: 10.0),
                Text(
                  _formattedTime ?? '00:00:00',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 8.0),
                Text(
                  '$projectCount Projects',
                  style: TextStyle(fontSize: 20,color:Colors.black45),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search projects...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: filteredItems.isEmpty
                    ? Center(
                        child: Text('No projects found'),
                      )
                    :  Builder(
                        builder: (context) {
                          List sortedItems = List.from(filteredItems);
                          quickSort(sortedItems, 0, sortedItems.length - 1);
                          return ListView.builder(
                            itemCount: sortedItems.length,
                            itemBuilder: (context, int index) {
                              return Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              deleteItem(filteredItems[index]['_id']);
                            }),children: [
                              SlidableAction(
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (BuildContext context) {
                                  print(sortedItems[index]['id']);
                                  deleteItem(sortedItems[index]['id']);
                                },
                              ),
                            ],),
                                child: Card(
                                  color: Color.fromARGB(255, 238, 229, 235),
                                  borderOnForeground: false,
                                  child: ListTile(
                                    leading: Icon(Icons.task),
                                    selectedColor: Colors.blueGrey,
                                    title: Text(sortedItems[index]['title']),
                                    subtitle:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sortedItems[index]['description']),
          Text(
            'Added on: ${formattedTimestamp(sortedItems[index]['timestamp'])}',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ), 
                                
                                    trailing: Icon(Icons.keyboard_double_arrow_left_rounded),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  
              ),
            ),
          )
        ],
      ),
      floatingActionButton: SizedBox(
            width:80,
            child: FloatingActionButton(backgroundColor: Color.fromARGB(255, 150, 125, 241),focusColor: Colors.white,foregroundColor:Colors.white,
                onPressed: () => _displayTextInputDialog(context),
             shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),elevation:5 ,
                 
                 
                  child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left:12.0,right:2.0),
              child: Text(
                "   Add Projects",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
                  ),
                
                tooltip: 'Add ToDo',
              ),
          ),
    );
  }

 List binarySearch(String query) {
  List result = [];
  if (items == null || items!.isEmpty) {
    return result;
  }

  int left = 0;
  int right = items!.length - 1;

  while (left <= right) {
    int mid = left + ((right - left) ~/ 2);
    String midTitle = items![mid]['title'];
    String midDescription = items![mid]['description'];

    if (midTitle.startsWith(query) || midDescription.startsWith(query)) {
      // Item found, expand the range to include all matching items
      int start = mid;
      int end = mid;

      while (start - 1 >= left && (items![start - 1]['title'].startsWith(query) || items![start - 1]['description'].startsWith(query))) {
        start--;
      }

      while (end + 1 <= right && (items![end + 1]['title'].startsWith(query) || items![end + 1]['description'].startsWith(query))) {
        end++;
      }

      // Add all matching items to the result
      for (int i = start; i <= end; i++) {
        result.add(items![i]);
      }

      return result;
    } else if (midTitle.compareTo(query) < 0) {
      // Move to the right half
      left = mid + 1;
    } else {
      // Move to the left half
      right = mid - 1;
    }
  }

  return result;
}

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Projects'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _projectTitle,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px8(),
                SizedBox(height: 20,),
                TextField(
                  controller: _projectDescription,
                  keyboardType: TextInputType.text,
                  maxLines:5,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px8(),
                ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color.fromARGB(255, 224, 114, 197)),
                    onPressed: () {
                      addProject();
                    
                      
                    },
                    child: Text("Add"))
              ],
            ),
          );
        });
  }
  String formattedTimestamp(String timestamp) {
  // Parse the timestamp and format it according to your preference
  DateTime dateTime = DateTime.parse(timestamp).toLocal();
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

}
