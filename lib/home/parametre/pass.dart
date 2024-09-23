import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordValid = false;
  bool _containsNumber = false;
  bool _passwordsMatch = false;

  void _validatePassword(String password) {
    setState(() {
      _isPasswordValid = password.length >= 6;
      _containsNumber = RegExp(r'\d').hasMatch(password);
      _passwordsMatch = password == _confirmPasswordController.text;
    });
  }

  void _validateConfirmPassword(String password) {
    setState(() {
      _passwordsMatch = password == _newPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Go back'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change your password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Please enter your new password',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 32),
                TextField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Old Password',
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _newPasswordController,
                  obscureText: !_isPasswordVisible,
                  onChanged: _validatePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter New Password',
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  onChanged: _validateConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm New Password',
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      _isPasswordValid
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _isPasswordValid
                          ? Color.fromARGB(255, 255, 123, 0)
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('At least 6 characters'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _containsNumber
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _containsNumber ? Colors.yellow : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('Contains a number'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _passwordsMatch
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _passwordsMatch
                          ? Color.fromARGB(255, 218, 237, 9)
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('Passwords match'),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        _isPasswordValid && _containsNumber && _passwordsMatch
                            ? () {
                                // Action when user clicks on change password button
                              }
                            : null,
                    child: Text('Done'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.yellow,
                      backgroundColor: Color(0xFFFFC107), // Text color
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 24.0),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
