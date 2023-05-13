import 'package:flutter/material.dart';
import 'package:superchat/home/home.dart';
import 'package:superchat/chat/chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        HomePage.route: (context) => const HomePage(),
        ChatPage.route: (context) => const ChatPage(),
      },
      initialRoute: HomePage.route,
    );
  }
}
