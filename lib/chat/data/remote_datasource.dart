import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';

class ChatRemoteDatasource {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> setupChatRoom(String term) async {
    final randomUser = await getRandomUserFromCategory(term);
    final docName = '${_auth.currentUser!.uid}-$randomUser';

    print('---------------');
    print(docName);
    print('---------------');

    _db.collection(AppConstants.firestoreRandomChats)
      .doc(docName)
      .set({'time': DateTime.now()})
      .onError((error, stackTrace) => ChatRoomCreationException(error as String));

  }

  Future<String> getRandomUserFromCategory(String term) async {
    final categories = await _db.collection(AppConstants.firestoreCategoryCollections)
      .doc(term.toLowerCase())
      .get()
      .onError((error, stackTrace) => 
        throw CategoryFetchException(error as String)
      );
    if (!categories.exists) { return ''; }

    final users = (categories.data()?[AppConstants.firestoreCategoryWaitingRoom] as List)
      .map((e) => e as String).toList();

    
    users.removeWhere((id) => id == _auth.currentUser!.uid);

    if (users.isNotEmpty) {
      int index = Random().nextInt(users.length);
      return users[index];
    }

    return '';
  }

}