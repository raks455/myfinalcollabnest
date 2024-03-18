import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart ' as http;

class EmailSendPage extends StatefulWidget {
  final token;

  const EmailSendPage({@required this.token, Key? key}) : super(key: key);

  @override
  _EmailSendPageState createState() => _EmailSendPageState();
}

class _EmailSendPageState extends State<EmailSendPage> {
  late String userId;
  late String userName;
  late String fullname;
  late String organization;
  late String userEmail;
  final TextEditingController senderUsernameController =
      TextEditingController();
  final TextEditingController senderPasswordController =
      TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic>? jwtDecodedToken = JwtDecoder.decode(widget.token);

    if (jwtDecodedToken != null) {
      userId = jwtDecodedToken['_id'] ?? '';
      userName = jwtDecodedToken['username'] ?? '';
      userEmail = jwtDecodedToken['email'] ?? '';
      organization = jwtDecodedToken['organization'] ?? '';
      fullname = jwtDecodedToken['fullname'] ?? '';
    } else {
      userId = '';
      userName = '';
      userEmail = '';
      organization = '';
      fullname = '';
    }

    // Set initial values for sender's username and password
    senderUsernameController.text = userEmail;
    senderPasswordController.text = 'oehc yjfl rbek ayuy';
  }

  final List<EmailHistoryEntry> emailHistory = [];
  final List<MessageEntry> receivedMessages = [];
  EmailHistoryEntry? selectedEmail;
  MessageEntry? selectedMessage;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 150, 125, 241),
          title: Text('Emails'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Send Email'),
              Tab(text: 'Sent Emails'),
              Tab(text: 'Recieved Emails'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab: Send Email
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: senderUsernameController,
                      decoration: InputDecoration(labelText: 'Sender Username'),
                    ),
                    TextField(
                      controller: senderPasswordController,
                      obscureText: true,
                      decoration:
                          InputDecoration(labelText: 'Sender Google  Password'),
                    ),
                    TextField(
                      controller: toController,
                      decoration: InputDecoration(labelText: 'To'),
                    ),
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(labelText: 'Subject'),
                    ),
                    TextField(
                      controller: bodyController,
                      maxLines: 5,
                      decoration: InputDecoration(labelText: 'Body'),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        await showUserSelectionDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 150, 125, 241),
                      ),
                      child: Text('Select User to Message'),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        await sendEmail();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 150, 125, 241)),
                      child: Text('Send Email'),
                    ),
                  ],
                ),
              ),
            ),

            // Second Tab: Email History
            EmailHistoryPage(
              emailHistory: emailHistory,
              onEmailSelected: (entry) {
                setState(() {
                  selectedEmail = entry;
                });
              },
            ),
            ReceivedMessagesPage(token: widget.token),
          ],
        ),
        floatingActionButton: selectedEmail != null
            ? FloatingActionButton.extended(
                onPressed: () {
                  // Do something with the selected email
                  // For example, show a dialog with the details
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Email Detail'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('To: ${selectedEmail!.to}'),
                            Text('Subject: ${selectedEmail!.subject}'),
                            Text('Body: ${selectedEmail!.body}'),
                            Text('Sent on: ${selectedEmail!.sentOn}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                label: Text('View Email Detail'),
                icon: Icon(Icons.mail),
              )
            : null,
      ),
    );
  }

  Future<void> sendEmail() async {
    final String username = senderUsernameController.text;
    final String password = senderPasswordController.text;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, fullname)
      ..recipients.add(toController.text)
      ..subject = subjectController.text
      ..text = bodyController.text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent successfully: ' + sendReport.toString());
      setState(() {
        emailHistory.add(
          EmailHistoryEntry(
            to: toController.text,
            subject: subjectController.text,
            body: bodyController.text,
            sentOn: DateTime.now(),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Email sent successfully'),
          duration: Duration(seconds: 3),
        ),
      );
      await saveSentEmailToDatabase(
        toController.text,
        subjectController.text,
        bodyController.text,
      );
      senderPasswordController.clear();
      toController.clear();
      subjectController.clear();
      bodyController.clear();
    } on MailerException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send email. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> saveSentEmailToDatabase(
    String to,
    String subject,
    String body,
  ) async {
    try {
      final String apiUrl = sentemails;

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'to': to,
          'subject': subject,
          'body': body,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Email saved successfully');
      } else {
        print('Failed to save email. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving email to database: $e');
    }
  }

  Future<void> saveReceivedMessageToDatabase(
    String from,
    String subject,
    String body
    
  ) async {
    try {
   

      final response = await http.get(
        Uri.parse(receivedemails),
        // body: jsonEncode({
        //   'from': from,
        //   'subject': subject,
        //   'body': body,
        // }),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Received message saved successfully');
      } else {
        print(
            'Failed to save received message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving received message to the database: $e');
    }
  }

  Future<void> showUserSelectionDialog(BuildContext context) async {
    try {
      // Fetch the list of users from the API
      final response =
          await http.get(Uri.parse(getalluserlist));
      print(response.body);
      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic>? userList = json.decode(response.body);

        // Ensure that the response is a List<dynamic> before proceeding
        if (userList is List<dynamic> && userList.isNotEmpty) {
          // Show a dialog with a list of users
          final selectedUser = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Select User'),
                content: Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];

                      // Ensure that user is not null before accessing properties
                      if (user is Map<String, dynamic> &&
                          user['fullname'] is String &&
                          user['email'] is String) {
                        return ListTile(
                          title: Text(user['fullname']),
                          subtitle: Text(user['email']),
                          onTap: () {
                            Navigator.pop(context, user);
                          },
                        );
                      } else {
                        // Handle the case when the user or its properties are null
                        return Container();
                      }
                    },
                  ),
                ),
              );
            },
          );

          // If a user is selected, you can now use the selected user's email
          if (selectedUser != null && selectedUser['_id'] is String) {
            toController.text = selectedUser['email'];
          }
        } else {
          // Handle the case when userList is null or empty
          print('Failed to fetch user list. Unexpected response format.');
        }
      } else {
        // Handle the error when the status code is not 200
        print('Failed to fetch user list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error fetching user list: $e');
    }
  }
}

