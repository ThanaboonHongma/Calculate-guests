import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login101/screen/display.dart';
import 'package:flutter_login101/screen/formscreen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.blue,
            body: TabBarView(children: [
              DisplayScreen(),
              FormScreen(),
            ]),
            bottomNavigationBar: TabBar(tabs: [
              Tab(text: 'สรุปบันทึกการเข้าพัก',),
              Tab(text: 'รายงานผผู้เข้าพัก',),
            ]),
          ),
        ));
  }
}
