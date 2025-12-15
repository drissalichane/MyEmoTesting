import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/glass_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class AiCompanionScreen extends StatefulWidget {
  const AiCompanionScreen({super.key});

  @override
  State<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends State<AiCompanionScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the microphone to start talking...";
  String _aiResponse = "";
  String _sentiment = "NEUTRAL";
  double _riskScore = 0;
  bool _isProcessing = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) => debugPrint('onStatus: $status'),
      onError: (errorNotification) => debugPrint('onError: $errorNotification'),
    );
    setState(() {});
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      if (_speechAvailable) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      } else {
        setState(() => _text = "Speech recognition not available");
      }
    }
  }

  Future<void> _stopListening() async {
    _speech.stop();
    setState(() {
      _isListening = false;
      _isProcessing = true;
    });

    if (_text.isNotEmpty && _text != "Press the microphone to start talking...") {
      await _analyzeText();
    } else {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _analyzeText() async {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return;

    try {
      final response = await ApiService.analyzeVoiceText(_text, user['id']);
      
      if (response != null) {
          setState(() {
            _aiResponse = response['aiResponse'];
            _sentiment = response['sentimentDetected'];
            _riskScore = (response['riskScore'] as num).toDouble();
            _isProcessing = false;
          });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _aiResponse = "Error analyzing voice: $e";
      });
    }
  }

  Color _getSentimentColor() {
    switch (_sentiment) {
      case 'POSITIVE': return AppColors.success;
      case 'ANXIOUS': return AppColors.warning;
      case 'DEPRESSIVE': return AppColors.danger;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('AI Companion'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // AI Visualizer / Avatar
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getSentimentColor().withOpacity(0.1),
                  border: Border.all(color: _getSentimentColor(), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: _getSentimentColor().withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ]
                ),
                child: Center(
                  child: Icon(
                    Icons.psychology, 
                    size: 80, 
                    color: _getSentimentColor()
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              Text(
                'Current Mood: $_sentiment',
                style: TextStyle(
                  color: _getSentimentColor(),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2
                ),
              ),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // User Transcript
                    if (_text.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16, left: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                              )
                            ]
                          ),
                          child: Text(
                            _text,
                            style: const TextStyle(color: AppColors.textDark),
                          ),
                        ),
                      ),

                    // AI Response
                    if (_isProcessing)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    if (_aiResponse.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlassCard(
                          margin: const EdgeInsets.only(bottom: 16, right: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _aiResponse,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: AppColors.textDark
                                ),
                              ),
                              if (_riskScore > 50)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline, size: 16, color: AppColors.textLight),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Doctor notified (Risk: ${_riskScore.toInt()})',
                                        style: const TextStyle(
                                          fontSize: 12, 
                                          color: AppColors.textLight,
                                          fontStyle: FontStyle.italic
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Mic Button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _isListening 
                        ? const LinearGradient(colors: [Colors.redAccent, Colors.red])
                        : AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : AppColors.primary).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: _isListening ? 10 : 2,
                        )
                      ]
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