class User {
  final String fullname;
  final String email;

  User({
    required this.fullname,
    required this.email,
  });
}

class EmailHistoryPage extends StatelessWidget {
    final token;
  final List<EmailHistoryEntry> emailHistory;
  final Function(EmailHistoryEntry)? onEmailSelected;

  // Constructor to receive the email history entries
  const EmailHistoryPage({
    Key? key,
    required this.emailHistory,
    this.onEmailSelected, this.token,
  }) : super(key: key);
  // Future<List<EmailHistoryEntry>> getSentEmailsFromDatabase() async {
  //   try {
  //     final String apiUrl = sentemails;

  //     final response = await http.get(Uri.parse(apiUrl));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);

  //       final List<EmailHistoryEntry> sentEmails = data.map((entry) {
  //         return EmailHistoryEntry(
  //           to: entry['to'],
  //           subject: entry['subject'],
  //           body: entry['body'],
  //           sentOn: DateTime.parse(entry['sentOn']),
  //         );
  //       }).toList();

  //       return sentEmails;
  //     } else {
  //       print(
  //           'Failed to fetch sent emails. Status code: ${response.statusCode}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error fetching sent emails from database: $e');
  //     return [];
  //   }
  // }
Future<List<EmailHistoryEntry>> getSentEmailsFromDatabase() async {
  
  try {
    
    final String apiUrl = sentemails; // Replace with your API endpoint

    final response = await http.get(Uri.parse(apiUrl), headers: {
    
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<EmailHistoryEntry> sentEmails = data.map((entry) {
        return EmailHistoryEntry(
          to: entry['to'] ?? '',
          subject: entry['subject'] ?? '',
          body: entry['body'] ?? '',
          sentOn: DateTime.parse(entry['sentOn']),
        );
      }).toList();

      return sentEmails;
    } else {
      print('Failed to fetch sent emails. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching sent emails from database: $e');
    return [];
  }
}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: emailHistory.length,
      itemBuilder: (context, index) {
        final entry = emailHistory[index];
        return InkWell(
          onTap: () {
            // Notify the parent widget about the selected email
            if (onEmailSelected != null) {
              onEmailSelected!(entry);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text('To: ${entry.to}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subject: ${entry.subject}'),
                    Text('Body: ${entry.body}'),
                    Text('Sent on: ${entry.sentOn}'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class EmailHistoryEntry {
  final String to;
  final String subject;
  final String body;
  final DateTime sentOn;

  // Constructor to create an email history entry
  EmailHistoryEntry({
    required this.to,
    required this.subject,
    required this.body,
    required this.sentOn,
  });
}

class ReceivedMessagesPage extends StatelessWidget {
  final String token;

  const ReceivedMessagesPage({required this.token, Key? key}) : super(key: key);
 
  Future<List<MessageEntry>> getReceivedMessagesFromDatabase() async {
    try {
      final String apiUrl = receivedemails; // Replace with your API endpoint

      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((entry) {
          return MessageEntry(
            from: entry['from'] ?? '',
            subject: entry['subject'] ?? '',
            body: entry['body'] ?? '',
            receivedOn: DateTime.parse(entry['receivedOn']),
          );
        }).toList();
      } else {
        print(
            'Failed to fetch received messages. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching received messages from the database: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MessageEntry>>(
      future: getReceivedMessagesFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No received messages.');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final entry = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text('From: ${entry.from}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subject: ${entry.subject}'),
                        Text('Body: ${entry.body}'),
                        Text('Received on: ${entry.receivedOn}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class MessageEntry {
  final String from;
  final String subject;
  final String body;
  final DateTime receivedOn;

  MessageEntry({
    required this.from,
    required this.subject,
    required this.body,
    required this.receivedOn,
  });
}
