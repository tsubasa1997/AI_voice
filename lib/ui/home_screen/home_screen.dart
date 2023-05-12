import 'package:flutter/material.dart';
import 'package:gpt_voice/ui/home_screen/widgets/character_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text(
          'Talk',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: const [
            CharacterCard(
              name: 'ずんだもん',
              icon: 'assets/images/zun.png',
              id: '1',
              localFile: 'assets/audios/zunda1.mp3',
            ),
            CharacterCard(
              name: '春日部つむぎ',
              icon: 'assets/images/tsumugi.png',
              id: '8',
              localFile: 'assets/audios/tsumugi1.mp3',
            ),
          ],
        ),
      ),
    );
  }
}
