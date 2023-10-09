//import 'package:digi_wall/pages/FaceRecognitionData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchBankDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Digital Wallet Face Recognition'),
        ),
        body: FaceRecognitionList(),
      ),
    );
  }
}

class FaceRecognitionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Step 1: Create a Query reference for the "digitalwalletfacerecog" collection
    final CollectionReference digitalWalletCollection =
        FirebaseFirestore.instance.collection('digitalwalletfacerecog');

    return StreamBuilder<QuerySnapshot>(
      // Step 2: Use the Query reference to listen to updates and fetch data
      //stream: digitalWalletCollection.snapshots(),
      stream: FirebaseFirestore.instance.collection('BankDet').snapshots(),
      builder: (context, snapshot) {
        //final faceRecogDocs = snapshot.data!.docs;
        if (snapshot.hasError) {
          return Text('Error fetching data');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Data snapshot has been received
        final bankDetails = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bankDetails.length,
          itemBuilder: (context, index) {
            final bankDetData =
                bankDetails[index].data() as Map<String, dynamic>;
            return Card(
              //return SwitchListTile(
              child: ListTile(
                title: Text('Nick name: ${bankDetData?['Nick name'] ?? 'N/A'}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Nationality: ${bankDetData?['Nationality'] ?? 'N/A'}'),
                    Text(
                        'Beneficiary Type: ${bankDetData['Beneficiary type']}'),
                    Text(
                        'Account Category: ${bankDetData?['accountCategory'] ?? 'N/A'}'),
                    Text('Account No: ${bankDetData?['accountNo'] ?? 'N/A'}'),
                    Text(
                        'Account Type: ${bankDetData?['accountType'] ?? 'N/A'}'),
                    Text('ID: ${bankDetData?['id'] ?? 'N/A'}'),
                    Text('IFSC Code: ${bankDetData?['ifscCode'] ?? 'N/A'}'),
                    //onChanged: (bool value) {
                    //setState(() {
                    //appliances[index].isOn = value;
                    //});
                    //},
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
