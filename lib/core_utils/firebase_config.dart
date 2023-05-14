import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConfig {

  FirebaseConfig._();

  static late FirebaseFirestore _firestore;
  static late FirebaseAuth _firebaseAuth;

  static FirebaseFirestore get firestore => _firestore;
  static FirebaseAuth get firebaseAuth => _firebaseAuth;

  static void config(FirebaseFirestore? firestoreInstance, FirebaseAuth? authInstance) {
    _firebaseAuth = authInstance ?? FirebaseAuth.instance;
    _firestore = firestoreInstance ?? FirebaseFirestore.instance;
  }

}