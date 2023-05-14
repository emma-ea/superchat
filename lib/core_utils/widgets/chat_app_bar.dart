import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBar({super.key, this.title});

  String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title ?? ''),);
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(56);
}