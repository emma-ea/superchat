import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/chat/data/chat.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';
import 'package:superchat/core_utils/firebase_config.dart';

class ChatRemoteDatasource {

  final FirebaseFirestore _db = FirebaseConfig.firestore;
  final FirebaseAuth _auth = FirebaseConfig.firebaseAuth;

  StreamController<String> chatRoomListener = StreamController.broadcast();

  Stream<String> get getUserInRoom => chatRoomListener.stream;

  Future<DateTime> setupChatRoom(String roomId) async {
    DateTime? date = DateTime.now();
    await _db.collection(AppConstants.firestoreRandomChats)
      .doc(roomId)
      .set({'date': date})
      .whenComplete(() {
      });
    return date;
  }

  Future<void> listenToEmptyRoom() async {
    _db.collection(AppConstants.firestoreRandomChats)
      .snapshots()
      .listen((documents) {
        if (documents.size > 0) {
          final userRoom = documents.docs.any((doc) => doc.id.contains(_auth.currentUser!.uid));
          if (userRoom) {
            final room = documents.docs.firstWhere((doc) => doc.id.contains(_auth.currentUser!.uid));
            chatRoomListener.sink.add(room.id);
            chatRoomListener.close();
            setupChatRoom(room.id);
          }
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

  Future<int> sendChat(String roomId, Chat chat) async {
    int res = -1;
    final data = {
      'message': chat.message,
      'time_sent': chat.sentTime,
      'user_id': chat.userId,
    };
    await _db.collection(AppConstants.firestoreRandomChats)
      .doc(roomId)
      .update(data)
      .whenComplete(() => res = AppConstants.sentMessage)
      .onError((error, stackTrace) => throw SendingChatError(error as String));

    return res;
  }

}