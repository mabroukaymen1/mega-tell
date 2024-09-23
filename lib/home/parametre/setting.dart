import 'package:flutter/material.dart';

import 'package:megatel/home/parametre/card.dart';
import 'package:megatel/home/parametre/help.dart';
import 'package:megatel/home/parametre/notifparametre.dart';
import 'package:megatel/home/parametre/pass.dart';
import 'package:megatel/home/parametre/privcy.dart';
import 'package:megatel/home/parametre/rating.dart';
import 'package:megatel/home/profileuser.dart';
import 'package:megatel/login/login.dart';

class ParameterScreen extends StatelessWidget {
  final ThemeData theme;

  ParameterScreen({required this.theme});

  @override
  Widget build(BuildContext context) {
    const double paddingValue = 20.0;
    const TextStyle titleStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    const TextStyle settingTitleStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    String clientName = 'Aymen Mabrouk';
    String clientEmail = 'aymenmabrouk803@gmail.com';
    String clientPhotoUrl =
        'image/ppp.jpg'; // Replace with your asset image path

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'image/logo.png', // Replace with your logo path
              fit: BoxFit.cover,
              width: 40,
            ),
            const SizedBox(width: 8),
            Text(
              'Mega Tel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _navigateToScreen(context, ProfileScreen()),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(clientPhotoUrl),
                ),
              ),
              SizedBox(height: 20),
              Text(
                clientName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                clientEmail,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),
              _buildTitle('Profile', titleStyle),
              _buildSettingTile(
                title: 'Edit Profile',
                icon: Icons.person,
                onTap: () => _navigateToScreen(context, ProfileScreen()),
              ),
              _buildSettingTile(
                title: 'Notifications',
                icon: Icons.notifications,
                onTap: () => _navigateToScreen(context, NotificationScreen()),
              ),
              _buildSettingTile(
                title: 'Extra Card',
                icon: Icons.card_giftcard,
                onTap: () => _navigateToScreen(context, PaymentCardForm()),
              ),
              SizedBox(height: 20),
              _buildTitle('Support', titleStyle),
              _buildSettingTile(
                title: 'Change Password',
                icon: Icons.lock,
                onTap: () => _navigateToScreen(context, AccountSettingsPage()),
              ),
              _buildSettingTile(
                title: 'Privacy',
                icon: Icons.lock,
                onTap: () => _navigateToScreen(context, PrivacyPolicyPage()),
              ),
              _buildSettingTile(
                title: 'Help & Feedback',
                icon: Icons.help,
                onTap: () =>
                    _navigateToScreen(context, HelpAndFeedbackScreen()),
              ),
              _buildSettingTile(
                title: 'Love this app? Rate us',
                icon: Icons.star,
                onTap: () => _navigateToScreen(context, RatingScreen()),
              ),
              _buildSettingTile(
                title: 'Logout',
                icon: Icons.exit_to_app,
                onTap: () => _confirmAccountDeletion(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      leading: Icon(icon, color: Colors.black87),
      trailing: Icon(Icons.chevron_right, color: Colors.black87),
      onTap: onTap,
    );
  }

  Widget _buildTitle(String title, TextStyle style) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: style,
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _confirmAccountDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Account Deletion'),
          content: Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false, // Remove all previous routes
                );
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
