import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import 'qcm_runner_screen.dart';

class TestListScreen extends StatefulWidget {
  const TestListScreen({super.key});

  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  late Future<List<dynamic>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testsFuture = _fetchTests();
  }

  Future<List<dynamic>> _fetchTests() async {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return [];
    
    final patientId = user['id'];
    final result = await ApiService.get('/tests/patient/$patientId');
    if (result is List) {
      return result;
    }
    return [];
  }

  Future<void> _startNewTest() async {
    // 1. Fetch available templates
    try {
      final templates = await ApiService.get('/qcms');
      if (templates is! List) throw 'Invalid format';

      if (!mounted) return;

      // 2. Show selection dialog
      final selectedTemplate = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Start New Test'),
          children: templates.map<Widget>((t) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, t),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(t['title'] ?? 'Untitled Test', style: const TextStyle(fontSize: 16)),
              ),
            );
          }).toList(),
        ),
      );

      if (selectedTemplate == null) return;

      // 3. Start Test
      final user = Provider.of<AuthService>(context, listen: false).currentUser;
      if (user == null) return;

      final body = {
        'patientId': user['id'],
        'qcmId': selectedTemplate['id'],
        'phaseId': user['currentPhase'] ?? 1 
      };

      final newTest = await ApiService.post('/tests/start', body);
      
      if (newTest != null) {
        // Refresh list
        setState(() {
          _testsFuture = _fetchTests();
        });
        
        // Navigate to runner immediately
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QcmRunnerScreen(
              testId: newTest['id'],
              qcmId: selectedTemplate['id'],
              title: selectedTemplate['title'],
            ),
          ),
        ).then((_) => setState(() => _testsFuture = _fetchTests()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error starting test: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tests')),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewTest,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tests = snapshot.data ?? [];
          
          if (tests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No tests found.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _startNewTest,
                    child: const Text('Start New Test'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(Icons.assignment, color: AppColors.primary),
                  ),
                  title: Text(test['qcmTemplate']?['title'] ?? 'Test #${test['id']}'),
                  subtitle: Text('Status: ${test['status']}'),
                  trailing: test['status'] == 'IN_PROGRESS' || test['status'] == 'SCHEDULED' // Simplified check
                      ? ElevatedButton(
                          onPressed: () async {
                            final shouldRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QcmRunnerScreen(
                                  testId: test['id'],
                                  qcmId: test['qcmTemplate']['id'],
                                  title: test['qcmTemplate']['title'],
                                ),
                              ),
                            );
                            
                            if (shouldRefresh == true) {
                               setState(() {
                                 _testsFuture = _fetchTests();
                               });
                            }
                          },
                          child: const Text('Start'),
                        )
                      : const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
