import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

/// Service class to communicate with the TruthLens AI backend
class ApiService {
  // ============================================================================
  // API ENDPOINT CONFIGURATION
  // ============================================================================
  // 
  // Configure this URL based on your environment:
  //
  // LOCAL DEVELOPMENT:
  // - Android Emulator: Use 'http://10.0.2.2:3000'
  //   (10.0.2.2 is Android emulator's alias for localhost on host machine)
  // 
  // - iOS Simulator: Use 'http://localhost:3000'
  //   (iOS simulator shares network with host machine)
  // 
  // - Physical Device: Use 'http://YOUR_COMPUTER_IP:3000'
  //   Example: 'http://192.168.1.100:3000'
  //   To find your IP:
  //   - macOS/Linux: Run 'ifconfig | grep "inet "'
  //   - Windows: Run 'ipconfig'
  //   Make sure device is on same WiFi network as your computer
  //
  // PRODUCTION:
  // - Use your deployed backend URL
  //   Example: 'https://your-backend.railway.app'
  //           'https://your-backend.render.com'
  //
  // ============================================================================
  
  static const String baseUrl = 'http://10.0.2.2:3000';
  
  /// Check if the backend service is healthy and reachable
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Analyze news text and/or image for fake news detection
  /// 
  /// Parameters:
  /// - [text]: Optional news text to analyze
  /// - [imageFile]: Optional image file to analyze
  /// 
  /// Returns: AnalysisResult with verdict, confidence, and explanation
  /// Throws: Exception if the request fails
  Future<AnalysisResult> analyzeNews({
    String? text,
    File? imageFile,
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/verify'),
      );

      // Add text field if provided
      if (text != null && text.isNotEmpty) {
        request.fields['text'] = text;
      }

      // Add image file if provided
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
          ),
        );
      }

      // Validate that at least one input is provided
      if ((text == null || text.isEmpty) && imageFile == null) {
        throw Exception('Please provide text or an image to analyze');
      }

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      // Handle response
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AnalysisResult.fromJson(jsonData);
      } else {
        // Parse error message from response
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['error'] ?? 'Analysis failed');
        } catch (e) {
          throw Exception('Server error: ${response.statusCode}');
        }
      }
    } on SocketException {
      throw Exception(
        'Cannot connect to server. Please check:\n'
        '1. Backend and gateway services are running\n'
        '2. API endpoint is configured correctly\n'
        '3. Device is on same network (for physical devices)'
      );
    } on http.ClientException {
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please try again');
      }
      rethrow;
    }
  }
}
