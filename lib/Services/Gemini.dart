import 'package:google_generative_ai/google_generative_ai.dart';

class Gemini {
  List<Content> history = [];
  static late GenerativeModel? model;
  static late ChatSession? chat;
  static String apiKey = 'AIzaSyA1Hz7ONAIULLvU2mAsBPfEjn-K6COmmjw';
  String text = "";

  static void init() {
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    chat = model?.startChat();
  }

  static Future<String?> sendMessage(String msg) async {
    List<String> message = [];

    var response = chat?.sendMessageStream(Content.text(msg));
    if (response == null) {
      return null;
    }

    await for (var item in response) {
      message.add(item.text ?? "");
    }

    return message.join();
  }
}
