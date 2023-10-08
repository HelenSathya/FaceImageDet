import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';


//import 'package:fashion_app/color_filters.dart';

class LogoutPage extends StatefulWidget {
  @override
  LogoutPageState createState() => LogoutPageState();
}

enum SubMenu { MyProfile, Settings }

enum Options { search, upload, copy, exit }

class LogoutPageState extends State<LogoutPage> {
  final double _borderRadious = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logged-out Successfully.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
                onPressed: () {
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (BuildContext context) {
                  //return MyHomePage(
                  //title: 'Digital Wallet',
                  //);
                  //}),
                  //);
                },
                child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
