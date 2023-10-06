import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';
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
          //_buildStack(),
          buildRowOneMenu(),
          buildRowTwoMenu(),
          buildRowThreeMenu(),
          buildRowOneRecentFaceId(),
          buildRowTwoRecentFaceId()
        ],
      ),
    );
  }

  Widget buildSearchInput() => Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        //child: const Padding(
        //padding: EdgeInsets.only(left: 10.0, right: 20),
        child: const Row(
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
            //ProfilePhoto(
            //totalWidth: 60,
            //cornerRadius: 25,
            //color: Colors.green,
            //image: const AssetImage('assets/image.JPG'),
            //),
          ],
        ),
        // ),
      );

  Widget _buildStack() {
    return Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/image.JPG'),
          radius: 25,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.black45,
          ),
          //child: const Text(
          //'Mia B',
          //style: TextStyle(
          //fontSize: 20,
          //fontWeight: FontWeight.bold,
          //color: Colors.white,
          //),
          //),
        ),
      ],
    );
  }

  Widget buildRowOneMenu() => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.payment, color: Colors.green[500]),
                const Text('Payee'),
                //const Text('25 min'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.timer, color: Colors.green[500]),
                const Text('Bank'),
                //const Text('1 hr'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.restaurant, color: Colors.green[500]),
                const Text('Payment'),
                //const Text('4-6'),
              ],
            ),
          ],
        ),
      );

  Widget buildRowTwoMenu() => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.payment, color: Colors.green[500]),
                const Text('Profile'),
                //const Text('25 min'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.timer, color: Colors.green[500]),
                const Text('Reports'),
                //const Text('1 hr'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.restaurant, color: Colors.green[500]),
                const Text('Analytics'),
                //const Text('4-6'),
              ],
            ),
          ],
        ),
      );

  Widget buildRowThreeMenu() => Container(
        padding: const EdgeInsets.all(20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                //Icon(Icons.payment, color: Colors.green[500]),
                Text('Recently Used'),
                //const Text('25 min'),
              ],
            ),
          ],
        ),
      );

  Widget buildRowOneRecentFaceId() => Container(
        //padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
          ],
        ),
      );

  Widget buildRowTwoRecentFaceId() => Container(
        //padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
            Column(
              children: <Widget>[
                ProfilePhoto(
                  totalWidth: 60,
                  cornerRadius: 25,
                  color: Colors.green,
                  image: const AssetImage('assets/image.JPG'),
                ),
                const Text('Rose'),
              ],
            ),
          ],
        ),
      );
}
