import 'dart:io';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:upi_india/upi_india.dart';

class PaymentTransactionScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentTransactionScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app, String upiId, String name, String transactionNote, double amount) async {
      return _upiIndia.startTransaction(
        app: app,
        receiverUpiId: upiId,
        receiverName: name,
        transactionRefId: 'Testing Upi India Plugin',
        transactionNote: transactionNote,
        amount: amount,
        merchantId: '');
  }
  
  performPayment(UpiApp app) {
    print('Perform payment clicked..');
    // Implement your payment logic here
    String upiId = searchController.text;
    String transactionNote = noteController.text;
    double amount = double.tryParse(amountController.text) ?? 0.0;
    print(upiId);print(transactionNote);print(amount);

    // You can add further validation and payment processing here
    initiateTransaction(app, upiId, "Helen", transactionNote, amount);

    // Clear the input fields after payment
    searchController.clear();
    noteController.clear();
    amountController.clear();
  }
  
  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  String? validateMobileUpiId(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a UPI ID or Mobile Number';
    }
    // You can add more specific validation for UPI ID here if needed.
    return null;
  }

  String? validateAmount(String? value) {
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
        backgroundColor: Colors.blue.shade900,
        title: const Text("Integrate UPI"),
      ),
      body: Column(
        children: <Widget>[
          //child: Expanded(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            //children: [
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(labelText: 'Search by UPI ID or Mobile No'),
                validator: (value) => validateMobileUpiId(value),
              ),
              TextFormField(
                controller: noteController,
                decoration: InputDecoration(labelText: 'Transaction Note'),
              ),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => validateAmount(value),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: displayUpiApps(),
              )
              //ElevatedButton(
                //onPressed: performPayment(app),
                //child: Text('Pay'),
              //),
            ],
          ),
          //Expanded(
            //child: displayUpiApps(),
          //),
       // ],
     // ),
    );
  }

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  
  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
                body,
                style: value,
              )),
        ],
      ),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  //_transaction = initiateTransaction(app);
                  performPayment(app);
                  setState(() {});
                },
                child: SizedBox(
                  height: 200,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.lightBlue.shade200,
                        child: const Icon(
                          Icons.payment,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }
}
