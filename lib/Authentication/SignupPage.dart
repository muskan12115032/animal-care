// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:animal_care_app/Authentication/loginPage.dart';
import 'package:animal_care_app/MyRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String email = "", password = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'Assets/Images/login.jpg',
              width: MediaQuery.of(context).size.width,
            ),
            Column(children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) return "error";
                          email = value.toString();
                          return null;
                        },
                        decoration: InputDecoration(
                            label: Text("Email"), hintText: "Enter Your Email"),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Email is Invalid";
                          password = value.toString();
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            label: Text("Password"),
                            hintText: "Enter Your Password"),
                      )
                    ],
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green)),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    try {
                      final cred = await LoginScreen.auth
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                    } on FirebaseAuthException catch (err) {
                      if (err.code == 'weak-password')
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('weak password'),
                        ));
                      else if (err.code == 'invalid-email')
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Invalid Email'),
                        ));
                      else if (err.code == 'email-already-in-use')
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Email is Already Registered'),
                        ));
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User Successfully Registered'),
                        ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("InValid Email")));
                  }
                },
                child: Text("Create Account"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Log in",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ).onTap(() {
                  Navigator.pushReplacementNamed(context, MyRoutes.LoginPage);
                }),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
