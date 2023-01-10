import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_app_test/choose_option_view.dart';
import 'package:qr_app_test/data_screen.dart';
import 'package:qr_app_test/dummy.dart';
import 'package:qr_app_test/home_screen.dart';
import 'package:qr_app_test/scan_qr_view.dart';
import 'package:qr_app_test/signin_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _sub;

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        print(initialLink);
        if (initialLink.contains("other")) {}
      }
    } on PlatformException {
      print("plactform exception found");
    }
  }

  @override
  void initState() {
    initUniLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => MyHome(),
        "/signin": (context) => SigninView(),
      },
      // onGenerateRoute: (settings) {
      //   final args = ModalRoute.of(context)!.settings.arguments as Dummy;
      //   print(settings.name);
      //   switch (settings.name) {
      //     case "/":
      //       return MaterialPageRoute(
      //         builder: (context) {
      //           return const HomeScreen();
      //         },
      //       );
      //     case "/signin":
      //       return MaterialPageRoute(
      //         builder: (context) {
      //           return DataScreen(
      //             courseName: args.name,
      //             email: args.email,
      //             password: args.password,
      //           );
      //         },
      //       );
      //     default:
      //       return MaterialPageRoute(builder: (context) => Container());
      //   }
      // },
      // home: HomeScreen(),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.amber,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: const Text("Generat QR"),
            ),
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChooseOptionView()));
              },
              child: const Text("Scan QR"),
            ),
          ],
        ),
      ),
    );
  }
}
