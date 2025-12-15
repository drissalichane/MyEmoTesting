import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';

class QcmRunnerScreen extends StatefulWidget {
  final int testId;
  final int qcmId;
  final String title;

  const QcmRunnerScreen({
    super.key,
    required this.testId,
    required this.qcmId,
    required this.title,
  });

  @override
  State<QcmRunnerScreen> createState() => _QcmRunnerScreenState();
}

class _QcmRunnerScreenState extends State<QcmRunnerScreen> {
  late Future<List<dynamic>> _questionsFuture;
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {}; // questionId -> answer value

  @override
  void initState() {
    super.initState();
    _questionsFuture = ApiService.get('/qcms/${widget.qcmId}/questions')
        .then((data) => data as List<dynamic>);
  }

  void _submitAnswer(int questionId, dynamic value) {
    setState(() {
      _answers[questionId] = value;
    });
  }

  Future<void> _submitTest(List<dynamic> questions) async {
    // Construct payload
    // Backend expects: { answers: [ { question: { id: 1 }, selectedOptions: { value: "..." }, valueNumeric: ... } ] }
    // Actually looking at Answer.java/TestService.java:
    // Answer has `question` (object with ID) and `selectedOptions` (JSON) or `valueNumeric`.
    
    // Simplification for this MVP:
    List<Map<String, dynamic>> answerPayload = [];
    
    for (var q in questions) {
      final qId = q['id'];
      final type = q['questionType'];
      final value = _answers[qId];
      
      if (value == null) continue; // Skip unanswered? Or force answer?

      Map<String, dynamic> answerData = {
        'question': {'id': qId},
      };

      if (type == 'SCALE') {
        answerData['valueNumeric'] = value;
      } else if (type == 'SINGLE_CHOICE') {
        // Backend expects map: { "value": "option_value" }
        answerData['selectedOptions'] = {'value': value};
      } else if (type == 'MULTIPLE_CHOICE') {
        // Backend expects map: { "values": ["opt1", "opt2"] }
        answerData['selectedOptions'] = {'values': value};
      } else if (type == 'TEXT') {
        // Backend expects map: { "text": "answer text" }
        answerData['selectedOptions'] = {'text': value};
      }
      
      answerPayload.add(answerData);
    }

    try {
      await ApiService.post('/tests/${widget.testId}/submit', {'answers': answerPayload});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test Submitted Successfully!')));
        Navigator.pop(context, true); // Return true to refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<dynamic>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final questions = snapshot.data ?? [];
          if (questions.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          if (_currentIndex >= questions.length) {
            // End of test
            return Center(
              child: ElevatedButton(
                onPressed: () => _submitTest(questions),
                child: const Text('Submit Test'),
              ),
            );
          }

          final question = questions[_currentIndex];
          return _buildQuestionView(question, questions.length);
        },
      ),
    );
  }

  Widget _buildQuestionView(dynamic question, int totalQuestions) {
    final type = question['questionType'];
    final optionsData = question['options']; // JSON map
    
    // Parse options based on structure (assuming standard structure from seeds)
    // Structure: { "options": [ {"label": "...", "value": "..."}, ... ] }
    List<dynamic> options = [];
    if (optionsData != null && optionsData['options'] != null) {
      options = optionsData['options'];
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: (_currentIndex + 1) / totalQuestions),
          const SizedBox(height: 24),
          Text(
            'Question ${_currentIndex + 1}/$totalQuestions',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            question['questionText'],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: _buildInput(type, question['id'], options, question),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                TextButton(
                  onPressed: () => setState(() => _currentIndex--),
                  child: const Text('Previous'),
                )
              else
                const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  // Validate answer
                  if (_answers[question['id']] == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please answer the question')));
                    return;
                  }
                  
                  if (_currentIndex < totalQuestions - 1) {
                    setState(() => _currentIndex++);
                  } else {
                    // Show submit button explicitly or auto-submit?
                    // Let's go to summary screen or just show submit button layout
                    setState(() => _currentIndex++); // Will trigger "End of test" view
                  }
                },
                child: Text(_currentIndex == totalQuestions - 1 ? 'Finish' : 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String type, int qId, List<dynamic> options, dynamic questionJson) {
    if (type == 'SINGLE_CHOICE') {
      return Column(
        children: options.map((opt) {
          final val = opt['value'];
          return RadioListTile(
            title: Text(opt['text'] ?? opt['label'] ?? ''),
            value: val,
            groupValue: _answers[qId],
            onChanged: (v) => _submitAnswer(qId, v),
          );
        }).toList(),
      );
    } else if (type == 'MULTIPLE_CHOICE') {
      // Multiple selection checkboxes
      Set<String> selectedValues = Set<String>.from((_answers[qId] as List?)?.cast<String>() ?? []);
      
      return Column(
        children: options.map((opt) {
          final val = opt['value'];
          final isSelected = selectedValues.contains(val);
          
          return CheckboxListTile(
            title: Text(opt['text'] ?? opt['label'] ?? ''),
            value: isSelected,
            onChanged: (bool? checked) {
              setState(() {
                if (checked == true) {
                  selectedValues.add(val);
                } else {
                  selectedValues.remove(val);
                }
                _submitAnswer(qId, selectedValues.toList());
              });
            },
          );
        }).toList(),
      );
    } else if (type == 'SCALE') {
       // Assuming 1-10 slider
       final min = questionJson['options']?['min'] ?? 1;
       final max = questionJson['options']?['max'] ?? 10;
       
       double currentVal = (_answers[qId] as num?)?.toDouble() ?? min.toDouble();
       
       return Column(
         children: [
           Slider(
             value: currentVal,
             min: min.toDouble(),
             max: max.toDouble(),
             divisions: (max - min),
             label: currentVal.round().toString(),
             onChanged: (v) => _submitAnswer(qId, v),
           ),
           Text('Value: ${currentVal.round()}'),
         ],
       );
    } else if (type == 'TEXT') {
      // Text input field
      final controller = TextEditingController(text: _answers[qId]?.toString() ?? '');
      
      return TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter your answer here...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        onChanged: (value) => _submitAnswer(qId, value),
      );
    }
    
    return Text('Unsupported question type: $type');
  }
}
