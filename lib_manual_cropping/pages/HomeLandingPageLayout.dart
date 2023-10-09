import 'package:flutter/material.dart';
//import 'package:fashion_app/color_filters.dart';

class HomeLandingPageLayout extends StatefulWidget {
  @override
  _HomeLandingPageLayoutState createState() => _HomeLandingPageLayoutState();
}

class _HomeLandingPageLayoutState extends State<HomeLandingPageLayout> {
  final double _borderRadious = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Wallet'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [buildSearchInput()],
      ),
    );
  }

  Widget buildSearchInput() => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.search, color: Colors.green[500]),
                //const Text('PREP:'),
                //const Text('25 min'),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Search FaceId',
                    ),
                  ),
                )
                //Icon(Icons.timer, color: Colors.green[500]),
                //const Text('COOK:'),
                //const Text('1 hr'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.restaurant, color: Colors.green[500]),
                //const Text('FEEDS:'),
                //const Text('4-6'),
              ],
            ),
          ],
        ),
      );
}
