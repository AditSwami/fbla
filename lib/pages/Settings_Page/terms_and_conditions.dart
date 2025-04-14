import 'package:flutter/material.dart';
import '../../app_ui.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Terms and Conditions',
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
              'Terms and Conditions for Study Buddy',
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
              'Acceptance of Terms',
              'By accessing or using the Study Buddy application ("App"), you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the App.'
            ),
            _buildSection(
              context,
              'User Accounts',
              'To use certain features of the App, you may be required to register for an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.'
            ),
            _buildSection(
              context,
              'User Content',
              'You retain ownership of any content you submit to the App. By submitting content, you grant Study Buddy a worldwide, non-exclusive, royalty-free license to use, reproduce, and display such content in connection with providing and promoting the App.'
            ),
            _buildSection(
              context,
              'Prohibited Activities',
              'You agree not to engage in any of the following activities: (1) Using the App for any illegal purpose; (2) Attempting to interfere with or disrupt the App; (3) Impersonating any person or entity; (4) Collecting user information without their consent.'
            ),
            _buildSection(
              context,
              'Intellectual Property',
              'The App and its original content, features, and functionality are owned by Study Buddy and are protected by international copyright, trademark, and other intellectual property laws.'
            ),
            _buildSection(
              context,
              'Disclaimer of Warranties',
              'The App is provided "as is" without warranties of any kind, either express or implied. Study Buddy does not warrant that the App will be error-free or uninterrupted.'
            ),
            _buildSection(
              context,
              'Limitation of Liability',
              'Study Buddy shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the App.'
            ),
            _buildSection(
              context,
              'Changes to Terms',
              'Study Buddy reserves the right to modify these Terms at any time. We will provide notice of significant changes by updating the "Last Updated" date at the top of these Terms.'
            ),
            _buildSection(
              context,
              'Governing Law',
              'These Terms shall be governed by the laws of the United States without regard to its conflict of law provisions.'
            ),
            _buildSection(
              context,
              'Contact Us',
              'If you have any questions about these Terms, please contact us at support@studybuddy.app.'
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