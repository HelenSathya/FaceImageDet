import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    //print("Payment success: " + response.paymentId);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    //print("Payment error: " + response.code.toString() + " - " + response.message);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    //print("External wallet: " + response.walletName);
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_4IEvhTDBQjtvqa',
      'amount': 1, // Amount in paise (Example: 1000 paise = ₹10)
      'name': 'Flutter Razorpay Example',
      'description': 'Test Payment',
      'prefill': {'contact': '9789905172', 'email': 'helsyaj@gmail.com'},
      'external': {
        'wallets': ['upi'],
      },
    };

    try {
      razorpay.open(options);
    } catch (e) {
      //debugPrint(e);
    }
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razorpay UPI Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            openCheckout();
          },
          child: Text('Make UPI Payment'),
        ),
      ),
    );
  }
}
