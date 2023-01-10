// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  final String email;
  final String password;
  final String courseName;
  const DataScreen({
    Key? key,
    required this.email,
    required this.password,
    required this.courseName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Launched Email : $email"),
          Text("Launched Password : $password"),
          Text("Launched CourseName : $courseName"),
        ],
      ),
    );
  }
}
