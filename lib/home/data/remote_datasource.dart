import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';
import 'package:superchat/core_utils/firebase_config.dart';
import 'package:superchat/core_utils/printer.dart';

import 'package:superchat/home/data/local_datasource.dart';
import 'package:uuid/uuid.dart';

class RemoteDataSource {

  late FirebaseFirestore _db;
  late FirebaseAuth _auth;

  StreamController<int> activeUsersController = StreamController.broadcast();

  Stream<int> get activeUsers => activeUsersController.stream;

  final LocalDatasource _cache;

  RemoteDataSource(this._cache) {
    _db = FirebaseConfig.firestore;
    _auth = FirebaseConfig.firebaseAuth;
    getActiveUsers();
  }
  
  Future<String> createUser() async {
    final user = await _auth
      .signInAnonymously()
      .onError((FirebaseAuthException error, stackTrace) => 
        throw UserCreationException(error.message!));

    final uid = user.user?.uid;

    if (uid == null) {
      throw const UserCreationException('Couldn\'t access user id');
    }

    await updateActiveUserInfo(uid, isActive: true, setFirstLogin: true);

    final cachedUid = await _cache.getUser() ?? '';

    if (cachedUid.isNotEmpty && cachedUid != uid) {
      deleteUser(cachedUid);
    }

    await _cache.saveUser(uid);
    return uid;
  }

  Future<String> getUser({bool? signOff}) async {
    String uid = '';

    final cachedUid = await _cache.getUser() ?? '';

    if (_auth.currentUser != null) {
      uid = _auth.currentUser!.uid;
      await updateActiveUserInfo(uid, isActive: signOff ?? true);
      await _cache.saveUser(uid);
    }

    if (cachedUid.isNotEmpty && cachedUid != uid) {
      deleteUser(cachedUid);
    }

    return uid;
  }

  Future<void> updateActiveUserInfo(String userId, {bool isActive = false, bool inChat = false, bool setFirstLogin = false}) async {

    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    final data = {
      'active': isActive,
      'uid': userId,
      'last_visited': DateTime.now(),
      'in_chat': inChat,
      'device': deviceInfo.data.toString(),
    };

    if (setFirstLogin) {
      data.putIfAbsent('first_login', () => DateTime.now());
      _db.collection(AppConstants.firestoreUserCollections)
        .doc(userId)
        .set(data)
        .onError((FirebaseException error, stackTrace) => UserInfoUpdateException(error.message!));
    } else {
      _db.collection(AppConstants.firestoreUserCollections)
        .doc(userId)
        .update(data)
        .onError((FirebaseException error, stackTrace) => UserInfoUpdateException(error.message!));
    }
  }

  Future<void> getActiveUsers() async {
    _db.collection(AppConstants.firestoreUserCollections)
      .snapshots()
      .listen((documents) {
        if (documents.docs.isNotEmpty && _auth.currentUser != null) {
          activeUsersController.sink.add(filterActiveUsers(documents));
        }
      });
  }

  int filterActiveUsers(QuerySnapshot<Map<String, dynamic>> documents) {
    final filteredDocs = documents.docs;
    filteredDocs.removeWhere((doc) => doc.id == _auth.currentUser!.uid);
    filteredDocs.retainWhere((doc) => (doc.data()['active'] as bool));
    return filteredDocs.length;
  }

  Future<List<String>> getUsersInCategory(String term) async {
    final categories = await _db.collection(AppConstants.firestoreCategoryCollections)
      .doc(term.toLowerCase())
      .get()
      .onError((error, stackTrace) => 
        throw CategoryCreationException(error as String)
      );

    if (!categories.exists) { return []; }

    logPrinter(categories.data()![AppConstants.firestoreCategoryWaitingRoom], trace: 'getUserInCategory()');
    if (categories.data()![AppConstants.firestoreCategoryWaitingRoom] == Null) return [];

    return (categories.data()?[AppConstants.firestoreCategoryWaitingRoom] as List).map((e) => e as String).toList();
  }

  Future<void> removeUserFromWaitingRoom() {
    throw UnimplementedError('TODO');
  }

  Future<void> deleteUser(String uid) async {
    final functions = FirebaseConfig.functions;
    functions.httpsCallable('deleteUserRecord')
      .call(
        {
          'data': {
            'uid': uid,
            'collection': AppConstants.firestoreUserCollections,
          }
        }
      ).onError((error, stackTrace) { 
        throw ChatCloudFunctionsError(error.toString()); 
      });
  }

  Future<int> processCategory(String term) async {

    int results = -1;

    List<String> categories = await getUsersInCategory(term);
    categories.add(await getUser());

    categories = categories.toSet().toList();

    final data = {
      'waiting_users': categories,
      'recent_search': DateTime.now(),
    };

    await _db.collection(AppConstants.firestoreCategoryCollections)
      .doc(term.toLowerCase())
      .set(data)
      .whenComplete(() => results = AppConstants.addUserToTopic)
      .onError((FirebaseFunctionsException error, stackTrace) => 
        throw CategoryCreationException(error.message!)
      );

    return results;
  }
  
}
