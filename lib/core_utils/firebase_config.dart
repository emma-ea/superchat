import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConfig {

  FirebaseConfig._();

  static late FirebaseFirestore _firestore;
  static late FirebaseAuth _firebaseAuth;
  static late FirebaseFunctions _functions;

  static FirebaseFirestore get firestore => _firestore;
  static FirebaseAuth get firebaseAuth => _firebaseAuth;
  static FirebaseFunctions get functions => _functions;

  static void config({
    FirebaseFirestore? firestoreInstance, 
    FirebaseAuth? authInstance,
    FirebaseFunctions? functionsInstance,
  }) {
    _firebaseAuth = authInstance ?? FirebaseAuth.instance;
    _firestore = firestoreInstance ?? FirebaseFirestore.instance;
    _functions = functionsInstance ?? FirebaseFunctions.instance;
  }

}