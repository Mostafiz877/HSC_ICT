import 'package:flutter/material.dart';

class About extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F2F5),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("App and video lectures are created by"),
            Divider(),
            Text(
              "Mustafizur Rahman",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            Text("CSE,RUET"),
            Text("Mobile and web application developer"),
            Text("Former ICT teacher, Versatile ICT Center,Rajshahi"),
            Text("Contact: 01515621522"),
          ],
        ),
      ),
    );
  }
}
