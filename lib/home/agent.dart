import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Map<String, String> languageFlags = {
  'English': 'image/flags/gb.svg',
  'Spanish': 'image/flags/es.svg',
  'French': 'image/flags/fr.svg',
  // Add more language flags as needed
};

class Review {
  final String title;
  final String content;
  final double rating;

  Review({
    required this.title,
    required this.content,
    required this.rating,
  });
}

class Agent {
  final String name;
  final AssetImage? photoAsset;
  final List<String> languages;
  final bool isAvailable;
  final double hourlyPrice;
  bool isFavorite;
  final double rating;
  final List<Review> reviews;
  bool isSelected;
  String highlightedName;
  List<String> highlightedLanguages;
  static const String defaultPhotoUrl =
      'https://i.pinimg.com/736x/0d/64/98/0d64989794b1a4c9d89bff571d3d5842.jpg';

  Agent({
    required this.name,
    this.photoAsset,
    required this.languages,
    required this.isAvailable,
    required this.hourlyPrice,
    required this.reviews,
    this.isFavorite = false,
    this.rating = 0.0,
    this.isSelected = false,
    this.highlightedName = '',
    this.highlightedLanguages = const [],
  });

  // Function to generate random reviews
  static List<Review> generateRandomReviews() {
    final random = Random();
    final reviews = List<Review>.generate(
      random.nextInt(5) + 1, // Generate 1 to 5 reviews
      (index) => Review(
        title: 'Review ${index + 1}',
        content: 'This agent is great!',
        rating: (random.nextDouble() * 5)
            .roundToDouble(), // Random rating between 0.0 and 5.0
      ),
    );
    return reviews;
  }
}

class AgentTile extends StatefulWidget {
  final Agent agent;
  final Function(Agent) onToggleFavorite;
  final Function(Agent) onAddToBasket;
  final Function(Agent) onRemoveFromBasket;
  final Function() onTap;

  const AgentTile({
    Key? key,
    required this.agent,
    required this.onToggleFavorite,
    required this.onAddToBasket,
    required this.onRemoveFromBasket,
    required this.onTap,
    required double agentTileHeight,
    required ScrollController scrollController,
  }) : super(key: key);

  @override
  _AgentTileState createState() => _AgentTileState();
}

class _AgentTileState extends State<AgentTile> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _resetScrollPosition();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAgentImage(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAgentNameAndRating(),
                    const SizedBox(height: 8),
                    _buildLanguageFlags(),
                    const SizedBox(height: 12),
                    _buildHourlyPriceAndCartIcon(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build agent image
  Widget _buildAgentImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: widget.agent.photoAsset != null
              ? Image(
                  image: widget.agent.photoAsset!,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                )
              : Image.network(
                  Agent.defaultPhotoUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              widget.agent.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.agent.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              widget.onToggleFavorite(widget.agent);
            },
          ),
        ),
      ],
    );
  }

  // Function to build agent name and rating
  Widget _buildAgentNameAndRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.agent.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              widget.agent.rating.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // Function to build language flags
  Widget _buildLanguageFlags() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: widget.agent.languages.map((language) {
        final flagAsset = languageFlags[language];
        if (flagAsset != null) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                flagAsset,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 4),
              Text(language),
            ],
          );
        } else {
          return const SizedBox();
        }
      }).toList(),
    );
  }

  // Function to build hourly price and cart icon
  Widget _buildHourlyPriceAndCartIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${widget.agent.hourlyPrice.toStringAsFixed(2)} / hour',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            Icons.add_shopping_cart,
            color: widget.agent.isSelected ? Colors.green : Colors.black,
          ),
          onPressed: () {
            setState(() {
              widget.agent.isSelected = !widget.agent.isSelected;
            });
            if (widget.agent.isSelected) {
              widget.onAddToBasket(widget.agent);
            } else {
              widget.onRemoveFromBasket(widget.agent);
            }
          },
        ),
      ],
    );
  }

  // Function to reset scroll position
  void _resetScrollPosition() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
