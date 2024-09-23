import 'package:flutter/material.dart';
import 'agent.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Agent> favoriteAgents;
  final Function(Agent) onRemoveFavorite;

  const FavoriteScreen({
    Key? key,
    required this.favoriteAgents,
    required this.onRemoveFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteAgents.length,
        itemBuilder: (context, index) {
          final agent = favoriteAgents[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: agent.photoAsset,
            ),
            title: Text(agent.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onRemoveFavorite(agent);
              },
            ),
          );
        },
      ),
    );
  }
}
