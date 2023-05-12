import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatCard extends ConsumerWidget {
  const ChatCard({
    super.key,
    required this.message,
    required this.icon,
  });

  final OpenAIChatCompletionChoiceMessageModel message;
  final String icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(message.role == OpenAIChatMessageRole.user){
      return Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(message.content),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      );
    }else{
      return Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(icon,fit: BoxFit.contain,),
                  ),
                ),
                Container(
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                      bottomRight: Radius.circular(40),
                    ),
                    color: Colors.blue[200],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(message.content),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      );
    }
  }
}
