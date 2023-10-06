import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';

import 'package:provider/provider.dart';

import '../app/app.dart';
import '../app/core/local_storage/app_storage.dart';
import 'BankDetailsPage.dart';
import 'FaceIdModel.dart';
import 'GenerateReports.dart';
import 'LogoutPage.dart';
import 'MyImagePicker.dart';
import 'MyImagePickerPage.dart';
import 'MyProfileDetailsPage.dart';
import 'PayeeDetailsScreen.dart';
import 'PaymentTransactionScreen.dart';
import 'RazorpayPaymtIntegration.dart';
//import 'UPIScannerWidget.dart';
import 'UPIScannerWidget_1.dart';
import 'UpiPaymentScreen.dart';
//import 'package:fashion_app/color_filters.dart';

class HomeLandingPage extends StatefulWidget {
  @override
  _HomeLandingPageState createState() => _HomeLandingPageState();
}

//enum SubMenu { MyProfile, Settings }

//enum Options { search, upload, copy, exit }

class _HomeLandingPageState extends State<HomeLandingPage> {
  final double _borderRadious = 24;
  //MyProfilePage myProfilePage = MyProfilePage();
  //BankDetailsPage BankDetailsPage = BankDetailsPage();
  //MyProfileDetailsPage MyProfileDetailsPage = MyProfileDetailsPage();

