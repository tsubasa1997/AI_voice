import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'package:dart_openai/openai.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  OpenAI.apiKey = dotenv.env['AI_APIKEY']!;
  runApp(
    const ProviderScope(child: App()),
  );
}
