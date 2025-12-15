import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class ChatConversationScreen extends StatefulWidget {
  final int doctorId;
  final String doctorName;

  const ChatConversationScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  List<ChatMessage> messages = [];
  late ChatUser _currentUser;
  late ChatUser _doctorUser;

  @override
  void initState() {
    super.initState();
    _initUsers();
    _loadHistory();
    _startPolling();
  }

  void _initUsers() {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user != null) {
      _currentUser = ChatUser(
        id: user['id'].toString(),
        firstName: user['firstName'],
        lastName: user['lastName'],
      );
    }
    
    _doctorUser = ChatUser(
      id: widget.doctorId.toString(),
      firstName: widget.doctorName,
    );
  }

  Future<void> _loadHistory() async {
    try {
      final history = await ApiService.get(
        '/chat/history/${_currentUser.id}/${widget.doctorId}'
      );
      
      if (history != null && history is List) {
        setState(() {
          messages = history.map((e) => _convertToChatMessage(e)).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  void _startPolling() {
    // Poll for new messages every 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _loadHistory();
        _startPolling();
      }
    });
  }

  ChatMessage _convertToChatMessage(Map<String, dynamic> data) {
    final senderId = data['senderId'].toString();
    final isMe = senderId == _currentUser.id;
    
    return ChatMessage(
      user: isMe ? _currentUser : _doctorUser,
      text: data['content'] ?? '',
      createdAt: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Future<void> _sendMessage(ChatMessage message) async {
    try {
      // Send via REST API
      await ApiService.post('/chat/send', {
        'senderId': int.parse(_currentUser.id),
        'recipientId': widget.doctorId,
        'content': message.text,
        'type': 'TEXT'
      }, withToken: true);

      // Optimistically add to UI
      setState(() {
        messages.insert(0, message);
      });
    } catch (e) {
      debugPrint('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  widget.doctorName[4], // First letter after "Dr. "
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(widget.doctorName)),
            ],
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video call feature coming soon!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice call feature coming soon!')),
                );
              },
            ),
          ],
        ),
        body: DashChat(
          currentUser: _currentUser,
          onSend: _sendMessage,
          messages: messages,
          inputOptions: InputOptions(
            inputDecoration: InputDecoration(
              hintText: "Message ${widget.doctorName}...",
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
      ),
    );
  }
}
