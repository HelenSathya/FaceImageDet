import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provide;
import 'package:upi_pay_app/pages/FaceIdModel.dart';
import 'package:upi_pay_app/pages/FaceRecognition/HomeScreen.dart';
import 'package:upi_pay_app/pages/HomeLandingPage.dart';
import 'app/core/local_storage/app_storage.dart';

//void main() => runApp(LoginApp());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: FirebaseOptions(
      appId: '1:437135574733:android:41e8e864cf328c62a24b84',
      apiKey: 'AIzaSyDMkoZg79QxlqoayoOmBvwKCp_ZH44r82U',
      projectId: 'digitalwalletfacerecog',
      messagingSenderId: '',
      // Add other required Firebase options
    ),
  );
  //runApp(LoginApp());
  //runApp(const MaterialApp(home:HomeScreen()));
  final appStorage = AppStorage();
  appStorage.initAppStorage();
  runApp(
    ProviderScope(
      overrides: [
        appStorageProvider.overrideWithValue(appStorage),
      ],
      //child: const MaterialApp(home:HomeScreen()) //const App(),
      child: MaterialApp(home:LoginApp()) //const App(),
    ),
  );
}

class LoginApp extends StatelessWidget {
  //@override
  //Widget build(BuildContext context) {
  //return MaterialApp(
  //debugShowCheckedModeBanner: false,
  //home: LoginPage(),
  //);
  //}
  @override
  Widget build(BuildContext context) {
    return provide.ChangeNotifierProvider(
      create: (_) => FaceIdModel(), // Provide the FaceIdModel instance
      child: MaterialApp(
        title: 'Digital Wallet With Face Recognition',
        debugShowCheckedModeBanner: false,
        home: LoginPage(), // Set the LoginPage as the initial route
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  // Placeholder function for Face ID validation
  bool validateFaceId(String faceId) {
    // Replace this with your actual Face ID validation logic - DB

    return faceId == "sample_face_id";
  }

  Future<String> fetchFaceDetRecord(String faceId) async {
    // Get a reference to the FaceDet collection
    CollectionReference faceDetCollection =
    FirebaseFirestore.instance.collection('FaceDet');

    try {
      // Query the collection using the given faceId
      QuerySnapshot querySnapshot =
      await faceDetCollection.where('faceId', isEqualTo: faceId).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isEmpty) {
        // If no documents match the query, return the message
        return 'faceId not available in DB';
      } else {
        // If a matching document is found, return the document data (or do something with it)
        // In this example, we return the first document's data as a JSON string
        return querySnapshot.docs.first.data().toString();
      }
    } catch (e) {
      // Handle any errors that occur during the fetch process
      print('Error fetching record: $e');
      return 'Error fetching record';
    }
  }

  void _login(BuildContext context, String faceId) async {
    String recordData = await fetchFaceDetRecord(faceId);

    if (recordData == 'faceId not available in DB') {
      // Show an error dialog if the faceId is not available in the database
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
          Text('Face ID not available in the database. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      //Add the faceId in session

      // Navigate to the landing page if the faceId is valid
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeLandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController faceIdController = TextEditingController();
    final faceIdModel = provide.Provider.of<FaceIdModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: faceIdController,
                decoration: InputDecoration(
                  labelText: 'Face ID',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Replace "sample_face_id" with the value from the Face ID textbox
                  String loggedInFaceId = faceIdController.text;
                  final faceIdModel = provide.Provider.of<FaceIdModel>(context, listen: false);

                  if (loggedInFaceId != null) {
                    faceIdModel?.setFaceId(loggedInFaceId);
                    _login(context, loggedInFaceId);
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigate to the sign-up page
                  // Replace LandingPage() with your actual sign-up page
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (context) => SignUpPage()),
                  //);
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Text('Welcome to the landing page!'),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(
        child: Text('Sign-up page content goes here.'),
      ),
    );
  }
}
