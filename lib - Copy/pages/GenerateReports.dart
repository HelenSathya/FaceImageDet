import 'package:flutter/material.dart';
//import 'package:pdf/pdf.dart';
//import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';

class GenerateReports extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<GenerateReports> {
  late DateTime startDate;
  late DateTime endDate;
  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
  }

  // Function to generate the PDF report
  Future<void> generatePDFReport() async {
    if (startDate == null || endDate == null) {
      // Handle error: Dates not selected
      return;
    }

    // Format the selected dates as strings
    final startDateStr = startDate.toLocal().toString().split(' ')[0];
    final endDateStr = endDate.toLocal().toString().split(' ')[0];

    // Fetch transaction details from Firestore based on the selected date range
    final transactions = await fetchTransactions(startDateStr, endDateStr);

    // Generate the PDF report
    // Generate the PDF report
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          final List<pw.Widget> content = [];

          content.add(pw.Header(
            level: 0,
            text: 'Transaction Report',
          ));

          content.add(pw.Paragraph(text: 'Report Duration: $startDateStr - $endDateStr'));

          content.add(pw.Table.fromTextArray(
            headers: ['Serial Number', 'Transaction Date', 'UPI ID/Mobile', 'Transaction Note', 'Amount'],
            data: transactions.map((txn) => [txn['serial'], txn['date'], txn['upiOrMobile'], txn['note'], txn['amount']]).toList(),
          ));

          return pw.Column(children: content);
        },
      ),
    );

    // Save the PDF file
    final pdfFile = await pdf.save();

    // You can now use pdfFile to do anything you want, like saving it to device storage or sharing it.
  }

  Future<List<Map<String, dynamic>>> fetchTransactions(String startDate, String endDate) async {
    final CollectionReference transactionsCollection = FirebaseFirestore.instance.collection('transactions');
    final QuerySnapshot querySnapshot = await transactionsCollection
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectStartDate(context);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                      ),
                      child: Text(startDate != null ? startDate.toLocal().toString().split(' ')[0] : 'Select date'),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectEndDate(context);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date',
                      ),
                      child: Text(endDate != null ? endDate.toLocal().toString().split(' ')[0] : 'Select date'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: generatePDFReport,
              child: Text('Generate PDF Report'),
            ),
          ],
        ),
      ),
    );
  }
}
