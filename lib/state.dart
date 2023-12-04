import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_cardmap/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  Map<String, dynamic> card = {};

  ApplicationState() {
    init();
    print("init");
  }

  Future<void> init() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      await fetchCardList();
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  Future<void> fetchCardList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        card = (snapshot.data()!['cardMap'] as Map<String, dynamic>);
        // print(cardList);
        print('done');
        print(card);
        notifyListeners(); // Notify listeners that the data has been updated
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching card list: $e');
    }
  }

  Future<void> addMap(Map<String, dynamic> map) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'cardMap': map,
      'name': FirebaseAuth.instance.currentUser!.displayName,
    });
    notifyListeners();
  }
}
