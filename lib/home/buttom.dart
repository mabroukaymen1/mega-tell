import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({required this.onItemTapped});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  static const double _beginScale = 1.0;
  static const double _endScale = 1.2;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const double _iconSize = 30;
  static const double _splashRadius = 25;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _animation = Tween<double>(begin: _beginScale, end: _endScale)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      _startAnimation();
    });
    widget.onItemTapped(index);
  }

  void _startAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_outlined, 0),
          _buildNavItem(Icons.shopping_basket_outlined, 1),
          _buildNavItem(Icons.favorite_border_outlined, 2),
          _buildNavItem(Icons.person_outline, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return ScaleTransition(
      scale: _currentIndex == index ? _animation : AlwaysStoppedAnimation(1.0),
      child: IconButton(
        icon: Icon(
          icon,
          color: _currentIndex == index ? Colors.orange : Colors.grey,
        ),
        onPressed: () => _onTap(index),
        iconSize: _iconSize,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        splashRadius: _splashRadius,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
