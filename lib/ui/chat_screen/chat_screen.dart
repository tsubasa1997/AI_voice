
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_voice/controller/chat_controller.dart';
import 'package:gpt_voice/ui/chat_screen/widgets/chat_card.dart';
import 'package:gpt_voice/ui/chat_screen/widgets/input_chat_text.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.id,
    required this.name,
    required this.icon,
    required this.localFile,
    required this.onBuild,
  });

  final String id;
  final String name;
  final String icon;
  final String localFile;
  final Future<void> onBuild;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  bool hasBuilt = false;
  @override
  Widget build(BuildContext context) {

      if (!hasBuilt) {
        hasBuilt = true;
        widget.onBuild;
      }
    final chatState = ref.watch(chatStateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 70),
          child: Text(
            widget.name,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                chatState.isOn ? '高速API' : '低速API',
                style: const TextStyle(color: Colors.black),
              ),
              Switch(
                value: chatState.isOn,
                onChanged: (value) {
                  ref.read(chatStateProvider.notifier).voiceApiSwitch();
                },
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: chatState.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatState.messages[index];
                    return ChatCard(
                      message: message,
                      icon: widget.icon,
                    );
                  },
                ),
              ),
            ),
            InputChatText(
              textEditingController: messageController,
              id: widget.id,
            ),
          ],
        ),
      ),
    );
  }
}
