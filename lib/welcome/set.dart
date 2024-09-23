import 'package:flutter/material.dart';
import 'package:megatel/login/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyScreen extends StatelessWidget {
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background photo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/2.png'), // Background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo at the top center
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Image.asset(
              'image/logo1.png',
              width: 120,
              height: 120,
            ),
          ),
          // PageView and SmoothPageIndicator
          Positioned.fill(
            top: 250,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: [
                      PageOne(),
                      PageTwo(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 2,
                    effect: WormEffect(
                      activeDotColor: Colors.orange,
                      dotColor: Colors.white.withOpacity(0.6),
                      dotHeight: 12,
                      dotWidth: 12,
                      spacing: 8,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Get Started'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to MegaTel',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Your Go-To for digital customer service solutions. With over 7 years of success, we\'re committed to excellence and reliability.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Outstanding Communication',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'We specialize in high-quality communication solutions tailored to your needs. Exceeding your expectations is our promise.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
