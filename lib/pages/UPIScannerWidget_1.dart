import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UPIScannerWidget_1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UPIScannerWidgetState();
}

class _UPIScannerWidgetState extends State<UPIScannerWidget_1> {
    //implements PluginRegistry.RequestPermissionsResultListener {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    result = scanData;
                    // Extract and process the UPI ID from 'result'
                    if (result != null) {
                      String? upiId = result!.code;
                      // You can handle the UPI ID here as needed
                      print('Scanned UPI ID: $upiId');
                    }
                  });
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                'Scanned UPI ID: ${result!.code}',
                style: TextStyle(fontSize: 20),
              )
                  : Text('Scan a UPI ID QR Code'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onRequestPermissionsResult(int requestCode, List<String> permissions, List<int> grantResults) {
    // Handle permission requests here, if needed
  }

  @override
  void dispose() {
    super.dispose();
  }
}
