import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Home.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final auth = FirebaseAuth.instance;
  DateTime dateTime1 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายงานผู้เข้าพัก'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              });
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  DateFormat('EEE d MMM yyyy \n kk:mm').format(DateTime.now()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.blue,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final checkdate = await pickDate();
                    if (checkdate == null) return;
                    setState(() => dateTime1 = checkdate);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_alarm),
                      SizedBox(width: 10),
                      Text(
                          '${dateTime1.day}/${dateTime1.month}/${dateTime1.year}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final roomDocs = snapshot.data!.docs;

              if (roomDocs.isEmpty) {
                return const Center(
                  child: Text('No data available'),
                );
              }

              final filteredDocs = roomDocs.where((document) {
                final Timestamp timestamp = document['dateTime'];
                final DateTime dateTime = timestamp.toDate();
                final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                return formattedDate ==
                    DateFormat('dd/MM/yyyy').format(dateTime1);
              }).toList();

              if (filteredDocs.isEmpty) {
                return const Center(
                  child: Text('No data available for selected date'),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final document = filteredDocs[index];
                    final Timestamp timestamp = document['dateTime'];
                    final DateTime dateTime = timestamp.toDate();
                    final formattedDate =
                        DateFormat('dd/MM/yyyy').format(dateTime);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20.0,
                              spreadRadius: 2.0,
                              offset: Offset(0.0, 0.0),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child: FittedBox(
                                child: Text(
                                  document["roomnumber"],
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      document['fname'] + ' ' + document['lname'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text(
                                                'รายละเอียดผู้เข้าพักห้อง ${document['roomnumber']}'),
                                            content: SizedBox(
                                              width: double.infinity,
                                              height: 250,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'เบอร์ติดต่อ: ${document['phone']}\nเข้าพักเมื่อ: ${formattedDate.toString()}\nประเภทการจ่ายเงิน: ${document['typeroom']} \nจำนวนเงิน: ${document['amount']}',
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: const Text('Show Detail'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime1,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
}
