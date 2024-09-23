import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megatel/login/setpass.dart';
// Import the next screen file

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key, required verificationCode})
      : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  List<String> _verificationCode = List.filled(6, '');
  int _remainingSeconds = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildAppBarTitle(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'image/verf.png',
                  height: 200, // Adjust the height as needed
                  fit: BoxFit
                      .contain, // Ensure the image fits within the container
                ),
                SizedBox(height: 20),
                Text(
                  'OTP Verification',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
                _buildOTPFields(),
                SizedBox(height: 20),
                _buildTimer(),
                SizedBox(height: 10),
                _buildResendButton(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verificationCode.join().length == 6
                      ? () => _submitVerificationCode(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Row _buildAppBarTitle() {
    return Row(
      children: [
        Image.asset(
          'image/logo.png',
          width: 40,
        ),
        SizedBox(width: 8),
        Text(
          'Mega Tel',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              validator: (value) {
                if (value!.isEmpty) {
                  return ' ';
                }
                return null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (index < 5) {
                    FocusScope.of(context).nextFocus();
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                }
                setState(() {
                  _verificationCode[index] = value;
                  if (_verificationCode.join().length == 6) {
                    _formKey.currentState!.validate();
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '00:${_remainingSeconds.toString().padLeft(2, '0')} Sec',
          style: TextStyle(
            fontSize: 16,
            color: _remainingSeconds == 0 ? Colors.red : null,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildResendButton() {
    return TextButton(
      onPressed: () {
        if (_remainingSeconds == 0) {
          _startCountdown();
          _resendOTP();
        }
      },
      child: Text(
        'Didn\'t receive code? Re-send',
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitVerificationCode(BuildContext context) {
    // Add your code to submit the OTP for verification here
    // For demonstration purposes, navigate to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SetNewPasswordScreen()), // Replace NextScreen() with the desired next screen
    );
  }

  void _resendOTP() {
    // Add your code to resend OTP here
  }
}
