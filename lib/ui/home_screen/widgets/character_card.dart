import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_voice/controller/chat_controller.dart';
import 'package:gpt_voice/ui/chat_screen/chat_screen.dart';

class CharacterCard extends ConsumerWidget {
  const CharacterCard({
    super.key,
    required this.name,
    required this.icon,
    required this.id,
    required this.localFile,
  });

  final String id;
  final String name;
  final String icon;
  final String localFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 90,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  id: id,
                  name: name,
                  icon: icon,
                  localFile: localFile,
                  onBuild: Future((){
                    ref.read(chatStateProvider.notifier).firstContact(name, id, localFile);
                  }),
                );
              },
            ),
          );
        },
        child: Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white38,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    icon,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

