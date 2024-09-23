import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CardValidator {
  static bool isValidExpiryDate(String expiryDate) {
    if (expiryDate.isEmpty) {
      return false; // Return false if the expiryDate is empty
    }

    final parts = expiryDate.split('/');
    if (parts.length != 2) {
      return false; // Invalid format
    }

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null || month < 1 || month > 12) {
      return false; // Invalid month or year
    }

    final now = DateTime.now();
    final expiryDateTime = DateTime(
      now.year < 2000 ? now.year + 2000 : now.year,
      month,
      year, // No need to subtract 2000
    );

    return expiryDateTime.isAfter(now);
  }

  static bool isValidCardNumber(String cardNumber) {
    // Your card number validation logic
    return true;
  }

  static bool isValidCVV(String cvv, String cardType) {
    // Your CVV validation logic
    return true;
  }
}

class PaymentCardForm extends StatefulWidget {
  final PaymentCard? initialCard;

  PaymentCardForm({this.initialCard});

  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  final _formKey = GlobalKey<FormState>();
  final _ownerController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String? _cardType;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.initialCard != null) {
      _ownerController.text = widget.initialCard!.owner;
      _numberController.text = widget.initialCard!.number;
      _expiryController.text = widget.initialCard!.expiry;
      _cvvController.text = widget.initialCard!.cvv;
      _cardType = widget.initialCard!.type;
    }
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _saveCardDetailsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cardOwner', _ownerController.text);
    prefs.setString('cardNumber', _numberController.text);
    prefs.setString('cardExpiry', _expiryController.text);
    prefs.setString('cardCVV', _cvvController.text);
    prefs.setString('cardType', _cardType ?? '');

    _displayToastMessage("Card details saved successfully");
    // Navigate to success screen or perform any other action
  }

  void _displayToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _AppBarTitle(),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildCardTypeDropdown() {
    final cardTypes = ['Visa', 'Mastercard', 'American Express', 'Discover'];
    return DropdownButtonFormField<String>(
      value: _cardType,
      items: cardTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) => setState(() => _cardType = value),
      validator: (value) => value == null ? 'Select card type' : null,
      decoration: _buildInputDecoration('Card Type', Icons.credit_card),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _numberController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        MaskedInputFormatter('#### #### #### ####'),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter card number';
        }
        return CardValidator.isValidCardNumber(value)
            ? null
            : 'Invalid card number';
      },
      decoration:
          _buildInputDecoration('Card Number', Icons.credit_card_outlined),
    );
  }

  Widget _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryController,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
        MaskedInputFormatter('##/##'),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter expiry date';
        }
        if (!CardValidator.isValidExpiryDate(value)) {
          return 'Invalid expiry date';
        }
        return null;
      },
      decoration:
          _buildInputDecoration('Expiry Date (MM/YY)', Icons.calendar_today),
    );
  }

  Widget _buildCVVField() {
    return TextFormField(
      controller: _cvvController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      validator: (value) =>
          CardValidator.isValidCVV(value ?? '', _cardType ?? '')
              ? null
              : 'Invalid CVV',
      decoration: _buildInputDecoration('CVV', Icons.lock),
    );
  }

  Widget _buildOwnerField() {
    return TextFormField(
      controller: _ownerController,
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter owner name' : null,
      decoration: _buildInputDecoration('Card Owner', Icons.person),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveForm,
      child: Text(
        'Continue',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: _clearForm,
      child: Text(
        'Clear',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _clearForm() {
    _ownerController.clear();
    _numberController.clear();
    _expiryController.clear();
    _cvvController.clear();
    setState(() => _cardType = null);
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _saveCardDetailsLocally();
      setState(() {
        _showDetails = true;
      });
    } else {
      _displayToastMessage(
          'Form contains errors. Please correct and try again.');
    }
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            _buildOwnerField(),
            SizedBox(height: 20),
            _buildCardNumberField(),
            SizedBox(height: 20),
            _buildExpiryDateField(),
            SizedBox(height: 20),
            _buildCVVField(),
            SizedBox(height: 20),
            _buildCardTypeDropdown(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildClearButton(),
                _buildSaveButton(),
              ],
            ),
            SizedBox(height: 20),
            _showDetails
                ? CreditCardDisplay(
                    owner: _ownerController.text,
                    number: _numberController.text,
                    expiry: _expiryController.text,
                    cvv: _cvvController.text,
                    type: _cardType!,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Enter your payment details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'image/logo.png',
          fit: BoxFit.cover,
          width: 40,
        ),
        const SizedBox(width: 8),
        Text(
          'Payment Method',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class PaymentCard {
  final String owner;
  final String number;
  final String expiry;
  final String cvv;
  final String type;
  PaymentCard({
    required this.owner,
    required this.number,
    required this.expiry,
    required this.cvv,
    required this.type,
  });
}

class CreditCardDisplay extends StatelessWidget {
  final String owner;
  final String number;
  final String expiry;
  final String cvv;
  final String type;
  CreditCardDisplay({
    required this.owner,
    required this.number,
    required this.expiry,
    required this.cvv,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 128, 0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Type: $type',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Card Number: $number',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Expiry Date: $expiry',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'CVV: $cvv',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Card Owner: $owner',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
