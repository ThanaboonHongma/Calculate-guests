import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login101/screen/welcome.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../model/profile.dart';
import 'Home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  String message = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              centerTitle: true,
                leading: (IconButton(
                    onPressed: () {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    icon: const Icon(Icons.arrow_back))),
            ),
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('เข้าสู่ระบบ'),
                centerTitle: true,
                leading: (IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    icon: const Icon(Icons.arrow_back))),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Icon(Icons.account_circle,size: 180,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'อีเมล',
                                  style: TextStyle(fontSize: 20),
                                ),
                                TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                                    EmailValidator(
                                        errorText: 'รูปแบบอีเมลไม่ถูกต้อง')
                                  ]),
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (String? email) {
                                    profile.email = email!;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'รหัสผ่าน',
                                  style: TextStyle(fontSize: 20),
                                ),
                                TextFormField(
                                  validator: RequiredValidator(
                                      errorText: 'กรุณาป้อนรหัสผ่าน'),
                                  obscureText: true,
                                  onSaved: (String? password) {
                                    profile.password = password!;
                                  },
                                ),
                                const SizedBox(height: 40,),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState?.save();
                                          try {
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: profile.email,
                                                    password: profile.password).then((value) {
                                                      formKey.currentState?.reset();
                                                      Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WelcomeScreen()));
                                                    });
                                          } on FirebaseAuthException catch (e) {
                                            if(e.code == 'user-not-found'){
                                              message = 'ไม่พบอีเมลที่ใช้งาน';
                                            }else{
                                              message = e.code.toString();
                                            }
                                            Fluttertoast.showToast(
                                                msg: message,
                                                gravity: ToastGravity.CENTER);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'ลงชื่อเข้าสู่ระบบ',
                                        style: TextStyle(fontSize: 20),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      },
    );
  }
}
