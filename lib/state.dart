import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_cardmap/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
}
