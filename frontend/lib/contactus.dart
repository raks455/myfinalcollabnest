import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 143, 210),
      body: Container(
          width: 340,
          height: 700,
          child: Center(
            child: Card(
                margin: EdgeInsets.only(top: 50.0, left: 25),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Image.asset("assets/logo.png", height: 100, width: 100),
                      Text(
                        "CollabNest",
                        style: TextStyle(
                          color: Color.fromARGB(255, 150, 125, 241),
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      Text("Flying Collaborately",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      Text("1.1"),
                      SizedBox(height: 350),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "If you have any queries,you can always contact us through social media,contact number ,email and linkedin. \n Email:collabnest@gmail.com \n Contact number: +9779812012123",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )),
          )),
    );
  }
}
