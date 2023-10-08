import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'PaymentScreen.dart';

//void main() {
  //runApp(MyApp());
//}

class RazorpayPaymtIntegration extends StatelessWidget {
  final razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    return MaterialApp(
      title: 'Razorpay UPI Payment Example',
      home: PaymentScreen(),
    );
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
}
