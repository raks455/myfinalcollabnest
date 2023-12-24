import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:velocity_x/velocity_x.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor:Color.fromARGB(255, 150, 125, 241),
        title: Text('Send Email'),
      ),
      body: Padding(
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
                  InputDecoration(labelText: 'Sender Google App Password'),
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
            SizedBox(height: 5),
            ElevatedButton(
           
              onPressed: () async {
                await sendEmail();
              },
              style:ElevatedButton.styleFrom(backgroundColor:Color.fromARGB(255, 150, 125, 241)),
              child: Text('Send Email'),
            ),  
          ],
        ),
      ),
    );
  }

  Future<void> sendEmail() async {
    final String username = senderUsernameController.text;
    final String password = senderPasswordController.text;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add(toController.text)
      ..subject = subjectController.text
      ..text = bodyController.text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent successfully: ' + sendReport.toString());
      Card(
        color: Colors.green,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          title: "Email sent!".text.white.make(),
        ),
      );
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }

      // Optionally, show an error message.
    }
  }
}
