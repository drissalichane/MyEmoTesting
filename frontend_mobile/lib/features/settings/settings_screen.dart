import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6B8EFF), // Soft Blue
                  Color(0xFFFF8FB1), // Soft Pink
                  Color(0xFFB39DDB), // Light Purple
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Profile Card
                  GlassCard(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user?['firstName'] ?? 'User'} ${user?['lastName'] ?? ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user?['email'] ?? 'No Email',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildSettingItem(context, 'Notifications', Icons.notifications, true),
                        const Divider(height: 1, color: Colors.white24, indent: 56),
                        _buildSettingItem(context, 'Dark Mode', Icons.dark_mode, false),
                        const Divider(height: 1, color: Colors.white24, indent: 56),
                        _buildSettingItem(context, 'Language', Icons.language, null, trailing: 'English'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildSettingItem(context, 'Change Password', Icons.lock, null),
                        const Divider(height: 1, color: Colors.white24, indent: 56),
                        _buildSettingItem(context, 'Privacy Policy', Icons.privacy_tip, null),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  GlassCard(
                    onTap: () async {
                      // Confirm logout
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        authService.logout();
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon, bool? switchValue, {String? trailing}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: switchValue != null
          ? Switch(
              value: switchValue,
              onChanged: (val) {},
              activeColor: AppColors.accent,
            )
          : trailing != null 
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trailing, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                  ],
                )
              : const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
      onTap: () {},
    );
  }
}
