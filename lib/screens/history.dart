// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:freemorsel/widgets/cards/foodcard.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool loader = true;
  List historyData = [];

  Future callApi() async {
    FirebaseFirestore.instance
        .collection("PendingDonation")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              for (var doc in querySnapshot.docs) {historyData.add(doc.data())}
            })
        .whenComplete(() => setState(() => loader = false));
  }

  @override
  void initState() {
    callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Your History",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: loader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(
                    historyData[index]["Time"].millisecondsSinceEpoch);
                return FoodCard(
                    title: historyData[index]["foodName"],
                    status: historyData[index]["Status"],
                    image: historyData[index]["images"][0],
                    date: "${tsdate.year}/${tsdate.month}/${tsdate.day}");
              }),
    );
  }
}
