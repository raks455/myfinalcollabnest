


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

class TaskListPage extends StatefulWidget {

  const TaskListPage({ Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  
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
  
  List? items;
  late String _formattedTime = '';
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    
    getProjectList();

    
  }

  

  void getProjectList() async {
   
    var response = await http.post(Uri.parse(getalltodolist),
        headers: {"Content-Type": "application/json"},
     );

    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];

    setState(() {});
  }

  void deleteItem(id) async {
    var regBody = {"id": id};

    var response = await http.post(Uri.parse(deleteTodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      getProjectList();
    }
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
                hintText: 'Search tasks...',
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
                        child: Text('No tasks found'),
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
                                    
                                    selectedColor: Colors.blueGrey,
                                    title: Text(sortedItems[index]['title']),
                                    subtitle:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sortedItems[index]['desc']),
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
    
    );
  }


List binarySearch(String query) {
  List result = [];
  if (items == null || items!.isEmpty) {
    return result;
  }

  for (int i = 0; i < items!.length; i++) {
    String itemTitle = items![i]['title'];
    String itemDescription = items![i]['desc'];

    if (itemTitle.startsWith(query) || itemDescription.startsWith(query)) {
      result.add(items![i]);
    }
  }

  return result;
}

 
 String formattedTimestamp(String timestamp) {
  // Check if timestamp is not null
  if (timestamp != null) {
    // Parse the timestamp and format it according to your preference
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  } else {
    // Handle the case when timestamp is null
    return 'N/A';
  }
}


}
