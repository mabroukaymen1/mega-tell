import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:megatel/welcome/set.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLogoLoaded = false; // Track whether the logo animation is loaded

  @override
  void initState() {
    super.initState();
    _navigateToSecondPageAfterDelay();
  }

  // Delay navigation to SecondPage
  void _navigateToSecondPageAfterDelay() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyScreen(), // Navigate to SecondPage
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          _buildBackgroundImage(),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                _buildLogo(),
                // Loading Indicator
                if (_isLogoLoaded) _buildLoadingIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('image/2.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Lottie.asset(
        'gif/megalogo1.json',
        width: 300,
        height: 300,
        onLoaded: (composition) {
          setState(() {
            _isLogoLoaded = true;
          });
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return CircularProgressIndicator(
      color: Color.fromARGB(255, 243, 83, 3),
    );
  }
}
