import 'package:flutter/material.dart';
import '../../app_ui.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Privacy Policy',
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
              'Privacy Policy for Study Buddy',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: November 2023',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppUi.grey,
              ),
            ),
            SizedBox(height: 24),
            _buildSection(
              context,
              'Introduction',
              'Study Buddy ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.'
            ),
            _buildSection(
              context,
              'Information We Collect',
              'We may collect information about you in various ways, including:\n\n'
              '• Personal Data: Name, email address, and profile information you provide when creating an account.\n'
              '• Usage Data: Information about how you use the app, including study habits, class participation, and feature usage.\n'
              '• Device Data: Information about your mobile device, including device type, operating system, and unique device identifiers.'
            ),
            _buildSection(
              context,
              'How We Use Your Information',
              'We may use the information we collect for various purposes, including:\n\n'
              '• To provide and maintain our service\n'
              '• To notify you about changes to our service\n'
              '• To allow you to participate in interactive features\n'
              '• To provide customer support\n'
              '• To gather analysis or valuable information to improve our service\n'
              '• To monitor the usage of our service\n'
              '• To detect, prevent and address technical issues'
            ),
            _buildSection(
              context,
              'Disclosure of Your Information',
              'We may share your information with:\n\n'
              '• Service Providers: Third-party companies that perform services on our behalf\n'
              '• Business Partners: With your consent, we may share your information with our business partners\n'
              '• Legal Requirements: We may disclose your information where required by law'
            ),
            _buildSection(
              context,
              'Security of Your Information',
              'We use administrative, technical, and physical security measures to protect your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure.'
            ),
            _buildSection(
              context,
              'Your Choices',
              'You can access, update, or delete your account information at any time through the app settings. You may also contact us to request access to, correct, or delete any personal information we have about you.'
            ),
            _buildSection(
              context,
              'Children\'s Privacy',
              'Our service is not directed to anyone under the age of 13. We do not knowingly collect personal information from children under 13. If we discover that a child under 13 has provided us with personal information, we will delete it immediately.'
            ),
            _buildSection(
              context,
              'Changes to This Privacy Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.'
            ),
            _buildSection(
              context,
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@studybuddy.app.'
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