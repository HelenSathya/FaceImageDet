//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:digi_wall/pages/FaceRecognitionData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../DataBase/FetchBankDetails.dart';

class BankDetailsPage extends StatefulWidget {
  @override
  BankDetailsPageState createState() => BankDetailsPageState();
}

class BankDetailsPageState extends State<BankDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var bankDetailSize = fetchBankDetSize();
    // Replace with the list size from DB
    //if (bankDetailSize > 0) {
    return FetchBankDetails();
    //} else {
    //Firebase.initializeApp();
    //return AddBankDetails();
    //}
  }

  int fetchBankDetSize() {
    // Get a reference to the Firestore collection "BankDet"
    final bankDetCollection = FirebaseFirestore.instance.collection('BankDet');
    var size = 0;
    // Get the documents in the collection and count them
    bankDetCollection.get().then((querySnapshot) {
      size = querySnapshot.size;
      print('Size of BankDet: $size');
    }).catchError((error) {
      print('Error fetching BankDet size: $error');
    });
    return size;
  }
}

//void _submitBankDetails() {
// Implement the logic to save the bank details here
// Retrieve the form field values using _nickNameController.text, _ifscCodeController.text, etc.
//}
/*Widget listBankDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('digitalwalletfacerecog')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error fetching data');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        // Data snapshot has been received
        final faceRecogDocs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: faceRecogDocs.length,
          itemBuilder: (context, index) {
            final faceRecogData = faceRecogDocs[index].data();
            return ListTile(
              title: Text(
                  'Beneficiary Type: ${faceRecogData['Beneficiary type'] ?? 'N/A'}'),
              subtitle:
                  Text('Nationality: ${faceRecogData['Nationality'] ?? 'N/A'}'),
              // Display other fields similarly
            );
          },
        );
      },
    );
  }*/
//}

//void main() {
//runApp(MaterialApp(
//home: BankDetailsPage(),
//));
//}
