// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:chat_app/helper/const.dart';
import 'package:chat_app/helper/functions_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  bool isLoaded = false;

  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> loginWithEmailAndPassword() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoaded,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
          child: Form(
            key: formKey,
            child: ListView(children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'lib/assets/scholar.png',
                width: 150,
                height: 150,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scholar Chat',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'Pacifico'),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Feiled is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Feiled is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minWidth: 360,
                  height: 50,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      isLoaded = true;
                      setState(() {});
                      try {
                        await loginWithEmailAndPassword();
                        showScaffoldMessenger(context, 'Login successfully');
                        Navigator.pushNamed(context, 'ChatPage',
                            arguments: email);
                      } on FirebaseAuthException catch (e) {
                        print('your error here ${e.message}');
                        if (e.code == 'user-not-found') {
                          showScaffoldMessenger(
                              context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          showScaffoldMessenger(context,
                              'Wrong password provided for that user.');
                        }
                      } catch (e) {
                        showScaffoldMessenger(context, 'your problem in $e');
                      }
                      isLoaded = false;
                      setState(() {});
                    } else {}
                  },
                  color: Colors.white,
                  child: const Text(
                    'Sign In',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'dont have account ? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'RegisterPage');
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
