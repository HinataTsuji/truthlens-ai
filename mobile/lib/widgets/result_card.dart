import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/analysis_result.dart';

/// Widget to display analysis results in a beautiful card layout
class ResultCard extends StatelessWidget {
  final AnalysisResult result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Verdict Card
        _buildVerdictCard(context),
        const SizedBox(height: 16),
        
        // Confidence Score
        _buildConfidenceCard(context),
        const SizedBox(height: 16),
        
        // Explanation
        _buildExplanationCard(context),
        const SizedBox(height: 16),
        
        // Key Findings (if available)
        if (result.keyFindings.isNotEmpty) ...[
          _buildKeyFindingsCard(context),
          const SizedBox(height: 16),
        ],
        
        // Sources (if available)
        if (result.sources.isNotEmpty) ...[
          _buildSourcesCard(context),
          const SizedBox(height: 16),
        ],
        
        // Red Flags (if available)
        if (result.redFlags.isNotEmpty) ...[
          _buildRedFlagsCard(context),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  /// Build the verdict card with color coding
  Widget _buildVerdictCard(BuildContext context) {
    final verdictData = _getVerdictData(result.verdict);
    
    return Card(
      color: verdictData['color'],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              verdictData['icon'],
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              'VERDICT',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              result.verdict,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build confidence score card with animated progress bar
  Widget _buildConfidenceCard(BuildContext context) {
    final percentage = (result.confidence * 100).round();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Confidence Score',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667eea),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: result.confidence,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF667eea),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build explanation card
  Widget _buildExplanationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.description, color: Color(0xFF667eea)),
                SizedBox(width: 8),
                Text(
                  'Explanation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              result.explanation,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build key findings card
  Widget _buildKeyFindingsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFF667eea)),
                SizedBox(width: 8),
                Text(
                  'Key Findings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...result.keyFindings.map((finding) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      finding,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  /// Build sources card with clickable links
  Widget _buildSourcesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.link, color: Color(0xFF667eea)),
                SizedBox(width: 8),
                Text(
                  'Sources',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...result.sources.map((source) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _launchUrl(source),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: Color(0xFF667eea),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        source,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667eea),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  /// Build red flags card with warning styling
  Widget _buildRedFlagsCard(BuildContext context) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Red Flags',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...result.redFlags.map((flag) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      flag,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  /// Get verdict-specific styling data
  Map<String, dynamic> _getVerdictData(String verdict) {
    switch (verdict.toUpperCase()) {
      case 'TRUE':
        return {
          'color': Colors.green[600],
          'icon': Icons.check_circle,
        };
      case 'FALSE':
        return {
          'color': Colors.red[600],
          'icon': Icons.cancel,
        };
      case 'MISLEADING':
        return {
          'color': Colors.orange[600],
          'icon': Icons.warning,
        };
      case 'UNVERIFIED':
      default:
        return {
          'color': Colors.grey[600],
          'icon': Icons.help,
        };
    }
  }

  /// Launch URL in browser
  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error silently or show a message
    }
  }
}
