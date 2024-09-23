import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:megatel/configuration.dart';
import 'package:megatel/signup/verif.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _acceptedTerms = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController societyNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    return null;
  }

  // Define the URL for sending the email
  String sendEmailUrl =
      'https://your-email-service-api/send-email'; // Replace with your actual email service API endpoint

  void _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text,
          "userName": userNameController.text,
          "societyName": societyNameController.text,
          "phoneNumber": phoneNumberController.text,
          "email": emailController.text,
          "password": passwordController.text
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Generate a dynamic verification code
        final verificationCode = generateVerificationCode();

        // Send email to user
        var emailResponse = await http.post(
          Uri.parse(sendEmailUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": emailController.text,
            "subject": "Verification Code",
            "message": "Your verification code is: $verificationCode"
          }),
        );

        print('Email response status: ${emailResponse.statusCode}');
        print('Email response body: ${emailResponse.body}');
      } else {
        _showErrorDialog('Registration failed. Please try again.');
      }

      // Navigate to the VerificationCodeScreen regardless of the registration or email sending status
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCodeScreen1(
            verificationCode: generateVerificationCode(),
          ),
        ),
      );
    } catch (error) {
      print('Error: $error');
      _showErrorDialog('An error occurred. Please try again.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      if (_acceptedTerms) {
        _registerUser();
      } else {
        _showErrorDialog('Please accept the terms and conditions.');
      }
    } else {
      _showErrorDialog('Please fill all fields correctly.');
    }
  }

  String generateVerificationCode() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('image/logo.png', height: 40),
            SizedBox(width: 10),
            Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            _buildBackground(),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color.fromARGB(255, 240, 240, 240),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    _buildTextField(
                      controller: nameController,
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icons.person,
                      validator: _validateField,
                    ),
                    _buildTextField(
                      controller: userNameController,
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icons.person_outline,
                      validator: _validateField,
                    ),
                    _buildTextField(
                      controller: societyNameController,
                      labelText: 'Society Name',
                      hintText: 'Enter society name',
                      prefixIcon: Icons.apartment,
                      validator: _validateField,
                    ),
                    _buildPhoneTF(),
                    _buildTextField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    _buildPasswordTF(),
                    _buildTermsAndPrivacy(),
                    _buildSignUpBtn(),
                    const SizedBox(height: 20.0),
                    const Text(
                      'By clicking "Register", you agree that you have read and accepted the instructions.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    _buildSocialMediaButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.orange),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black54),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.orange)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.5)),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPhoneTF() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(color: Colors.orange),
          hintText: 'Enter your phone number',
          hintStyle: TextStyle(color: Colors.black54),
          prefixIcon: Icon(Icons.phone, color: Colors.orange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.5)),
          ),
        ),
        keyboardType: TextInputType.phone,
        validator: _validatePhoneNumber,
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: passwordController,
        obscureText: !_passwordVisible,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.orange),
          hintText: 'Enter your password',
          hintStyle: TextStyle(color: Colors.black54),
          prefixIcon: Icon(Icons.lock, color: Colors.orange),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.orange,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange.withOpacity(0.5)),
          ),
        ),
        validator: _validatePassword,
      ),
    );
  }

  Widget _buildTermsAndPrivacy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value!;
              });
            },
            activeColor: Colors.orange,
          ),
          Flexible(
            child: Text(
              'I agree with Terms of Service and Privacy Policy',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
          child: Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              'image/go.png', // Replace with your Google logo
              height: 30,
            ),
          ),
          SizedBox(width: 20),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              'image/fb.png', // Replace with your Facebook logo
              height: 30,
            ),
          ),
          SizedBox(width: 20),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset(
              'image/ap.png', // Replace with your Apple logo
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
