import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Login Screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB8B8dWNYI1In6P9SzXv-Z7CdO_fDLEI1c",
          appId: "1:670010040577:android:8ef0f76b8d7b30c475bb00",
          messagingSenderId: "670010040577",
          projectId: "flutter-demo-df8cd",
          storageBucket: "gs://flutter-demo-df8cd.appspot.com"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
        home: LoginScreen());
  }
}
