import 'package:animal_care_app/Cases_pages/add_case_page.dart';
import 'package:animal_care_app/Cases_pages/current_cases.dart';
import 'package:animal_care_app/Cases_pages/past_cases.dart';
import 'package:animal_care_app/MyRoutes.dart';
import 'package:animal_care_app/ani_care_page.dart';
import 'package:animal_care_app/case_detail_page.dart';
import 'package:animal_care_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Authentication/SignupPage.dart';
import 'Authentication/loginPage.dart';

String? userEmail;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      initialRoute: MyRoutes.LoginPage,
      debugShowCheckedModeBanner: false,
      routes: {
        MyRoutes.LoginPage: (context) => const LoginScreen(),
        MyRoutes.SignUpPage: (context) => const SignInScreen(),
        MyRoutes.AnimalCarePage: (context) => const AniCarePage(),
        MyRoutes.PastCasesPage: (context) => const PastCasesPage(),
        MyRoutes.CurrentCasesPage: (context) => const CurrentCasesPage(),
        MyRoutes.AddCasePage: (context) => const AddCasePage(),
        MyRoutes.CaseDetailPage: (context) => const CaseDetailPage(),
      },
    );
  }
}
