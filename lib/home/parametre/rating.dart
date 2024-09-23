import 'package:flutter/material.dart';

class RatingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text header
            Text(
              'Rate Flashcards App',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),

            // Star rating bar
            StarRatingBar(),

            SizedBox(height: 32.0),

            // Text body
            Text(
              'Tap a star to give your rating.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),

            // Rating explanation (optional)
            /*
            Text(
              'Your feedback helps us improve the app for you and others.',
              textAlign: TextAlign.center,
            ),
            */

            // Button row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel button
                TextButton(
                  onPressed: () {
                    // Handle cancel button press
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16.0),

                // Submit button
                ElevatedButton(
                  onPressed: () {
                    // Handle submit button press
                    // Potentially navigate to a different screen or store rating
                    _showConfirmationDialog(context);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Rating"),
          content: Text("Are you sure you want to submit this rating?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle submit action
                _submitRating();
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _submitRating() {
    // Implement logic to submit rating
    // This could involve sending the rating to a server or storing it locally
    // You can also trigger specific actions based on the rating given
  }
}

class StarRatingBar extends StatefulWidget {
  @override
  _StarRatingBarState createState() => _StarRatingBarState();
}

class _StarRatingBarState extends State<StarRatingBar> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
          },
          tooltip:
              "${index + 1} Star Rating", // Add semantic label for accessibility
        );
      }),
    );
  }
}
