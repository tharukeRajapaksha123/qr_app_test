import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController name = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController courseName = TextEditingController();

  final _key = GlobalKey<FormState>();

  GlobalKey globalKey = GlobalKey();

  String get output =>
      'Name : ${name.text}\nPassword : ${password.text}\nCourse Name : ${courseName.text}';

  bool shouldGenerate = false;
  bool shouldLoad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Generator"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textEditForField(name, "Name"),
                textEditForField(password, "Password", password: true),
                textEditForField(courseName, "Course Name"),
                MaterialButton(
                  color: Colors.amber,
                  elevation: 0,
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      setState(() {
                        shouldGenerate = true;
                      });
                    }
                  },
                  child: const Text("Generate QR Token"),
                ),
                if (shouldGenerate)
                  RepaintBoundary(
                    key: globalKey,
                    child: QrImage(
                      data: output,
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return Center(
                          child: Text(
                            "Uh oh! Something went wrong... $err",
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                if (shouldGenerate)
                  shouldLoad
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        )
                      : MaterialButton(
                          color: Colors.green,
                          elevation: 0,
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: _captureAndSharePng,
                          child: const Text("Save"),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textEditForField(TextEditingController controller, String hintText,
          {bool password = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: TextFormField(
          controller: controller,
          obscureText: password,
          validator: (val) => val != null
              ? val.isEmpty
                  ? "Please fll this field"
                  : null
              : null,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );

  Future<void> _captureAndSharePng() async {
    setState(() {
      shouldLoad = true;
    });
    try {
      final RenderRepaintBoundary boundary = globalKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      const SnackBar snackBar = SnackBar(
        content: Text("Image saved"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      SnackBar snackBar = SnackBar(
        content: Text("Image saving failed ${e.toString()}"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      shouldLoad = false;
    });
  }
}
