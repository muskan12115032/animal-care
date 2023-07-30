// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:animal_care_app/MyRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

bool null_user = false;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  static var auth = FirebaseAuth.instance;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    String email = "", password = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Log in'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'Assets/Images/login.jpg',
              width: MediaQuery.of(context).size.width,
            ),
            Column(children: [
              Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) return "error";
                            email = value.toString();
                            return null;
                          },
                          decoration: InputDecoration(
                              label: Text("Email"),
                              hintText: "Enter Your Email"),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) return "error";
                            password = value.toString();
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              label: Text("Password"),
                              hintText: "Enter Your Password"),
                        )
                      ],
                    ),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green)),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    try {
                      await LoginScreen.auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      Navigator.pushReplacementNamed(
                          context, MyRoutes.AnimalCarePage);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User Successfully Logged in'),
                      ));
                    } on FirebaseAuthException catch (err) {
                      if (err.code == 'wrong-password')
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('wrong password'),
                        ));
                      else if (err.code == 'user-not-found')
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('user not found'),
                        ));
                      else if (err.code == 'user-disabled')
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Acoount is disabled'),
                        ));
                      else if (err.code == 'invalid-email')
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('email is Invalid'),
                        ));
                    }
                  }
                },
                child: Text("Log In"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: null_user
                    ? Text(
                        "wrong email or password",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "create Account",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ).onTap(() {
                        Navigator.pushReplacementNamed(
                            context, MyRoutes.SignUpPage);
                      }),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
