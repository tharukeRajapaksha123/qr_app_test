import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_app_test/scan_qr_view.dart';
import 'package:scan/scan.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseOptionView extends StatefulWidget {
  const ChooseOptionView({super.key});

  @override
  State<ChooseOptionView> createState() => _ChooseOptionViewState();
}

class _ChooseOptionViewState extends State<ChooseOptionView> {
  File? file;

  Future<void> pickImageFromGallery() async {
    try {
      final f = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (f != null) {
          file = File(f.path);
        }
      });
    } catch (err) {
      print("pick image failed $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            MaterialButton(
              color: Colors.amber,
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScanQrView()));
              },
              child: Text("From Camera"),
            ),
            MaterialButton(
              color: Colors.red,
              onPressed: () async {
                pickImageFromGallery();
              },
              child: Text("From Gallery"),
            ),
            if (file != null)
              Image.file(
                file!,
                width: MediaQuery.of(context).size.width,
                height: 600,
                fit: BoxFit.fitWidth,
              ),
            if (file != null)
              MaterialButton(
                color: Colors.amber,
                onPressed: () async {
                  await decode(file!.path);
                },
                child: Text("Scan QR"),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future decode(String file) async {
    String? result = await Scan.parse(file);
    if (result != null) {
      try {
        String email = result.split(",")[0];
        String password = result.split(",")[1];

        Uri url = Uri.parse(
            "https://dgmentorparticipantdemo.web.app/#/signin?email=$email&password=$password");
        print(url);
        if (await canLaunchUrl(url)) {
          {
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          }
        }
      } catch (err) {
        print("------------------------------------ ural lancher failed $err");
      }
    } else {
      const snackBar =
          SnackBar(content: Text("Couldnt find any qr code in this image"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
