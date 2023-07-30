import 'package:animal_care_app/Authentication/loginPage.dart';
import 'package:animal_care_app/ani_care_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/CasesModel.dart';

String animal = "",
    doctor = LoginScreen.auth.currentUser!.email.toString(),
    disease = "",
    place = "",
    date = "",
    month = "",
    year = "",
    state = "",
    disease_desc = "",
    owner_name = "",
    owner_mobile_no = "",
    breed = "";
bool has_owner = true;
final _formkey = GlobalKey<FormState>();

class AddCasePage extends StatefulWidget {
  const AddCasePage({super.key});

  @override
  State<AddCasePage> createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "this Field can't be Empty";
                        }
                        animal = value.toString();
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Specify the Animal",
                          label: Text("Animal"))),
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "this Field can't be Empty";
                        }
                        breed = value.toString();
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Specify the breed", label: Text("breed"))),
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "this Field can't be Empty";
                        }
                        disease = value.toString();
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "enter the disease Name",
                          label: Text("disease"))),
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "this Field can't be Empty";
                        }
                        place = value.toString();
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "enter the City Name",
                          label: Text("City"))),
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "this Field can't be Empty";
                        }
                        state = value.toString();
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "enter the State Name",
                          label: Text("State"))),
                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        disease_desc = value.toString();
                        return null;
                      },
                      initialValue: "No Description",
                      decoration: const InputDecoration(
                          hintText: "enter the disease description",
                          label: Text("disease description"))),
                  ElevatedButton(
                          onPressed: () {
                            has_owner = has_owner.toggle();
                            setState(() {});
                          },
                          child: Text(has_owner
                              ? "this animal is not a pet"
                              : "this animal is a pet"))
                      .py4(),
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty && has_owner)
                          return "this Field can't be Empty";
                        owner_name = value.toString();
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "enter the owner's name",
                          label: Text("Owner's name"))),
                  TextFormField(
                      validator: (value) {
                        if (value!.isEmpty && has_owner)
                          return "this Field can't be Empty";
                        owner_mobile_no = value.toString();
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "enter the owner's Mobile Number",
                          label: Text("Owner's Mobile"))),
                  ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              addCase(
                                  animal,
                                  disease,
                                  doctor,
                                  DateTime.now().day.toString(),
                                  place,
                                  false,
                                  DateTime.now().month.toString(),
                                  DateTime.now().year.toString(),
                                  state,
                                  breed);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("add"))
                      .p20()
                ],
              )).px12().py64(),
        ),
      ),
    );
  }

  addCase(
      String animal,
      String disease,
      String doctor,
      String date,
      String place,
      bool completed,
      String month,
      String year,
      String state,
      String breed) {
    var _cases = Case_model(
        id: "${AniCarePage.allcases.length + 1}",
        animal: animal,
        disease: disease,
        Doctor: doctor,
        date: ("${DateTime.now().day - 1}"),
        month: month,
        year: year,
        state: state,
        breed: breed,
        completed: completed,
        place: place,
        diseaseDesc: disease_desc,
        ownerMobileNo: owner_mobile_no,
        ownerName: owner_name);
    FirebaseFirestore.instance.collection('new_cases').add(_cases.toJson());
  }

  deletecase(var id) {
    FirebaseFirestore.instance.collection('new_cases').doc(id).delete();
  }
}
