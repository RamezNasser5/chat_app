import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> registrationWithEmailAndPassword(
    String? email, String? password) async {
  // ignore: unused_local_variable
  UserCredential user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email!, password: password!);
}

void showScaffoldMessenger(BuildContext context, String messege) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messege),
    ),
  );
}
