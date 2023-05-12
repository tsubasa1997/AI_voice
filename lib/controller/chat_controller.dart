import 'dart:convert';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
part 'chat_controller.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(<OpenAIChatCompletionChoiceMessageModel>[]) List<OpenAIChatCompletionChoiceMessageModel> messages,
    @Default(true) bool isOn,
    @Default(false) bool hasBuild,
  }) = _ChatState;
}

final chatStateProvider = StateNotifierProvider.autoDispose<ChatStateNotifier, ChatState>(
  (read) => ChatStateNotifier(ref: read),
);

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier({required this.ref}) : super(const ChatState());

  final Ref ref;

  Future<void> firstContact(String name,String id,String localFile) async {
    String firstContent = 'こんにちは、$nameです。ご用件は何でしょうか。';
    final newUserMessage = OpenAIChatCompletionChoiceMessageModel(
      content: firstContent,
      role: OpenAIChatMessageRole.assistant,
    );
    final messages = [...state.messages];
    messages.add(newUserMessage);
    state = state.copyWith(messages: messages);

    AssetsAudioPlayer.newPlayer().open(
      Audio(localFile),
      showNotification: true,
    );
  }

  Future<void> voiceApiSwitch() async {
    final isOn = state.isOn;
    state = state.copyWith(isOn: !isOn);
  }

  Future<void> highSpeedApi(String content,String id) async {
    await dotenv.load(fileName: ".env");
    String voiceApi = dotenv.env['VOICE_APIKEY']!;
    String text = content;
    String textUrl = 'https://deprecatedapis.tts.quest/v2/voicevox/audio/?text=$text&key=$voiceApi&speaker=$id';
    final url = Uri.parse(textUrl);
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Something occurred.');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/voice.wav');
    await file.writeAsBytes(response.bodyBytes);

    String wavUrl = file.path;
    final player = AudioPlayer();
    await player.setFilePath(wavUrl);
    await player.play();
  }

  Future<void> lowSpeedApi(String content,String id) async {
    String text = content;
    String textUrl = 'https://api.tts.quest/v1/voicevox/?text=$text&speaker=$id}';
    final url = Uri.parse(textUrl);

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Something occurred.');
    }
    final decodedBody = json.decode(response.body) as Map<String, dynamic>;
    final wavUrl = decodedBody['wavDownloadUrl'];

    sleep(const Duration(seconds:12));
    final player = AudioPlayer();
    final playUrl = wavUrl;
    await player.setUrl(playUrl);
    await player.play();
  }

  Future<void> sendMessage(String message,String id) async {
    final newUserMessage = OpenAIChatCompletionChoiceMessageModel(
      content: message,
      role: OpenAIChatMessageRole.user,
    );
    final messages = [...state.messages];
    messages.add(newUserMessage);
    state = state.copyWith(messages: messages);

    final chatCompletion = await OpenAI.instance.chat.create(
      model: 'gpt-3.5-turbo',
      messages: messages,
    );

    final ans = chatCompletion.choices.first.message;
    final content = ans.content;
    messages.add(ans);
    state = state.copyWith(messages: messages);

    if(id == '1'){
      final replaceContent = content.replaceAll('。','なのだ　　');
      bool isOn = state.isOn;
      if(isOn != true) {
        await lowSpeedApi(replaceContent,id);
      }else{
        await highSpeedApi(replaceContent,id);
      }
    }else{
      bool isOn = state.isOn;
      if(isOn != true) {
        await lowSpeedApi(content,id);
      }else{
        await highSpeedApi(content,id);
      }
    }
  }



}
