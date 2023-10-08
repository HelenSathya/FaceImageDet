import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AddBankDetails.dart';

class MyProfileDetailsPage extends StatelessWidget {
  // Sample profile data
  //final String name;
  //final String faceId;
  //final String personalInfo;
  //final String bankAccountDetails;
  //final String email;
  //final String mobile;
  final Map<String, dynamic>? faceDetails;

  //MyProfileDetailsPage({
    //required this.name,
    //required this.faceId,
    //required this.personalInfo,
    //required this.bankAccountDetails,
    //required this.email,
    //required this.mobile,
  //});

  MyProfileDetailsPage({required this.faceDetails});

  onProfileBankIconTap(BuildContext context) {
    print('Profile Details in Landing Page...');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBankDetails()),
    );
    // This function will be called when the user taps on the bank icon.
    //print('Bank icon tapped!');
    //Navigator.push(
    //context,
    //MaterialPageRoute(builder: (context) => FetchBankDetails()),
    //);
    // Add your custom logic here for what should happen when the bank icon is tapped.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: faceDetails != null
              ? DataTable(
            columns: [
              const DataColumn(
                  label: Text('Name', style: TextStyle(color: Colors.blue))),
              DataColumn(
                  label: Text('${faceDetails!['name']}', style: const TextStyle(color: Colors.blue))),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Face ID', style: TextStyle(color: Colors.blue))),
                DataCell(Text('${faceDetails!['faceId']}', style: const TextStyle(color: Colors.blue))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Personal Info',
                    style: TextStyle(color: Colors.blue))),
                DataCell(Text('${faceDetails!['personalInfo']}',
                    style: const TextStyle(color: Colors.blue))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Email', style: TextStyle(color: Colors.blue))),
                DataCell(Text('${faceDetails!['email']}', style: const TextStyle(color: Colors.blue))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Mobile', style: TextStyle(color: Colors.blue))),
                DataCell(Text('${faceDetails!['mobile']}', style: const TextStyle(color: Colors.blue))),
              ]),
              DataRow(cells: [
                const DataCell(
                    Text('Bank Details', style: TextStyle(color: Colors.blue))),
                //DataCell(Icon(Icons.account_balance, color: Colors.green[500])),
                DataCell(
                  InkWell(
                    onTap: onProfileBankIconTap(
                        context), // Call the function when tapped.
                    child: const Icon(Icons.account_balance),
                  ),
                ),
              ]),
            ],
          ):const Text('Profile details not found.'),
        ),
      ),
    );
  }
}

//void main() {
//runApp(MaterialApp(
//home: MyProfileDetailsPage(
//name: 'John Doe',
//faceId: '123456789',
//personalInfo: 'I am a software engineer',
//bankAccountDetails: 'Account Number: 1234567890',
//email: 'john.doe@example.com',
//mobile: '9876543210',
//),
//));
//}
