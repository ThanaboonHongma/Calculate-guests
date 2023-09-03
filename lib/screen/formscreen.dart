import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login101/model/profile.dart';
import 'package:flutter_login101/screen/Home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  Room myRoom = Room(
    fname: '',
    lname: '',
    phone: '',
    roomnumber: '',
    typeroom: '',
    amount: '',
    dateTime: DateTime.now(),
  );
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('rooms');

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
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('แบบฟอร์มบันทึกการเข้าพัก'),
                actions: [
                  IconButton(
                      onPressed: () {
                        auth.signOut().then((value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        });
                      },
                      icon: const Icon(Icons.logout_outlined))
                ],
              ),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ชื่อผู้เข้าพัก',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                        hintText: "เช่น นายดำรง",                         
                      ),
                        validator: RequiredValidator(
                            errorText: 'กรุณณาป้อน ชื่อ ผู้เข้าพัก'),
                        onSaved: (String? fname) {
                          myRoom.fname = fname!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'นามสกุลผู้เข้าพัก',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                        hintText: "เช่น รุ่งเรือง",                         
                      ),
                        validator: RequiredValidator(
                            errorText: 'กรุณณาป้อน นามสกุล ผู้เข้าพัก'),
                        onSaved: (String? lname) {
                          myRoom.lname = lname!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'เบอร์โทรศัพท์',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        inputFormatters: [MaskTextInputFormatter(mask: "###-###-####")],
                        decoration: const InputDecoration(
                        hintText: "เช่น 080-123-4567",                         
                      ),
                        keyboardType: TextInputType.phone,
                        validator: (phone) {
                          if (phone == null || phone.isEmpty) {
                            return 'กรุณณาป้อน เบอร์โทรศัพท์ ผู้เข้าพัก';
                          }
                          if (phone.length < 10) {
                            return 'กรุณณาป้อนเบอร์โทรศัพท์ให้ครบ 10 ตัว';
                          }
                          if (phone.length >= 11) {
                            return 'เบอร์โทรศัพท์เกิน 10 ตัว';
                          }
                          return null; // Validation passed
                        },
                        onSaved: (String? phone) {
                          myRoom.phone = phone!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'ห้องที่เข้าพัก',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                        hintText: "เช่น A1 หรือ D1",                         
                      ),
                        validator: RequiredValidator(
                            errorText: 'กรุณณาป้อน ห้องที่เข้าพัก ผู้เข้าพัก'),
                        onSaved: (String? roomnumber) {
                          myRoom.roomnumber = roomnumber!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'ประเภทการชำระเงิน',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                         decoration: const InputDecoration(
                        hintText: "เช่น โอน หรือ เงินสด",                         
                      ),
                        validator: RequiredValidator(
                            errorText: 'กรุณณาป้อน ประเภทการชำระเงิน'),
                        onSaved: (String? typeroom) {
                          myRoom.typeroom = typeroom!;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'จำนวนเงิน',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                         decoration: const InputDecoration(
                        hintText: "เช่น 600",                         
                      ),
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: 'กรุณณาป้อน จำนวนเงิน'),
                        onSaved: (String? amount) {
                          myRoom.amount = amount!;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                await _roomCollection.add({
                                  'fname':myRoom.fname,
                                  'lname':myRoom.lname,
                                  'phone':myRoom.phone,
                                  'roomnumber':myRoom.roomnumber,
                                  'typeroom':myRoom.typeroom,
                                  'amount':myRoom.amount,
                                  'dateTime':myRoom.dateTime,
                                });
                                formKey.currentState?.reset();
                                Fluttertoast.showToast(
                                    msg:
                                        'บันทึกข้อมูลผู้เข้าพักห้อง ${myRoom.roomnumber} เรียบร้อยแล้ว',
                                    gravity: ToastGravity.CENTER);
                              }
                            },
                            child: const Text('บันทึกข้อมูล')),
                      ),
                    ],
                  ),
                ),
              )),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
