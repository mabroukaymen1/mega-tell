import 'dart:math';
import 'package:flutter/material.dart';
import 'package:megatel/login/forget_verif.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isWhatsAppSelected = true;
  TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'image/logo.png', // Replace with your logo asset path
          height: 32,
          width: 32,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.error,
              color: Colors.red,
            );
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Don't worry! It happens. Select which contact details should we use to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              _buildContactOption(
                label: 'Send via WhatsApp',
                hint: 'Enter your phone number',
                isSelected: _isWhatsAppSelected,
                onTap: () {
                  setState(() {
                    _isWhatsAppSelected = true;
                    _contactController.clear();
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildContactOption(
                label: 'Send via Email',
                hint: 'Enter your email',
                isSelected: !_isWhatsAppSelected,
                onTap: () {
                  setState(() {
                    _isWhatsAppSelected = false;
                    _contactController.clear();
                  });
                },
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _contactController,
                keyboardType: _isWhatsAppSelected
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: _isWhatsAppSelected ? 'Phone Number' : 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendValidationCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required String label,
    required String hint,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.grey[200],
        ),
        child: Row(
          children: [
            isSelected
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.orange,
                  )
                : Icon(
                    Icons.circle_outlined,
                    color: Colors.grey[600],
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              hint,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendValidationCode() {
    if (_contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please enter your ${_isWhatsAppSelected ? 'phone number' : 'email'}'),
        ),
      );
      return;
    }

    // Generate a 6-digit verification code
    String verificationCode = _generateVerificationCode();

    // Implement your logic to send the verification code via email or WhatsApp
    if (_isWhatsAppSelected) {
      _sendWhatsAppCode(verificationCode);
    } else {
      _sendEmailCode(verificationCode);
    }

    // Navigate to VerificationCodeScreen after sending the code
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VerificationCodeScreen(
          verificationCode: null,
        ),
      ),
    );
  }

  String _generateVerificationCode() {
    // Generate a random 6-digit number
    Random random = Random();
    int min = 100000; // Minimum value for a 6-digit number
    int max = 999999; // Maximum value for a 6-digit number
    int randomCode = min + random.nextInt(max - min + 1);
    return randomCode.toString();
  }

  void _sendWhatsAppCode(String code) {
    // Placeholder function to simulate sending a WhatsApp message
    print('Sending WhatsApp code $code to ${_contactController.text}');
  }

  void _sendEmailCode(String code) {
    // Placeholder function to simulate sending an email
    print('Sending email code $code to ${_contactController.text}');
  }
}
