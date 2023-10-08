//import 'package:assignment_g7_cpa/pages/successpage.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBankDetailsPage extends StatefulWidget {
  const AddBankDetailsPage({super.key});

  @override
  State<AddBankDetailsPage> createState() => AddBankDetailsPageState();
}

class AddBankDetailsPageState extends State<AddBankDetailsPage> {
  final _textcontroller = TextEditingController();
  final _moneycontroller = TextEditingController();
  final _datecontroller = TextEditingController();

  late DatabaseReference dbref;

//Query dbref = FirebaseDatabase.instance.ref().child('Budget');

  @override
  void initState() {
    super.initState();
    //dbref = FirebaseDatabase.instance.ref().child('digitalwalletfacerecog');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Add your expense')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            TextField(
              controller: _textcontroller,
              decoration: const InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 35),
            TextField(
              controller: _moneycontroller,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                  hintText: 'Add budget',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _datecontroller,
              //  keyboardType: TextInputType.datetime,
              //  maxLength: 10,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today_rounded),
                  hintText: 'Date (dd-mm-yyyy)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              readOnly: true,
              onTap: (() async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat("dd-MM-yyyy").format(pickedDate);
                  setState(() {
                    _datecontroller.text = formattedDate.toString();
                  });
                }
              }),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Map<String, String> budget = {
                        'name': _textcontroller.text,
                        'money': _moneycontroller.text,
                        'date': _datecontroller.text,
                      };
                      //dbref.push().set(budget);
                      _moneycontroller.clear();
                      _textcontroller.clear();
                      _datecontroller.clear();
                      //Navigator.push(
                      //context,
                      //MaterialPageRoute(builder: (BuildContext context) {
                      //return const SuccessPage();
                      //}),
                      //);
                    },
                    child: const Text('Save')),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
