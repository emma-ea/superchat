import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superchat/core_utils/di_initializer.dart';
import 'package:superchat/core_utils/environment.dart';
import 'package:superchat/core_utils/firebase_config.dart';
import 'package:superchat/core_utils/printer.dart';
import 'package:superchat/firebase_options.dart';
import 'package:superchat/home/home.dart';
import 'package:superchat/chat/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  DIInitializer.init();

  if (Env.env == 'dev') {
    final fire = FirebaseFirestore.instance; 
    fire.useFirestoreEmulator('localhost', 4002);
    final auth = FirebaseAuth.instance;
    auth.useAuthEmulator('localhost', 4003);
    FirebaseConfig.config(fire, auth);
    logPrinter('using firebase emulators', trace: 'main');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        HomePage.route: (context) => const HomePage(),
        ChatPage.route: (context) => const ChatPage(),
      },
      initialRoute: HomePage.route,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}
