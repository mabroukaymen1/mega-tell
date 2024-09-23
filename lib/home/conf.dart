import 'package:flutter/material.dart';

import 'package:megatel/home/agent.dart';
import 'package:megatel/home/filtre.dart';
import 'package:megatel/home/order.dart';

class ConfirmationScreen extends StatelessWidget {
  final String orderID;
  final List<Agent> selectedAgents;

  ConfirmationScreen({
    required this.orderID,
    required this.selectedAgents,
  });

  @override
  Widget build(BuildContext context) {
    // Create a new Order object
    final newOrder = Order(
      id: orderID,
      date: DateTime.now(),
      total: calculateTotalPrice(selectedAgents),
      items: selectedAgents
          .map(
            (agent) => OrderItem(
              name: agent.name,
              price: agent.hourlyPrice,
              quantity: 1,
            ),
          )
          .toList(),
    );

    // Add the new order to the orders list in OrderHistoryScreen
    OrderHistoryScreen.orders.add(newOrder);

    // Clear the selectedAgents list in BasketScreen
    // You can use a callback function or provider to update the BasketScreen state

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'image/logo.png',
              height: 40,
            ), // Update with your logo asset
            SizedBox(width: 10),
            Text(
              'Order Confirmation',
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.check_circle,
              size: 120,
              color: Colors.orange,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Order Confirmed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your order #$orderID has been confirmed. We will send you a confirmation email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Orders Screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderHistoryScreen()),
                  );
                },
                child: Text(
                  'View Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate back to the home screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice(List<Agent> agents) {
    double total = 0;
    for (var agent in agents) {
      total += agent.hourlyPrice * 0.9; // Apply 10% discount
    }
    return total;
  }
}
