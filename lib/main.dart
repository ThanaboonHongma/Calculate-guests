import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login101/screen/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "MyLoginApplication",
    options: const FirebaseOptions(
    apiKey: "AIzaSyAl-eUOcxEKdPd1Dvb1BAXZVtgNcezLXNY",
    authDomain: "myloginapplication-b0403.firebaseapp.com",
    projectId: "myloginapplication-b0403",
    storageBucket: "myloginapplication-b0403.appspot.com",
    messagingSenderId: "851562118435",
    appId: "1:851562118435:web:c711085263920435272096",
    measurementId: "G-XLDSJVYM5Z"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen()
    );
  }
}

