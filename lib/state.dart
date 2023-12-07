import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_cardmap/firebase_options.dart';
import 'package:project_cardmap/home.dart';

class ApplicationState extends ChangeNotifier {
  Map<String, dynamic> card = {};
  List<String> selected = [];
  List<String> favoriteList = [];
  List<Coords> findCoords = [];

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
        selected = List.castFrom(snapshot.data()!['selected'] as List);
        favoriteList = List.castFrom(snapshot.data()!['favorite'] as List);
        notifyListeners();
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
      'selected': selected,
      'favorite': favoriteList,
      'name': FirebaseAuth.instance.currentUser!.displayName,
    });
    notifyListeners();
  }

  Future<void> addCard(List<String> list) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'cardMap': card,
      'selected': list,
      'favorite': favoriteList,
      'name': FirebaseAuth.instance.currentUser!.displayName,
    });
    notifyListeners();
  }

  Future<void> addFavorite(List<String> list) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'cardMap': card,
      'selected': selected,
      'favorite': list,
      'name': FirebaseAuth.instance.currentUser!.displayName,
    });
    print(list);
    notifyListeners();
  }
}
