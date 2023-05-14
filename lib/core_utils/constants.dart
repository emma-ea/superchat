class AppConstants {
  AppConstants._();

  static const String firestoreCategoryCollections = "topics";
  static const String firestoreUserCollections = "users";
  static const String firestoreCategoryWaitingRoom = "waiting_users";
  static const String firestoreRandomChats = "chats";
  static const String emptyRoomInviteFriends = 'No one seems to be here. Invite your friends';
  static const String topicHints = 'School, Coding, Anime, etc...';
  static const String unknown = 'Something went wrong. Try again';

  // RETURN CODES
  static const int addUserToTopic = 111;
  static const int sentMessage = 110;
}