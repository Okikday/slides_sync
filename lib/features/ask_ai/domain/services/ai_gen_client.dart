import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';

class AiGenClient {
  static final AiGenClient instance = AiGenClient._();
  AiGenClient._();

  static GenerativeModel _model({String? model, Content? systemInstruction, bool useGoogleSearch = false}) =>
      FirebaseAI.googleAI().generativeModel(
        model: model ?? 'gemini-2.5-flash',
        tools: useGoogleSearch ? [Tool.googleSearch()] : null,
        systemInstruction: systemInstruction ?? Content.system(_defaultSystemInstruction),
      );

  static final String _defaultSystemInstruction =
      "You are a study guide for a user who is actively studying and will ask questions. Reply professionally, pedagogically, and interactively. Keep answers short, precise, and straight to the point. Expand only when an essential detail would otherwise be missing — when expanding, follow this compact structure:"
      "1. One-sentence summary (what the answer is)."
      "2. 2–4 concise bullet points or numbered steps (core explanation). "
      "3. A single brief example or analogy if it clarifies. "
      "4. One quick formative check (a 1-line question or a 1–2 step practice prompt)."
      "If the user’s question is ambiguous, ask one short clarifying question before giving a full answer. Avoid filler, repetition, long-winded background, and unnecessary jargon. Be friendly but professional. Always prioritize clarity and usefulness for studying.";

  /// Streams chat responses for anonymous conversations
  Stream<StringBuffer> streamChatAnon(List<Content> messages) {
    final model = _model();
    final buffer = StringBuffer();

    return model.generateContentStream(messages).map((response) {
      final text = response.text ?? '';
      buffer.write(text);
      return buffer;
    });
  }

  /// Gets a single chat response for anonymous conversations
  Future<String> chatAnon(List<Content> messages) async {
    final model = _model();
    final response = await model.generateContent(messages);
    return response.text ?? '';
  }
}
