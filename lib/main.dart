import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

  if (Env.isDev) {
    final fire = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final functions = FirebaseFunctions.instance;
    fire.useFirestoreEmulator('localhost', 4002);
    auth.useAuthEmulator('localhost', 4003);
    functions.useFunctionsEmulator('localhost', 4004);
    FirebaseConfig.config(firestoreInstance: fire, authInstance: auth, functionsInstance: functions);
    logPrinter('using firebase emulators', trace: 'main');
  } else {
    FirebaseConfig.config();
    logPrinter('using firebase on prod', trace: 'main');
  }

  DIInitializer.init();

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
