import 'package:cloud_firestore/cloud_firestore.dart';

Future addRide(String name, int persons, String ride, int total) async {
  final docUser = FirebaseFirestore.instance.collection('Rides').doc();

  final json = {
    'name': name,
    'persons': persons,
    'ride': ride,
    'total': total,
    'dateTime': DateTime.now(),
    'status': 'Pending',
    'uid': docUser.id,
    'day': DateTime.now().day,
    'month': DateTime.now().month,
    'year': DateTime.now().year,
  };

  await docUser.set(json);
}
