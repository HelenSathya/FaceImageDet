//import 'package:digi_wall/pages/FaceRecognitionData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//void main() async {
//WidgetsFlutterBinding.ensureInitialized();
//await Firebase.initializeApp();
// runApp(MyApp());
//}

class AddBankDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Digital Wallet Face Recognition'),
        ),
        body: AddBankDetailsState(),
      ),
    );
  }
}

class AddBankDetailsState extends StatelessWidget {
  String _accountType = '';
  String _accountCategory = '';
  String _beneficiaryType = '';

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _ifscCodeController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _confirmAccountNumberController =
      TextEditingController();
  TextEditingController _beneficiaryNationalityController =
      TextEditingController();

  final List<String> accountTypes = ['Debit', 'Current'];
  final List<String> accountCategories = ['Domestic', 'NRE', 'NRO'];
  final List<String> beneficiaryTypes = ['Individual', 'Others'];

  final bankDetailsArr = {
    'Beneficiary type': '',
    'Nationality': '',
    'Nick name': '',
    'accountCategory': '',
    'accountNo': '',
    'accountType': '',
    'id': '',
    'ifscCode': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bank Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nickNameController,
                decoration: InputDecoration(labelText: 'Nick Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Nick Name';
                  }
                  return null;
                },
                //onSaved: (value) {
                //_bankDetData['Beneficiary type'] = _nickNameController.text;
                //},
              ),
              TextFormField(
                controller: _ifscCodeController,
                decoration: InputDecoration(labelText: 'IFSC Code'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter IFSC Code';
                  }
                  return null;
                },
                //onSaved: (value) {
                //_bankDetData['Beneficiary type'] = value;
                //},
              ),
              //DropdownButtonFormField<String>(
              //value: _accountType,
              //onChanged: (String? newValue) {
              //setState(() {
              //_accountType != newValue;
              //});
              //},
              //items: accountTypes.map((String type) {
              //return DropdownMenuItem<String>(
              //value: type,
              //child: Text(type),
              //);
              //}).toList(),
              //decoration: InputDecoration(labelText: 'Account Type'),
              //validator: (value) {
              //if (value == null) {
              //return 'Please select Account Type';
              // }
              //return null;
              //},
              //),
              //DropdownButtonFormField<String>(
              //value: _accountCategory,
              //onChanged: (String? newValue) {
              //setState(() {
              //_accountCategory != newValue;
              //});
              //},
              //items: accountCategories.map((String category) {
              //return DropdownMenuItem<String>(
              //value: category,
              //child: Text(category),
              //);
              //}).toList(),
              //decoration: InputDecoration(labelText: 'Account Category'),
              //validator: (value) {
              //if (value == null) {
              //return 'Please select Account Category';
              //}
              //return null;
              //},
              //),
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(labelText: 'Account Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Account Number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmAccountNumberController,
                decoration:
                    InputDecoration(labelText: 'Confirm Account Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Confirm Account Number';
                  }
                  if (value != _accountNumberController.text) {
                    return 'Account Numbers do not match';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _beneficiaryNationalityController,
                decoration:
                    InputDecoration(labelText: 'Beneficiary Nationality'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Beneficiary Nationality';
                  }
                  return null;
                },
              ),
              //DropdownButtonFormField<String>(
              //value: _beneficiaryType,
              //onChanged: (String? newValue) {
              //setState(() {
              //_beneficiaryType != newValue;
              //});
              //},
              //items: beneficiaryTypes.map((String type) {
              //return DropdownMenuItem<String>(
              //value: type,
              //child: Text(type),
              //);
              //}).toList(),
              //decoration: InputDecoration(labelText: 'Beneficiary Type'),
              //validator: (value) {
              //if (value == null) {
              //return 'Please select Beneficiary Type';
              //}
              //return null;
              //},
              //),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the form data or perform any other action
                    //bankDetailsArr['BeneficiaryType'] = value;
                    bankDetailsArr['Nationality'] =
                        _beneficiaryNationalityController.text;
                    bankDetailsArr['NickName'] = _nickNameController.text;
                    //bankDetailsArr['accountCategory'] = value;
                    bankDetailsArr['accountNo'] = _accountNumberController.text;
                    //bankDetailsArr['accountType'] = value;
                    //bankDetailsArr['id'] = value;
                    bankDetailsArr['ifscCode'] = _ifscCodeController.text;
                    _submitBankDetails(bankDetailsArr);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitBankDetails(bankDetailsArr) {
    // Get a reference to the Firestore collection "BankDet"
    final bankDetCollection = FirebaseFirestore.instance.collection('BankDet');
    final _formKey = GlobalKey<FormState>();
    // Add the data to Firestore using the reference
    bankDetCollection.add(bankDetailsArr).then((value) {
      print('Data saved successfully!');
      // Clear the form after successful data save
      _formKey.currentState!.reset();
    });
  }
}
