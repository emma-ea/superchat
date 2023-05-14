import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';

class ChatRemoteDatasource {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamController<String> chatRoomListener = StreamController.broadcast();

  Stream<String> get getUserInRoom => chatRoomListener.stream;

  Future<int> setupChatRoom(String term) async {
    final randomUser = await getRandomUserFromCategory(term);
    final docName = '${_auth.currentUser!.uid}-$randomUser';

    print('---------------');
    print(docName);
    print('---------------');

    if (randomUser.isEmpty) {
      return 112;
    }

    _db.collection(AppConstants.firestoreRandomChats)
      .doc(docName)
      .set({'time': DateTime.now()})
      .onError((error, stackTrace) => ChatRoomCreationException(error as String));

    return 100;

  }

  void listenToEmptyRoom() {
    _db.collection(AppConstants.firestoreRandomChats)
      .snapshots()
      .listen((event) {
        if (event.size > 0) {
          final doc = event.docs.firstWhere((element) => element.id.contains(_auth.currentUser!.uid));
          chatRoomListener.sink.add(doc.id);
          chatRoomListener.done;
          print('---------$runtimeType--------');
          print('ending stream. user found waiting');
          print('-----------------');
        }
      });
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