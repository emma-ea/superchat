import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {

  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? hintText;

  const ChatInput({super.key, this.onTap, this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0,),
          child: IconButton(
            iconSize: 30.0,
            onPressed: onTap,
            icon: const Icon(Icons.send_outlined),
          ),
        ),
      ],
    );
  }
}