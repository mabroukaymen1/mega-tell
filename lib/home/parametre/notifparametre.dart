import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsService {
  static Future<Map<String, bool>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();
    Map<String, bool> acc = {};
    for (var key in keys) {
      dynamic value = prefs.get(key);
      if (value is bool) {
        acc[key] = value;
      } else {
        print('Unexpected data type for key: $key');
      }
    }
    return acc;
  }

  static Future<void> saveSettings(Map<String, bool> settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    settings.forEach((key, value) {
      prefs.setBool(key, value);
    });
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Map<String, bool> _notificationSettings;

  @override
  void initState() {
    super.initState();
    _notificationSettings = {};
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await NotificationSettingsService.loadSettings();
    setState(() {
      _notificationSettings = settings;
    });
  }

  Future<void> _saveSettings() async {
    await NotificationSettingsService.saveSettings(_notificationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'image/logo.png',
              width: 32,
              height: 32,
            ),
            SizedBox(width: 8),
            Text('Notifications'),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Common',
                [
                  'General Notification',
                  'Sound',
                  'Vibrate',
                  'System & services update',
                ],
              ),
              SizedBox(height: 20),
              _buildSection(
                'System & services update',
                [
                  'App updates',
                  'Bill Reminder',
                  'Promotion',
                  'Discount Available',
                  'Payment Request',
                ],
              ),
              SizedBox(height: 20),
              _buildSection(
                'Others',
                [
                  'New Service Available',
                  'New Tips Available',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ...notifications
            .map((notification) => _buildNotificationSwitch(notification))
            .toList(),
      ],
    );
  }

  Widget _buildNotificationSwitch(String notificationType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            notificationType,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Switch(
          value: _notificationSettings[notificationType] ?? false,
          onChanged: (value) {
            setState(() {
              _notificationSettings[notificationType] = value;
            });
          },
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}
