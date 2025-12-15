import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator to access localhost
  // Use localhost for iOS simulator
  // Use your machine's IP for physical devices
  // Use 10.0.2.2 for Android emulator to access localhost
  // Use localhost for iOS simulator
  // Use your machine's IP for physical devices
  // static const String baseUrl = 'http://10.0.2.2:8082/api';
  static const String baseUrl = 'http://localhost:8082/api';
  
  static Future<Map<String, String>> getHeaders({bool withToken = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (withToken) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  static Future<dynamic> get(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }
  
  static Future<dynamic> post(String endpoint, dynamic data, {bool withToken = true}) async {
    final headers = await getHeaders(withToken: withToken);
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'), 
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }
  
  static Future<dynamic> getDashboardData() async {
    return get('/dashboard/patient/me');
  }

  static Future<dynamic> uploadVoiceRecord(String filePath, int patientId) async {
    final headers = await getHeaders(withToken: true);
    // Remove content-type for multipart request as it is set automatically
    headers.remove('Content-Type'); 
    
    final request = http.MultipartRequest('POST', Uri.parse('${baseUrl}/ai/analyze'));
    request.headers.addAll(headers);
    request.fields['patientId'] = patientId.toString();
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseBody.isEmpty) return null;
      return jsonDecode(responseBody);
    } else {
      throw Exception('API Error: ${response.statusCode} - $responseBody');
    }
  }

  static Future<dynamic> analyzeVoiceText(String transcript, int patientId) async {
    return post('/ai/analyze-text', {
      'patientId': patientId,
      'transcript': transcript
    });
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
