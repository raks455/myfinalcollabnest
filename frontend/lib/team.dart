import 'package:flutter/material.dart';
class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Color.fromARGB(255, 233, 143, 210),body:Container(width:340,height:700,
                                
      child:Center(
        child: Card(margin:EdgeInsets.only(top:50.0,left:25),
          child:Center(
            child: Column(children: [
              SizedBox(height:30),
              Image.asset("assets/logo.png",height: 100,width:100),
              Text("CollabNest",style: TextStyle(color: Color.fromARGB(255, 150, 125, 241),fontWeight:FontWeight.bold,fontSize:23,),),
              Text("Flying Collaborately",style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black54)),
              Text("1.1"),
              SizedBox(height:330),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("This Collaboration platform is built by final year students of Bsc.CSIT for final year project.Developers involved in this project are  Prakash Basnet and Rakshya Bastola.   ",style: TextStyle(color:Colors.black54,fontWeight:FontWeight.bold,fontSize:15 ),),
              )
            ],),
          )
        ),
      )
    ),);
  }
}