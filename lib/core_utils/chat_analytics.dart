import 'package:firebase_analytics/firebase_analytics.dart';

class ChatAnalytics {

  ChatAnalytics._();

  static final ChatAnalytics _instance = ChatAnalytics._();

  static ChatAnalytics get instance => _instance;

  final _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get observer => _analytics;

  void event({Map<String, String> props = const {}}) {
    _analytics.logEvent(name: props['name'] as String, parameters: props);
  }

}
