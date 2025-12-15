import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/login_screen.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    
    if (token != null) {
      try {
        // Verify token by fetching user profile
        final userData = await ApiService.get('/users/me');
        _currentUser = userData;
        _isAuthenticated = true;
      } catch (e) {
        // Token invalid or expired
        await logout();
      }
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }
  
  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      }, withToken: false);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response['accessToken']);
      await prefs.setString('refreshToken', response['refreshToken']);
      
      _currentUser = {
        'id': response['userId'],
        'email': response['email'],
        'firstName': response['firstName'],
        'lastName': response['lastName'],
        'role': response['role'],
      };
      
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': 'PATIENT', // Default role
        // Optional fields can be added later or defaults provided
        'consentVoiceRecording': true,
        'consentDataSharing': true,
      }, withToken: false);
      
      // Auto login after registration or handle API specific response
      // For now, assume we need to login separately or response contains tokens
      // If backend returns tokens on register, we can save them here.
      // RegisterRequest usually returns AuthResponse in this backend?
      // Checking AuthResponse.java provided earlier (User state implies it exists but I didn't read it, 
      // but Login returns tokens, so Register probably does too or returns UserDTO).
      // Safest is to just return and let UI navigate to login or auto-login.
      
      // If the backend returns tokens immediately (like login), we can set session.
      if (response != null && response['accessToken'] != null) {
         final prefs = await SharedPreferences.getInstance();
         await prefs.setString('accessToken', response['accessToken']);
         if (response['refreshToken'] != null) {
           await prefs.setString('refreshToken', response['refreshToken']);
         }
         
         _currentUser = {
           'id': response['userId'],
           'email': response['email'],
           'firstName': response['firstName'],
           'lastName': response['lastName'],
           'role': response['role'],
         };
         _isAuthenticated = true;
         notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