  Future<Map<String, dynamic>?> getFaceDetails(String faceId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      print('Face Id : $faceId');
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await _firestore.collection('FaceDet').doc(faceId).get();

      print(documentSnapshot.exists);

      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      } else {
        print('Document does not exist');
        return null; // Document does not exist
      }
    } catch (e) {
      print('Error fetching face details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchTextField(),
        //title: Text('Profile Page'),
        actions: [
          // Search Icon
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              String searchText =  searchController.text;
              print('Search button pressed.....'+searchText);
            },
          ),
          // Profile Picture and Menu List
          PopupMenuButton<String>(
            onSelected: (value) async {
              // TODO: Handle menu item selection
              if (value == 'My Profile') {
                //Fetch the data from DB and load the profile details page.
                final faceIdModel = Provider.of<FaceIdModel>(context, listen: false);
                String? faceId = faceIdModel.faceId;
                //final faceDetails = getFaceDetails(faceId);
                //final DocumentSnapshot faceDetailsSnapshot =  getFaceDetails(faceId!) as DocumentSnapshot<Object?>;
                //final Map<String, dynamic>? faceDetailsData = faceDetailsSnapshot.data() as Map<String, dynamic>?;
                final Map<String, dynamic>? faceDetails = await getFaceDetails(faceId!);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return MyProfileDetailsPage(faceDetails: faceDetails);
                    //return HomeLandingPageLayout();
                  }),
                );
                //return MyProfilePage();
                print('My Profile selected');
              } else if (value == 'Settings') {
                print('Settings selected');
              } else if (value == 'Logout') {
                print('Logout selected');
                //callLogout();
                LogoutPage();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'My Profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('My Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //_buildStack(),
          //buildSearchInput(),
          // Profile Picture (you can replace the Image.asset with your actual profile image)
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/image.png'),
          ),
          SizedBox(height: 20),
          // TextField (you can customize the TextField as per your requirements)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            //decoration: BoxDecoration(
            //color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
           /* child: TextField(
              decoration: const InputDecoration(
                //color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                hintText: 'Search By FaceId...',
              ),
              onChanged: (value) {
                // TODO: Handle text field changes
                print('Text field value: $value');
              },
            ),*/
          ),
          buildRowOneMenu(),
          buildRowTwoMenu(),
          buildRowThreeMenu(),
          buildRowOneRecentFaceId(),
          buildRowTwoRecentFaceId()
        ],
      ),
    );
  }

  List<int> _searchIndexList = [];

  List<String> _list = ['English Textbook', 'Japanese Textbook', 'English Vocabulary', 'Japanese Vocabulary'];
  TextEditingController searchController = TextEditingController();

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < _list.length; i++) {
            if (_list[i].contains(s)) {
              _searchIndexList.add(i);
            }
          }
        });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      controller: searchController,
        //border: OutlineInputBorder(),
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  LogoutPage callLogout() {
    print('Logout call');
    return LogoutPage();
  }

  Widget buildSearchInput() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //children: <Widget>[
          children: [
            Column(
              children: <Widget>[
                PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                          const PopupMenuItem(
                            child: Text('My Profile'),
                            value: 1,
                          ),
                          const PopupMenuItem(
                            child: Text('Settings'),
                            value: 2,
                          ),
                          const PopupMenuItem(
                            child: Text('Logout'),
                            value: 3,
                          ),
                        ])
              ],
            ),
          ],
        ),
      );

  SubMenu? selectedMenu;

  Widget _buildStack() {
    return Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        IconButton(
          icon: const CircleAvatar(
            backgroundImage: AssetImage('assets/image.png'),
            radius: 25,
          ),
          onPressed: () {
            //Navigator.push(
            //context,
            //MaterialPageRoute(builder: (BuildContext context) {
            //dropdown menu
            //return HomeLandingPage();
            //return HomeLandingPageLayout();
            //}),
            //);
          },
        ),
        //const CircleAvatar(
        //backgroundImage: AssetImage('assets/image.JPG'),
        //radius: 25,
        //),
        //onPressed: () {},
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
                //Icon(Icons.payment, color: Colors.green[500]),
                InkWell(
                  onTap: () => onPayeeIconTap(context),
                  child: Icon(Icons.payment, color: Colors.green[500]),
                ),
                const Text('Payee'),
                //const Text('25 min'),
              ],
            ),
            Column(
              children: [
                //Icon(Icons.account_balance, color: Colors.green[500]),
                InkWell(
                  onTap: () => onBankIconTap(context),
                  child: Icon(Icons.account_balance, color: Colors.green[500]),
                ),
                const Text('Bank'),
                //const Text('1 hr'),
              ],
            ),
            Column(
              children: [
                //Icon(Icons.money, color: Colors.green[500]),
                InkWell(
                  onTap: () => onPaymentIconTap(context),
                  child: Icon(Icons.payment, color: Colors.green[500]),
                ),
                const Text('Payment'),
                //const Text('4-6'),
              ],
            ),
          ],
        ),
      );

  void onBankIconTap(BuildContext context) {
    // This function will be called when the user taps on the Profile icon.
    // Navigate to MyProfileDetailsPage using Navigator.push
    print('Profile Details in Landing Page...');
    Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => BankDetailsPage()),
      //MaterialPageRoute(builder: (context) => BankDetailsPage()),
      //MaterialPageRoute(builder: (context) => MyImagePickerPage()),
      MaterialPageRoute(builder: (context) => MyImagePicker()),
    );
  }

  void onScanQRCodeIconTap(BuildContext context) {
    // This function will be called when the user taps on the Profile icon.
    // Navigate to MyProfileDetailsPage using Navigator.push
    print('UPI ID Details in Landing Page...');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UPIScannerWidget_1()),
    );
  }

  void onPaymentIconTap(BuildContext context) {
    // This function will be called when the user taps on the Reports icon.
    print('Payment icon tapped!');
    Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => UpiApps()),
        MaterialPageRoute(builder: (context) => PaymentTransactionScreen()),
      //MaterialPageRoute(builder: (context) => UpiPaymentScreen()),
      //MaterialPageRoute(builder: (context) => RazorpayPaymtIntegration()),
     //MaterialPageRoute(builder: (context) => App()),
    );
    // Add your custom logic here for what should happen when the Reports icon is tapped.
  }

  void onPayeeIconTap(BuildContext context) {
    // This function will be called when the user taps on the Payee icon.
    print('Payee icon tapped!');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PayeeDetailsScreen()),
      //MaterialPageRoute(builder: (context) => RazorpayPaymtIntegration()),
      //MaterialPageRoute(builder: (context) => App()),
    );
    // Add your custom logic here for what should happen when the Payee icon is tapped.
  }

  void onReportsIconTap() {
    // This function will be called when the user taps on the Reports icon.
    print('Reports icon tapped!');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GenerateReports()),
      //MaterialPageRoute(builder: (context) => RazorpayPaymtIntegration()),
      //MaterialPageRoute(builder: (context) => App()),
    );
    // Add your custom logic here for what should happen when the Reports icon is tapped.
  }

  void onAnalyticsIconTap() {
    // This function will be called when the user taps on the Analytics icon.
    print('Analytics icon tapped!');
    // Add your custom logic here for what should happen when the Analytics icon is tapped.
  }

  Widget buildRowTwoMenu() => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                //IconButton(
                //Icon(Icons.account_circle_rounded, color: Colors.green[500]),
                InkWell(
                  onTap: () => onScanQRCodeIconTap(context),
                  child: Icon(Icons.account_circle_rounded,
                      color: Colors.green[500]),
                ),
                Text('Scan QR'),
                //onPressed: _onSearchButtonPressed(),
                //const Text('25 min'),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () => onReportsIconTap(),
                  child: Icon(Icons.report,
                      color: Colors.green[500]),
                ),
                Text('Reports'),
                //Icon(Icons.report, color: Colors.green[500]),
                //const Text('Reports'),
                //const Text('1 hr'),
              ],
            ),
            Column(
              children: [
                Icon(Icons.bar_chart, color: Colors.green[500]),
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
                  image: const AssetImage('assets/image.png'),
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
                  image: const AssetImage('assets/image.png'),
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
                  image: const AssetImage('assets/image.png'),
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
                  image: const AssetImage('assets/image.png'),
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
                  image: const AssetImage('assets/image.png'),
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
                  image: const AssetImage('assets/image.png'),
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
                  image: const AssetImage('assets/image.png'),
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
                  image: const AssetImage('assets/image.png'),
                ),
                const Text('Rose'),
              ],
            ),
          ],
        ),
      );
}
