import 'package:animal_care_app/Authentication/loginPage.dart';
import 'package:animal_care_app/models/CasesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'MyRoutes.dart';
import 'case_detail_page.dart';

int curr_index = 0;

class AniCarePage extends StatefulWidget {
  const AniCarePage({super.key});
  static List<Case_model> allcases = [];

  @override
  State<AniCarePage> createState() => _AniCarePageState();
}

List<Case_model> calendarcases = [];
DateTime date = DateTime.now();

class _AniCarePageState extends State<AniCarePage> {
  List<String> collectionpath = ['new_cases'];

  @override
  void initState() {
    fetchdata();
    FirebaseFirestore.instance
        .collection('new_cases')
        .snapshots()
        .listen((record) {
      mapRecords(record);
    });
    super.initState();
  }

  fetchdata() async {
    var records =
        await FirebaseFirestore.instance.collection('new_cases').get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _recv = records.docs
        .map(
          (element) => Case_model(
            id: element.id,
            animal: element["animal"],
            disease: element["disease"],
            Doctor: element["Doctor"],
            date: element["date"],
            place: element["place"],
            completed: element["completed"],
            breed: element["breed"],
            month: element["month"],
            state: element["state"],
            year: element["year"],
            diseaseDesc: element["disease_desc"],
            ownerMobileNo: element["owner_mobile_no"],
            ownerName: element["owner_name"],
          ),
        )
        .toList();
    setState(() {
      AniCarePage.allcases = _recv;
    });
  }

  @override
  Widget build(BuildContext context) {
    calendarcases = [];
    calendarcases.addAll(AniCarePage.allcases);
    calendarcases.retainWhere((element) =>
        (element.date == date.day.toString()) &&
        (element.year == date.year.toString()) &&
        (element.month == date.month.toString()) &&
        element.Doctor.toString() ==
            LoginScreen.auth.currentUser!.email.toString());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text("Are you Sure"),
                      content: const Text("you will be logged out"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              LoginScreen.auth.signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  MyRoutes.LoginPage, (route) => false);
                              setState(() {});
                            },
                            child: const Text("Yes")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No"))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.logout)),
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "AniCare",
          style:
              TextStyle(color: Color.fromARGB(187, 74, 188, 150), fontSize: 40),
        ),
        actions: [
          Image.asset(
            "Assets/Images/appbar.png",
          ).px32(),
        ],
      ),
      body: curr_index == 1
          ? SingleChildScrollView(
              child: Column(
                children: [
                  IconButton(
                      onPressed: () async {
                        var data = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.utc(2000),
                            lastDate: DateTime.now());
                        if (data != null) date = data as DateTime;
                        setState(() {});
                      },
                      icon: const Icon(Icons.calendar_today)),
                  calendarcases.isNotEmpty
                      ? ListView.builder(
                          itemCount: calendarcases.length,
                          itemBuilder: (context, index) {
                            return Card(
                                    elevation: 15.0,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            calendarcases[index]
                                                .animal
                                                .text
                                                .color(Colors.black)
                                                .make(),
                                            calendarcases[index]
                                                .Doctor
                                                .text
                                                .color(Colors.black)
                                                .make(),
                                            calendarcases[index]
                                                .disease
                                                .text
                                                .color(Colors.black)
                                                .make(),
                                          ],
                                        ).p16(),
                                        Text("${date.day}/${date.month}/${date.year}")
                                            .p16()
                                      ],
                                    )
                                        .box
                                        .color(const Color.fromARGB(
                                            213, 239, 249, 238))
                                        .roundedSM
                                        .make())
                                .onTap(() {
                              CaseDetailPage.selectedcase =
                                  calendarcases[index];
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.CaseDetailPage);
                            });
                          }).expand()
                      : const Center(child: Text("No Cases on selected Date"))
                ],
              ).h(MediaQuery.of(context).size.height * 0.82),
            )
          : curr_index == 0
              ? SingleChildScrollView(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                          elevation: 15.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              "Past Case".text.scale(2).bold.make(),
                              Image.asset(
                                "Assets/Images/done.png",
                              ).p12()
                            ],
                          )
                              .p8()
                              .wThreeForth(context)
                              .box
                              .color(Color.fromARGB(213, 239, 249, 238))
                              .roundedLg
                              .make()
                              .onTap(() {
                            Navigator.pushNamed(context, "/past_cases");
                          })).p12(),
                      Card(
                        elevation: 15.0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            "Current Case".text.scale(2).bold.make(),
                            Image.asset(
                              "Assets/Images/suitcase.png",
                            ).p12()
                          ],
                        )
                            .p8()
                            .wThreeForth(context)
                            .box
                            .color(Color.fromARGB(213, 239, 249, 238))
                            .roundedLg
                            .make()
                            .onTap(() {
                          Navigator.pushNamed(context, "/current_cases");
                        }),
                      ).p12(),
                      Card(
                        elevation: 15.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            "Add a new Case".text.scale(2).bold.make(),
                            Image.asset(
                              "Assets/Images/add cases.png",
                            ).p12()
                          ],
                        )
                            .p8()
                            .wThreeForth(context)
                            .box
                            .color(const Color.fromARGB(213, 239, 249, 238))
                            .roundedLg
                            .make()
                            .onTap(() {
                          Navigator.pushNamed(context, "/add_case");
                        }),
                      ).p12(),
                    ],
                  )).h(MediaQuery.of(context).size.height * 0.81),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: AniCarePage.allcases.length,
                  itemBuilder: (context, index) {
                    return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            clipBehavior: Clip.antiAlias,
                            elevation: 10.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AniCarePage.allcases[index].animal.text
                                        .color(Colors.black)
                                        .make(),
                                    AniCarePage.allcases[index].Doctor.text
                                        .color(Colors.black)
                                        .make(),
                                    AniCarePage.allcases[index].disease.text
                                        .color(Colors.black)
                                        .make(),
                                  ],
                                ).p16(),
                                AniCarePage.allcases[index].completed
                                    ? "Completed".text.make().p12()
                                    : "Not Completed".text.make().p12(),
                              ],
                            )
                                .box
                                .color(Color.fromARGB(213, 239, 249, 238))
                                .roundedSM
                                .make())
                        .onTap(() {
                          CaseDetailPage.selectedcase =
                              AniCarePage.allcases[index];
                          Navigator.pushNamed(context, MyRoutes.CaseDetailPage);
                        })
                        .px8()
                        .py4();
                  }).h(MediaQuery.of(context).size.height),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.green,
          selectedItemColor: Colors.lightBlue,
          currentIndex: curr_index,
          iconSize: 30,
          onTap: (value) {
            curr_index = value;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), tooltip: "Home Page", label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                tooltip: "Calendar View",
                label: "Calendar"),
            BottomNavigationBarItem(
                icon: Icon(Icons.cases_rounded),
                tooltip: "All Cases Page",
                label: "All Cases")
          ]),
    );
  }
}
