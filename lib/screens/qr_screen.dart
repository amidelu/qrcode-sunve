import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../api_service.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  String qrCodeData = '';
  bool sendingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scan')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: sendingData ? null : _sendQRCodeData,
                child: const Text('Send'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeData = scanData.code!;
        debugPrint('QR Code: $qrCodeData');
      });
    });
  }

  void _sendQRCodeData() async {
    setState(() {
      sendingData = true;
    });

    final String response = await ApiService.sendDataToApi(qrCodeData);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Result'),
        content: Text(response == 'success'
            ? 'Data sent successfully.'
            : 'Failed to send data.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              if (response == 'success') {
                // Clear QR code data and continue scanning
                setState(() {
                  qrCodeData = '';
                  sendingData = false;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
