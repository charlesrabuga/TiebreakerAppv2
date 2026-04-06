import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/decision_result.dart';
import 'package:flutter/foundation.dart';

class DecisionService extends ChangeNotifier{

  DecisionResult? currentResult;
  bool isLoading = false;
  String? errorMessage;

  final String _apiKey = "";

  Future<void> analyzeDecision(String decisionPrompt) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
      final prompt = '''
      
      You are an expert decision-making assistant. The user is trying to make a decision: "$decisionPrompt".
      Please provide exactly 3 sections of markdown:
      1. ### Pros and Cons
      provide a detailed pros and cons list/
      2. ### Comparison Table
      if applicable, provide a comparison table comparing the main alternative.
      3. ### SWOT Analysis
      provide a SWOT(Strengths, Weaknesses, Opportunities, Threat) analysis for the decision
      
      Ensure the markdown is well-formatted and professional. Do not include conversational filler. 
      ''';

      // final content = [Content.text(prompt)];
      // final response = await _model.generateContent([Content.text(prompt)]);
      // final text = response.text ?? '';
      // final section = _parseResponse(text, decisionPrompt);

      final response = await model.generateContent([Content.text(prompt)]);
      currentResult = _parseResponse(response.text ?? '', decisionPrompt);
    } catch (e) {
      errorMessage = 'Failed $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }
  DecisionResult _parseResponse(String text, String decision) {
    final parts = text.split('###');
    return DecisionResult(
        decision: decision,
        prosAndCons: parts.length > 1 ? parts[1] : text,
        comparisonTable: parts.length > 2 ? parts[2] : "No table",
        swotAnalysis: parts.length > 1 ? parts[1] : "No Swot",
    );
  }

}
