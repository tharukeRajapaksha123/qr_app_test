import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({Key? key}) : super(key: key);

  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  ScanController controller = ScanController();
  String qrcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // custom wrap size
          height: 250,
          child: ScanView(
            controller: controller,
// custom scan area, if set to 1.0, will scan full area
            scanAreaScale: .7,
            scanLineColor: Colors.green.shade400,
            onCapture: (data) async {
              String email = data.split(",")[0];
              String password = data.split(",")[1];

              Uri url = Uri.parse(
                  "https://dgmentorparticipantdemo.web.app/#/signin?email=$email&password=$password");

              if (await canLaunchUrl(url)) {
                {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.pause();
    super.dispose();
  }
}
