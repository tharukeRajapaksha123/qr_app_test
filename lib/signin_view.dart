import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:qr_app_test/dummy.dart';
import 'package:url_launcher/url_launcher.dart';

class SigninView extends StatefulWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
      ),
      body: load
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      const Spacer(),
                      TextFormField(
                        validator: (val) => val != null
                            ? val.isEmpty
                                ? "Please fill this field"
                                : null
                            : null,
                        controller: email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (val) => val != null
                            ? val.isEmpty
                                ? "Please fill this field"
                                : null
                            : null,
                        obscureText: true,
                        controller: password,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: kToolbarHeight,
                        color: Colors.amber,
                        elevation: 0,
                        onPressed: () async {
                          await auth("login");
                        },
                        child: const Text("Signin"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: kToolbarHeight,
                        color: Colors.lightBlue,
                        elevation: 0,
                        onPressed: () async {
                          await auth("signup");
                        },
                        child: const Text("Register"),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> auth(String parameter) async {
    if (_key.currentState!.validate()) {
      setState(() {
        load = !load;
      });
      final response = await http.post(
        Uri.parse(
          "https://0ba0-112-134-137-87.ap.ngrok.io/$parameter",
        ),
        body: {
          "email": email.text,
          "password": password.text,
        },
      );

      if (response.statusCode == 201) {
        final snackBar = SnackBar(content: Text("$parameter succesfull"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar =
            SnackBar(content: Text("$parameter failed please try again"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        load = !load;
      });
    }
  }
}
