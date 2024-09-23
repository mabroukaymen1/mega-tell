import 'package:flutter/material.dart';

import 'package:megatel/home/agent.dart';
import 'package:megatel/home/conf.dart';

class BasketScreen extends StatefulWidget {
  final List<Agent> selectedAgents;

  const BasketScreen({
    Key? key,
    required this.selectedAgents,
    required List basket,
  }) : super(key: key);

  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final TextStyle _customTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  double _calculateSubtotal() {
    double subtotal = 0;
    for (Agent agent in widget.selectedAgents) {
      subtotal += agent.hourlyPrice;
    }
    return subtotal;
  }

  double _calculateTotalPrice() {
    // Assuming a discount of 10%
    return _calculateSubtotal();
  }

  void _removeAgent(int index) {
    setState(() {
      widget.selectedAgents.removeAt(index);
    });
  }

  void _confirmAgentRemoval(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Removal',
            style: _customTextStyle.copyWith(
              color: Colors.orange,
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${widget.selectedAgents[index].name} from your basket?',
            style: _customTextStyle,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: _customTextStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _removeAgent(index);
                Navigator.of(context).pop();
              },
              child: Text(
                'Remove',
                style: _customTextStyle.copyWith(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Order',
            style: _customTextStyle.copyWith(
              color: Colors.orange,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to confirm this order?',
                  style: _customTextStyle,
                ),
                Text(
                  'Subtotal: \$${_calculateSubtotal().toStringAsFixed(2)}',
                  style: _customTextStyle,
                ),
                Text(
                  'Total Price (including 10% discount): \$${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: _customTextStyle,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: _customTextStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      orderID: 'your_order_id_here',
                      selectedAgents: [],
                    ), // Pass the orderID argument here
                  ),
                );
              },
              child: Text(
                'Confirm',
                style: _customTextStyle.copyWith(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('image/logo.png',
                height: 40), // Update with your logo asset
            SizedBox(width: 10),
            Text(
              'My Order',
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
      body: widget.selectedAgents.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.selectedAgents.length,
                    itemBuilder: (context, index) {
                      final agent = widget.selectedAgents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('image/ppp.jpg'),
                            ),
                            title: Text(
                              agent.name,
                              style: _customTextStyle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '\$${agent.hourlyPrice.toStringAsFixed(2)} (-\$${(agent.hourlyPrice * 0.1).toStringAsFixed(2)} Tax)',
                              style: _customTextStyle.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _confirmAgentRemoval(index);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: _customTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        leading: Icon(Icons.credit_card, color: Colors.blue),
                        title: Text(
                          'Visa Classic **** 1992',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Order Info',
                        style: _customTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal:',
                            style: _customTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_calculateSubtotal().toStringAsFixed(2)}',
                            style: _customTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: _customTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                            style: _customTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _showConfirmationDialog,
                          child: Text(
                            'payment',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'Your basket is empty!',
                style: _customTextStyle,
              ),
            ),
    );
  }
}
