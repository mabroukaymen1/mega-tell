import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _messageController;
  final List<ChatMessage> _chatMessages = [];
  bool _isTyping = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _userName = "aymen";
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) => _chatMessages[index],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _buildAppBarTitle(),
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

  Row _buildAppBarTitle() {
    return Row(
      children: [
        Image.asset(
          'image/logo.png',
          fit: BoxFit.cover,
          width: 40,
        ),
        const SizedBox(width: 8),
        Text(
          'Mega Tel',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Send Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (text) => _updateTypingStatus(text),
            ),
          ),
          _buildSendButton(),
        ],
      ),
    );
  }

  void _updateTypingStatus(String text) {
    setState(() {
      _isTyping = text.trim().isNotEmpty;
    });
  }

  IconButton _buildSendButton() {
    return IconButton(
      icon: Icon(Icons.send, color: _isTyping ? Colors.blue : Colors.grey),
      onPressed: _isTyping ? _sendMessage : null,
    );
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message to chat
    _addUserMessage(message);

    // Clear the message input
    _messageController.clear();
    _updateTypingStatus('');

    // Add bot response
    _addBotResponse(message);
  }

  void _addUserMessage(String message) {
    DateTime currentTime = DateTime.now();
    _chatMessages.insert(
      0,
      ChatMessage(
        key: UniqueKey(),
        text: message,
        isUserMessage: true,
        time: currentTime,
        userName: _userName!,
      ),
    );
    setState(() {});
  }

  void _addBotResponse(String message) {
    String normalizedMessage = message.toLowerCase().trim();
    String botResponse = BotResponses.getBotResponse(normalizedMessage);

    DateTime currentTime = DateTime.now();
    _chatMessages.insert(
      0,
      ChatMessage(
        key: UniqueKey(),
        text: botResponse,
        isUserMessage: false,
        time: currentTime,
        userName: "Bot",
      ),
    );
    setState(() {});
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final DateTime time;
  final String userName;

  const ChatMessage({
    required this.text,
    required this.isUserMessage,
    required this.time,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$userName: $text',
            style: TextStyle(
              color: isUserMessage ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            DateFormat.Hm().format(time),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color:
            isUserMessage ? Color.fromARGB(255, 247, 111, 0) : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
    );
  }
}

class BotResponses {
  static const Map<String, String> _responses = {
    'hello': 'Hi there! How can I assist you today?',
    'hi': 'Hello! How can I assist you today?',
    'how are you?': 'I\'m here to help you! How can I assist you today?',
    'what is your name?':
        'I am a virtual assistant programmed to help you. How can I assist you today?',
    'bye': 'Goodbye! Feel free to return if you have more questions.',
    'thanks':
        'You\'re welcome! If you need further assistance, feel free to ask.',
    'good morning': 'Good morning! How can I assist you today?',
    'good afternoon': 'Good afternoon! How can I assist you today?',
    'good evening': 'Good evening! How can I assist you today?',
    'what can you do?':
        'I can help you with any problems or questions you have. How can I assist you today?',
    'tell me a joke':
        'I\'m here to assist you with your inquiries. How can I help you today?',
    'how old are you?':
        'I am a virtual assistant designed to help you with your inquiries. How can I assist you today?',
    'do you like pizza?':
        'I am here to help you with your questions and problems. How can I assist you today?',
    'what is the meaning of life?':
        'I am programmed to provide assistance and support. How can I assist you today?',
    'tell me something interesting':
        'I am programmed to provide assistance to clients. How can I assist you today?',
    'i need help':
        'Of course! Please describe the issue you are facing, and I will do my best to assist you.',
    'my account is locked':
        'I understand. Please provide me with your account details, and I will help you unlock it.',
    'i forgot my password':
        'No problem! Please provide your username or email associated with the account, and I will assist you in resetting your password.',
    'i can\'t access my files':
        'Let\'s troubleshoot together. Can you provide more details about the issue you\'re experiencing with accessing your files?',
    'my payment is not going through':
        'I\'m here to help! Could you provide more details about the payment issue you\'re encountering?',
    'i\'m having trouble with the website':
        'I\'m sorry to hear that. Can you describe the specific problems you\'re encountering while using the website?',
    'i\'m getting an error message':
        'Let\'s tackle this issue together. Could you please provide the exact error message you\'re seeing?',
    'i need technical support':
        'Certainly! Please provide more details about the technical issue you\'re facing, and I\'ll assist you as best as I can.',
    'i want to cancel my subscription':
        'I understand. To proceed with canceling your subscription, please provide your account details so I can assist you further.',
  };

  static String getBotResponse(String message) {
    return _responses[message] ??
        'I am sorry, I did not understand that. How can I assist you today?';
  }
}
