/// Data model for analysis results from the TruthLens AI backend
class AnalysisResult {
  final String verdict;
  final double confidence;
  final String explanation;
  final List<String> keyFindings;
  final List<String> sources;
  final List<String> redFlags;

  AnalysisResult({
    required this.verdict,
    required this.confidence,
    required this.explanation,
    required this.keyFindings,
    required this.sources,
    required this.redFlags,
  });

  /// Create AnalysisResult from JSON response
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      verdict: json['verdict'] as String? ?? 'UNVERIFIED',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      explanation: json['explanation'] as String? ?? 'No explanation provided',
      keyFindings: _parseListField(json['key_findings']),
      sources: _parseListField(json['sources']),
      redFlags: _parseListField(json['red_flags']),
    );
  }

  /// Helper method to parse list fields with proper null handling
  static List<String> _parseListField(dynamic field) {
    if (field == null) return [];
    if (field is List) {
      return field.map((e) => e.toString()).toList();
    }
    return [];
  }
}
