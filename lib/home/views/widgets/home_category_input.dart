import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/home/home.dart';

class CategoryChatInput extends StatelessWidget {
  const CategoryChatInput({super.key, this.onTap,required this.controller, this.hint});

  final TextEditingController controller;
  final VoidCallback? onTap;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .7 , 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: const OutlineInputBorder(),
                ),
                onEditingComplete: onTap,
              ),
              const SizedBox(height: 3,),
              const Text('Enter a chat topic to find interested users', style: TextStyle(fontSize: 9),),
            ],
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