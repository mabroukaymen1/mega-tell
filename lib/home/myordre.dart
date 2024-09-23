import 'package:flutter/material.dart';
import 'agent.dart'; // Ensure this imports the Agent model

class BasketScreen1 extends StatefulWidget {
  final List<Agent> selectedAgents;

  const BasketScreen1(
      {Key? key, required this.selectedAgents, required List<Agent> basket})
      : super(key: key);

  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen1> {
  @override
  Widget build(BuildContext context) {
    double subtotal =
        widget.selectedAgents.fold(0, (sum, agent) => sum + agent.hourlyPrice);
    double total = subtotal; // Adjust if there are any additional calculations

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedAgents.length,
              itemBuilder: (context, index) {
                final agent = widget.selectedAgents[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: agent.photoAsset,
                  ),
                  title: Text(agent.name),
                  subtitle: Text(
                      '\$${agent.hourlyPrice.toStringAsFixed(2)} (-\$4.00 Tax)'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        widget.selectedAgents.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Order Info',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                Text('Total: \$${total.toStringAsFixed(2)}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add order action
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Add to orders'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
