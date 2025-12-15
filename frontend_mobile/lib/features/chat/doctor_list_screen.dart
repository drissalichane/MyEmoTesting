import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import 'chat_conversation_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Map<String, dynamic>> conversations = [];
  bool isLoading = true;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final user = Provider.of<AuthService>(context, listen: false).currentUser;
      if (user == null) return;
      
      currentUserId = user['id'];

      // Get all doctors
      final doctors = await ApiService.get('/users/doctors') as List<dynamic>;
      
      // Get conversation history for each doctor
      List<Map<String, dynamic>> conversationList = [];
      
      for (var doctor in doctors) {
        try {
          final history = await ApiService.get(
            '/chat/history/${currentUserId}/${doctor['id']}'
          );
          
          String lastMessage = '';
          DateTime? lastMessageTime;
          
          if (history != null && history is List && history.isNotEmpty) {
            final lastMsg = history.last;
            lastMessage = lastMsg['content'] ?? '';
            lastMessageTime = DateTime.parse(lastMsg['timestamp'] ?? DateTime.now().toIso8601String());
          }
          
          conversationList.add({
            'doctor': doctor,
            'lastMessage': lastMessage,
            'lastMessageTime': lastMessageTime,
            'hasMessages': history != null && (history as List).isNotEmpty,
          });
        } catch (e) {
          // If no history, still add doctor but with no last message
          conversationList.add({
            'doctor': doctor,
            'lastMessage': '',
            'lastMessageTime': null,
            'hasMessages': false,
          });
        }
      }
      
      // Sort: conversations with messages first (by time), then doctors without messages
      conversationList.sort((a, b) {
        if (a['hasMessages'] && !b['hasMessages']) return -1;
        if (!a['hasMessages'] && b['hasMessages']) return 1;
        
        if (a['lastMessageTime'] != null && b['lastMessageTime'] != null) {
          return b['lastMessageTime'].compareTo(a['lastMessageTime']);
        }
        
        // If both have no messages, sort alphabetically
        return (a['doctor']['firstName'] as String)
            .compareTo(b['doctor']['firstName'] as String);
      });
      
      setState(() {
        conversations = conversationList;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading conversations: $e');
      setState(() => isLoading = false);
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays == 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversations.isEmpty
              ? const Center(child: Text('No doctors available'))
              : RefreshIndicator(
                  onRefresh: _loadConversations,
                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      final doctor = conv['doctor'];
                      final lastMessage = conv['lastMessage'] as String;
                      final lastMessageTime = conv['lastMessageTime'] as DateTime?;
                      
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(
                            doctor['firstName'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          'Dr. ${doctor['firstName']} ${doctor['lastName']}',
                          style: TextStyle(
                            fontWeight: lastMessage.isNotEmpty 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          lastMessage.isEmpty 
                              ? 'Start a conversation' 
                              : lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: lastMessage.isEmpty 
                                ? Colors.grey 
                                : Colors.black87,
                          ),
                        ),
                        trailing: lastMessageTime != null
                            ? Text(
                                _formatTime(lastMessageTime),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatConversationScreen(
                                doctorId: doctor['id'],
                                doctorName: 'Dr. ${doctor['firstName']} ${doctor['lastName']}',
                              ),
                            ),
                          );
                          
                          // Refresh list when returning from chat
                          if (result == true) {
                            _loadConversations();
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
