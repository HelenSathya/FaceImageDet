import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PayeeDetailsScreen extends StatefulWidget {
  @override
  _PayeeDetailsScreenState createState() => _PayeeDetailsScreenState();
}

class _PayeeDetailsScreenState extends State<PayeeDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  void savePayeeDetails() {
    if (_formKey.currentState!.validate()) {
      // Validation passed, insert payee details into Firestore
      final CollectionReference payeesCollection =
      FirebaseFirestore.instance.collection('payees');

      payeesCollection.add({
        'name': nameController.text,
        'upiId': upiIdController.text,
        'mobile': mobileController.text,
      });

      // Clear the text fields after saving
      nameController.clear();
      upiIdController.clear();
      mobileController.clear();
    }
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? validateUpiId(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a UPI ID';
    }
    // You can add more specific validation for UPI ID here if needed.
    return null;
  }

  String? validateMobile(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a mobile number';
    }
    // You can add more specific validation for mobile numbers here if needed.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Receiver Name'),
                validator: (value) => validateName(value),
              ),
              TextFormField(
                controller: upiIdController,
                decoration: InputDecoration(labelText: 'Receiver UPI ID'),
                validator: (value) => validateUpiId(value),
              ),
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(labelText: 'Receiver Mobile Number'),
                validator: (value) => validateMobile(value),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: savePayeeDetails,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}