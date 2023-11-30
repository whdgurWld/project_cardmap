import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_cardmap/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  List<String> cardList = [];

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    DocumentSnapshot<Map<String, dynamic>> tmp = await FirebaseFirestore
        .instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    cardList = (tmp.data()!['cardList'] as List<dynamic>).cast<String>();
    print(cardList);
  }

  List<String> getCard() {
    return cardList;
  }
}
