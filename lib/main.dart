import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_cardmap/app.dart';
import 'package:project_cardmap/firebase_options.dart';
import 'package:project_cardmap/state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const CardMapp()),
  ));
}
