import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserStats with ChangeNotifier {
  String firstname = '';
  String lastname = '';
  String email = '';
  String gender = '';

  Future<void> uploadUserStats(String genderVal, String emailVal,
      String firstNameVal, String lastNameVal) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    firstname = firstNameVal;
    lastname = lastNameVal;
    gender = genderVal;
    email = emailVal;

    await FirebaseFirestore.instance.collection('Users').doc(userId).set({
      'gender': gender,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    });
  }

  Future<bool> fetchUserStats() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final data =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (data.exists) {
      firstname = data['firstname'];
      lastname = data['lastname'];
      email = data['email'];
      gender = data['gender'];
      return true;
    } else {
      return false;
    }
  }

  Future<void> removeUserStata(id) async {
    reset();

    await FirebaseFirestore.instance.collection('Users').doc(id).delete();
  }

  void reset() {
    firstname = '';
    lastname = '';
    email = '';
    gender = '';
  }
}
