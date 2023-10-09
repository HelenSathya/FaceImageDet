import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BankDetailsPage extends StatefulWidget {
  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ifscController = TextEditingController();
  TextEditingController _micrController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _branchController = TextEditingController();

  void _getBankDetails() async {
    final ifscCode = _ifscController.text.trim();
    final apiUrl =
        "https://your-api-service.com/ifsc_code/$ifscCode?api_key=your_api_key_here";

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _micrController.text = data['micr'];
        _bankNameController.text = data['bank_name'];
        _cityController.text = data['city'];
        _branchController.text = data['branch'];
      });
    } else {
      // Handle error or show a message
      print('Failed to fetch bank details');
    }
  }

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
                controller: _ifscController,
                decoration: InputDecoration(labelText: 'IFSC Code'),
                onChanged: (_) => _getBankDetails(),
                validator: (value) {
                  //if (value.isEmpty) {
                    //return 'Please enter IFSC Code';
                  //}
                  // Add any additional validation if required
                  return null;
                },
              ),
              TextFormField(
                controller: _micrController,
                decoration: InputDecoration(labelText: 'MICR No'),
                readOnly: true,
              ),
              TextFormField(
                controller: _bankNameController,
                decoration: InputDecoration(labelText: 'Bank Name'),
                readOnly: true,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                readOnly: true,
              ),
              TextFormField(
                controller: _branchController,
                decoration: InputDecoration(labelText: 'Branch Location'),
                readOnly: true,
              ),
              // Add other form fields like Nick Name, Account Type Dropdown, Account Category Dropdown, etc.

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //if (_formKey.currentState.validate()) {
                    // Save the form data or perform any other action
                  //}
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BankDetailsPage(),
  ));
}
