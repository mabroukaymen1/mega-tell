import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'agent.dart';

const String logoAssetPath = 'image/logo.png';
const String defaultAvatarAssetPath = 'image/ppp.png';
const String defaultAudioAssetPath = 'audio/welcom.mp3';

class AgentProfile extends StatefulWidget {
  final Agent agent;
  final Function(Agent) addToBasket;

  const AgentProfile({Key? key, required this.agent, required this.addToBasket})
      : super(key: key);

  @override
  _AgentProfileState createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _audioPlayerController;
  late Animation<double> _audioPlayerAnimation;

  late AudioPlayer audioPlayer;

  bool isPlaying = false;
  bool isAvailable = true; // Agent availability status

  List<Agent> selectedAgents = [];

  @override
  void initState() {
    super.initState();
    _audioPlayerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _audioPlayerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _audioPlayerController,
        curve: Curves.easeInOut,
      ),
    );
    audioPlayer = AudioPlayer();

    // Listen to audio player state changes
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
          _audioPlayerController.forward();
        });
      } else if (state == PlayerState.paused ||
          state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
          _audioPlayerController.reset();
        });
      }
    });
  }

  Future<void> _playAudio() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play(AssetSource(defaultAudioAssetPath));
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _addToBasket() {
    // Add the agent to the basket using the callback function
    widget.addToBasket(widget.agent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.agent.name} added to basket!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayerController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.agent.photoAsset != null
        ? (widget.agent.photoAsset as AssetImage).assetName
        : Agent.defaultPhotoUrl;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Row(
          children: [
            Image.asset(
              logoAssetPath,
              width: 32,
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Mega Tel',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(imageUrl),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: AgentDetailsView(
                        name: widget.agent.name,
                        price: widget.agent.hourlyPrice,
                        languages: widget.agent.languages,
                        isAvailable: isAvailable,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                AudioPlayerView(
                  onPlay: _playAudio,
                  isPlaying: isPlaying,
                  animation: _audioPlayerAnimation,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Column(
                  children: widget.agent.reviews.map((review) {
                    return ReviewView(
                      avatar: CircleAvatar(
                        backgroundImage: AssetImage(defaultAvatarAssetPath),
                      ),
                      title: review.title,
                      content: review.content,
                      rating: review.rating,
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.0),
                OutlinedButton(
                  onPressed: _addToBasket,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: BorderSide(color: Colors.orange),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AgentDetailsView extends StatelessWidget {
  final String name;
  final double price;
  final List<String> languages;
  final bool isAvailable;

  const AgentDetailsView({
    Key? key,
    required this.name,
    required this.price,
    required this.languages,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          '\$${price.toStringAsFixed(2)}/h',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          'Languages: ${languages.join(', ')}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5.0),
        Row(
          children: [
            Icon(
              isAvailable ? Icons.check_circle : Icons.cancel,
              color: isAvailable ? Colors.green : Colors.red,
              size: 18,
            ),
            SizedBox(width: 5.0),
            Text(
              isAvailable ? 'Available' : 'Not Available',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isAvailable ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AudioPlayerView extends StatelessWidget {
  final VoidCallback onPlay;
  final bool isPlaying;
  final Animation<double> animation;

  const AudioPlayerView({
    Key? key,
    required this.onPlay,
    required this.isPlaying,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hear me speak English!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5),
                    color: Colors.grey[400],
                  ),
                  child: FractionallySizedBox(
                    widthFactor: animation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: onPlay,
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: Center(
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewView extends StatelessWidget {
  final Widget avatar;
  final String title;
  final String content;
  final double rating;

  const ReviewView({
    Key? key,
    required this.avatar,
    required this.title,
    required this.content,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < rating.floor()
                          ? Icons.star
                          : index < rating
                              ? Icons.star_half
                              : Icons.star_border,
                      color: Colors.orange,
                      size: 16.0,
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
