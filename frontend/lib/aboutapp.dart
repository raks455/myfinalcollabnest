import 'package:flutter/material.dart';
class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor:Color.fromARGB(255, 233, 143, 210),body:Container(width:340,height:700,
                                
      child:Center(
        child: Card(margin:EdgeInsets.only(top:50.0,left:25),
          child:Center(
            child: Column(children: [
              SizedBox(height:30),
              Image.asset("assets/logo.png",height: 100,width:100),
              Text("CollabNest",style: TextStyle(color: Color.fromARGB(255, 150, 125, 241),fontWeight:FontWeight.bold,fontSize:23,),),
              Text("Flying Collaborately",style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black54)),
              Text("1.1"),
              SizedBox(height:350),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("With CollabNest,we can collaborate and work within our teams .This application will help employees within the  organization to communicate and perform task together.",style: TextStyle(color:Colors.black54,fontWeight:FontWeight.bold),),
              )
            ],),
          )
        ),
      )
    ),);
  }
}
