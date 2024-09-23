import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'image/logo.png',
              fit: BoxFit.cover,
              width: 40,
            ),
            const SizedBox(width: 8),
            Text(
              'Privacy Policy',
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildPolicySection(
                    context,
                    icon: Icons.info,
                    title: 'Types of Data Collected',
                    content:
                        'We collect the following types of information:\n\n- Device information\n- Location data\n- Usage data\n- User-provided data',
                  ),
                  Divider(),
                  _buildPolicySection(
                    context,
                    icon: Icons.assignment_turned_in,
                    title: 'Use of Personal Data',
                    content:
                        'We use your personal data to:\n\n- Improve our app\n- Personalize your experience\n- Deliver targeted advertising (if applicable)',
                  ),
                  Divider(),
                  _buildPolicySection(
                    context,
                    icon: Icons.share,
                    title: 'Disclosure of Personal Data',
                    content:
                        'We may disclose your personal data to third-party service providers, analytics platforms, or advertisers.',
                  ),
                  Divider(),
                  _buildPolicySection(
                    context,
                    icon: Icons.timelapse,
                    title: 'Data Retention',
                    content:
                        'We will retain your personal data for as long as necessary to fulfill the purposes described in this privacy policy.',
                  ),
                  Divider(),
                  _buildPolicySection(
                    context,
                    icon: Icons.security,
                    title: 'Security',
                    content:
                        'We take reasonable measures to protect your personal data from unauthorized access, disclosure, alteration, or destruction.',
                  ),
                  Divider(),
                  _buildPolicySection(
                    context,
                    icon: Icons.update,
                    title: 'Changes to the Privacy Policy',
                    content:
                        'We will update this privacy policy from time to time.',
                  ),
                  Divider(),
                  _buildPolicySection(
                    context,
                    icon: Icons.mail,
                    title: 'Contact Us',
                    content:
                        'If you have any questions about this privacy policy, please contact us at: [Your email address]\n\n[Your company name]',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection(BuildContext context,
      {required IconData icon,
      required String title,
      required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
