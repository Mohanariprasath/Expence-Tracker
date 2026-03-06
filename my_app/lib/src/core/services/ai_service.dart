import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';

// Providers
final aiServiceProvider = Provider<AIService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return AIService(storage);
});

class AIService {
  final StorageService _storage;
  GenerativeModel? _model;

  AIService(this._storage);

  String? get _apiKey => _storage.getApiKey();

  bool get hasKey => _apiKey != null && _apiKey!.isNotEmpty;

  void initModel() {
    final key = _apiKey;
    if (key != null && key.isNotEmpty) {
      _model = GenerativeModel(model: 'gemini-pro', apiKey: key);
    }
  }

  // CORE: Smart Tip
  Future<String> generateSmartTip(List<dynamic> transactions) async {
    if (!hasKey) {
      return "💡 Add your Gemini API Key in Settings to unlock AI insights.";
    }

    // Safety check
    if (_model == null) {
      initModel();
    }
    if (_model == null) return "💡 Error initializing AI. Check API Key.";

    final prompt =
        """
    You are Antigravity, a financial assistant.
    Analyze these recent transaction patterns (JSON): $transactions
    Generate ONE short, specific, and motivating financial tip (max 2 lines).
    Do not mention 'JSON' or technical terms. Address the user directly.
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      return response.text ?? "💡 Keep tracking your expenses to see patterns!";
    } catch (e) {
      return "💡 Tip: Consistent saving builds wealth.";
    }
  }

  // CORE: Chat
  Stream<String> chatStream(String message, List<dynamic> contextData) async* {
    if (!hasKey) {
      yield "Please enter your Gemini API Key in Settings to chat.";
      return;
    }

    if (_model == null) initModel();
    if (_model == null) {
      yield "System Error: Could not load AI model.";
      return;
    }

    final prompt =
        """
    Context: User Financial Data: $contextData.
    User Question: $message
    
    Answer as Antigravity: friendly, concise, financial wisdom.
    """;

    try {
      final content = [Content.text(prompt)];
      final response = _model!.generateContentStream(content);
      await for (final chunk in response) {
        if (chunk.text != null) yield chunk.text!;
      }
    } catch (e) {
      yield "I'm having trouble connecting to the financial cosmos right now. (${e.toString()})";
    }
  }
}
