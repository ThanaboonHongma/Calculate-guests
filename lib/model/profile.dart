// ignore_for_file: public_member_api_docs, sort_constructors_first
class Profile {
  String email = '';
  String password = '';

  Profile({required this.email, required this.password});
}

class Room {
  String fname = '';
  String lname = '';
  String phone = '';
  String roomnumber = '';
  String typeroom = '';
  String amount = '';
  DateTime dateTime;
  Room({
    required this.fname,
    required this.lname,
    required this.phone,
    required this.roomnumber,
    required this.typeroom,
    required this.amount,
    required this.dateTime,
  });

}
