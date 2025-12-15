import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart'; // For fetching history

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  StompClient? stompClient;
  List<ChatMessage> messages = [];
  late ChatUser _currentUser;
  ChatUser _doctorUser = ChatUser(
    id: '0', 
    firstName: 'Dr. Smith', 
    profileImage: 'https://i.pravatar.cc/150?img=11'
  );

  @override
  void initState() {
    super.initState();
    _initUser();
    // Delay connection slightly to ensure init
    Future.delayed(Duration.zero, () {
      _connectWebSocket();
      _loadHistory();
    });
  }

  void _initUser() {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user != null) {
      _currentUser = ChatUser(
        id: user['id'].toString(),
        firstName: user['firstName'],
        lastName: user['lastName'],
        profileImage: 'https://i.pravatar.cc/150?img=12'
      );
    }
  }

  void _connectWebSocket() {
    // Derive WS URL from API Base URL
    // http://localhost:8082/api -> ws://localhost:8082/ws
    final baseUrl = ApiService.baseUrl;
    final wsUrl = baseUrl.replaceFirst('http', 'ws').replaceFirst('/api', '/ws');

    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: onConnect,
        beforeConnect: () async {
          debugPrint('waiting to connect...');
        },
        onWebSocketError: (dynamic error) => debugPrint(error.toString()),
      ),
    );
    stompClient?.activate();
  }

  void onConnect(StompFrame frame) {
    // Subscribe to my private queue
    stompClient?.subscribe(
      destination: '/user/${_currentUser.id}/queue/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          final message = _convertToChatMessage(data);
          setState(() {
            messages.insert(0, message);
          });
        }
      },
    );
  }

  Future<void> _loadHistory() async {
    try {
      // 1. Fetch available doctors
      final doctors = await ApiService.get('/users/doctors');
      if (doctors is List && doctors.isNotEmpty) {
        final doctorData = doctors[0];
        _doctorUser = ChatUser(
          id: doctorData['id'].toString(),
          firstName: doctorData['firstName'] ?? 'Doctor',
          lastName: doctorData['lastName'] ?? '',
          profileImage: 'https://i.pravatar.cc/150?img=11'
        );
        setState(() {}); // Update title
        
        // 2. Fetch history with this doctor
        final history = await ApiService.get('/chat/history/${_currentUser.id}/${_doctorUser.id}'); 
        
        if (history != null && history is List) {
           setState(() {
             messages = history.map((e) => _convertToChatMessage(e)).toList();
           });
        }
      } else {
        debugPrint('No doctors found');
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  ChatMessage _convertToChatMessage(Map<String, dynamic> data) {
    final senderId = data['senderId'].toString();
    final isMe = senderId == _currentUser.id;
    
    return ChatMessage(
      user: isMe ? _currentUser : _doctorUser,
      text: data['text'] ?? data['content'] ?? '', // Handle both fields
      createdAt: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  void _sendMessage(ChatMessage message) {
    // Send via WebSocket
    stompClient?.send(
      destination: '/app/chat',
      body: jsonEncode({
        'senderId': int.parse(_currentUser.id),
        'recipientId': int.parse(_doctorUser.id),
        'content': message.text,
        'type': 'TEXT'
      }),
    );

    // Optimistically add to UI
    setState(() {
      messages.insert(0, message);
    });
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(_doctorUser.profileImage!),
            ),
            const SizedBox(width: 10),
            Text(_doctorUser.firstName!),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {
            // Video Call Trigger
          }),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        ],
      ),
      body: DashChat(
        currentUser: _currentUser,
        onSend: _sendMessage,
        messages: messages,
        inputOptions: const InputOptions(
          inputDecoration: InputDecoration(
            hintText: "Write to Dr. Smith...",
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
          ),
          alwaysShowSend: true,
        ),
        messageOptions: const MessageOptions(
          currentUserContainerColor: AppColors.primary,
          containerColor: Color(0xFFE0E0E0),
          textColor: Colors.black,
          currentUserTextColor: Colors.white,
        ),
      ),
    );
  }
}
