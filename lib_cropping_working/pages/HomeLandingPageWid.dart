import 'package:flutter/material.dart';
//import 'package:fashion_app/color_filters.dart';

class HomeLandingPage extends StatefulWidget {
  @override
  _HomeLandingPageState createState() => _HomeLandingPageState();
}

class _HomeLandingPageState extends State<HomeLandingPage> {
  final double _borderRadious = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Wallet'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSearchInput(),
        ],
      ),
    );
  }

  Widget buildSearchInput() => Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.only(left: 10.0, right: 20),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 30,
                color: Colors.grey,
              ),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              Icon(
                Icons.search,
                size: 30,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
}
