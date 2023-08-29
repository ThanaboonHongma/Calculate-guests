import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login101/model/profile.dart';
import 'package:flutter_login101/screen/Home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            ),
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: (IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    icon: const Icon(Icons.arrow_back))),
                title: const Text('สร้างบัญชีผู้ใช้'),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Icon(Icons.person_add_alt,size: 180,),
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
                                              .createUserWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password)
                                              .then((value) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'สร้างบัญชีผู้ใช้งานเรียบร้อยแล้ว',
                                                gravity: ToastGravity.CENTER);
                                            formKey.currentState?.reset();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen()));
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'email-already-in-use') {
                                            message =
                                                'มีอีเมลนี้ในระบบแล้ว โปรดใช้อีเมลอื่น';
                                          } else if (e.code == 'weak-password') {
                                            message =
                                                'รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป';
                                          } else {
                                            message = e.message.toString();
                                          }
                                          Fluttertoast.showToast(
                                              msg: message,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'ลงทะเบียน',
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
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
