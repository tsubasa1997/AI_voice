import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_voice/controller/chat_controller.dart';



class InputChatText extends ConsumerStatefulWidget {
  const InputChatText({
    super.key,
    required this.textEditingController,
    required this.id,
  });

  final TextEditingController textEditingController;
  final String id;

  @override
  ConsumerState<InputChatText> createState() => _InputChatTextState();
}

class _InputChatTextState extends ConsumerState<InputChatText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: widget.textEditingController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'ずんだもんに質問してください',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(chatStateProvider.notifier).sendMessage(widget.textEditingController.text,widget.id);
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
