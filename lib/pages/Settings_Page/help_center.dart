import 'package:flutter/material.dart';
import '../../app_ui.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Help Center',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppUi.offWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Study Buddy Help Center',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 24),
            _buildSection(
              context,
              'Getting Started',
              'Welcome to Study Buddy! This app helps you organize your classes, create study materials, and connect with classmates. To get started, create an account and set up your profile.'
            ),
            _buildSection(
              context,
              'Navigating the Home Screen',
              'The home screen displays your classes and recent activities. Tap on a class to view its details, or use the bottom navigation bar to access different sections of the app:\n\n'
              '• Home: View your classes and recent activities\n'
              '• Study: Access study materials and flashcards\n'
              '• Chat: Connect with classmates\n'
              '• Settings: Manage your account and preferences'
            ),
            _buildSection(
              context,
              'Creating and Joining Classes',
              'To create a new class:\n'
              '1. Tap the "+" button on the home screen\n'
              '2. Enter the class name, description, and other details\n'
              '3. Tap "Create Class"\n\n'
              'To join an existing class:\n'
              '1. Tap the "Join" button on the home screen\n'
              '2. Enter the class code provided by your instructor or classmate\n'
              '3. Tap "Join Class"'
            ),
            _buildSection(
              context,
              'Managing Study Materials',
              'In the Study section, you can:\n\n'
              '• Create flashcards for quick review\n'
              '• Upload notes and documents\n'
              '• Set up study reminders\n'
              '• Track your study progress\n\n'
              'To create new study materials, tap the "+" button in the Study section and select the type of material you want to create.'
            ),
            _buildSection(
              context,
              'Connecting with Classmates',
              'The Chat section allows you to communicate with your classmates. You can:\n\n'
              '• Send direct messages to individual classmates\n'
              '• Participate in class group chats\n'
              '• Share study materials and resources\n'
              '• Ask and answer questions'
            ),
            _buildSection(
              context,
              'Account Settings',
              'In the Settings section, you can:\n\n'
              '• Update your profile information\n'
              '• Manage notification preferences\n'
              '• Change your password\n'
              '• View privacy policy and terms of service\n'
              '• Log out of your account'
            ),
            _buildSection(
              context,
              'Troubleshooting',
              'If you encounter any issues while using Study Buddy:\n\n'
              '• Check your internet connection\n'
              '• Restart the app\n'
              '• Update to the latest version\n'
              '• Clear the app cache in your device settings\n\n'
              'If problems persist, please contact our support team at support@studybuddy.app'
            ),
            _buildSection(
              context,
              'Contact Support',
              'Need additional help? Contact our support team:\n\n'
              'Email: support@studybuddy.app\n'
              'Hours: Monday-Friday, 9am-5pm EST'
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}