// notification_history.dart

import 'package:flutter/material.dart';

class NotificationHistoryScreen extends StatefulWidget {
  @override
  _NotificationHistoryScreenState createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  List<String> notifications = []; // List to store notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification History'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(
                  'Notification ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(notifications[index]),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Implement any action when tapping on a notification
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to add new notifications
  void addNotification(String message) {
    setState(() {
      notifications.add(message);
    });
  }
}
