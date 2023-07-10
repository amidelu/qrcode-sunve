import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/utils/constants.dart';

import 'screens.dart';

class InstallScreen extends StatefulWidget {
  const InstallScreen({super.key});

  @override
  _InstallScreenState createState() => _InstallScreenState();
}

class _InstallScreenState extends State<InstallScreen> {
  final storage = GetStorage();
  final String successMessage = 'done';
  final String failedMessage = 'failed';
  int appId = 0;
  String status = '';

  @override
  void initState() {
    super.initState();
    appId = storage.read(appID);
    status = storage.read(status);
    _checkInstallationStatus();
  }

  Future<void> _checkInstallationStatus() async {
    if (appId.toString().isNotEmpty) {
      if (status == 'done') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QRScanScreen(),
          ),
        );
      } else {
        setState(() {
          storage.write(status, 'failed');
        });
      }
    } else {
      final randomId = Random().nextInt(10000);
      storage.write(appID, randomId);
      storage.write(status, 'new');

      final String response = successMessage;

      if (response.contains(successMessage)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScanScreen()),
        );
      } else {
        setState(() {
          storage.write(status, 'failed');
        });
      }

      //   // Generate a random app ID and set status as 'new'
      //   final Random random = Random();
      //   final int randomId = random.nextInt(10000);
      //   appId = randomId.toString();
      //   status = 'new';
      //
      //   // Insert app data into SQLite database
      //   // await DatabaseHelper.instance.insertAppData(appId, status);
      //
      //   // Send app data to API
      //   final String response =
      //       successMessage; //await ApiService.sendDataToApi(appId);
      //
      //   if (response == successMessage) {
      //     // Update status as 'done'
      //     //await DatabaseHelper.instance.updateStatus(appId, 'done');
      //
      //     // Redirect to QR scan screen on success
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => QRScanScreen()),
      //     );
      //   } else {
      //     // Show retry button on failure
      //     setState(() {
      //       status = 'failed';
      //     });
      //   }
      // } else {
      //   if (results.first['status'] == 'done') {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => QRScanScreen()),
      //     );
      //   } else {
      //     setState(() {
      //       status = 'failed';
      //     });
      //   }
      // }
      //
      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Install Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'App ID: $appId',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            if (status == 'new')
              const CircularProgressIndicator()
            else if (status == 'done')
              ElevatedButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScanScreen()),
                  );
                },
              )
            else if (status == 'failed')
              ElevatedButton(
                child: const Text('Try Again'),
                onPressed: () async {
                  // Reset status and check installation again
                  setState(() {
                    status = '';
                  });
                  await _checkInstallationStatus();
                },
              ),
          ],
        ),
      ),
    );
  }
}
