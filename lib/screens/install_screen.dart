import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  String? appId;
  String? status;

  @override
  void initState() {
    super.initState();
    appId = storage.read(appID) ?? '';
    status = storage.read(status!) ?? '';
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkInstallationStatus();
    });
  }

  Future<void> _checkInstallationStatus() async {
    if (appId!.isNotEmpty && status!.isNotEmpty) {
      if (status == 'done') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QRScanScreen(),
          ),
        );
      } else {
        setState(() {
          storage.write(status!, 'failed');
        });
      }
    } else {
      final randomId = Random().nextInt(10000);
      storage.write(appID, randomId.toString());
      storage.write(status!, 'new');

      final String response = successMessage;

      if (response.contains(successMessage)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScanScreen()),
        );
      } else {
        setState(() {
          storage.write(status!, 'failed');
        });
      }
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
                    MaterialPageRoute(
                        builder: (context) => const QRScanScreen()),
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
