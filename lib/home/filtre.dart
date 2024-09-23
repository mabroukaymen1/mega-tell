import 'package:flutter/material.dart';
import 'package:megatel/home/agent.dart';

class AgentFilterWidget extends StatefulWidget {
  final List<Agent> agents;
  final Function(List<Agent>) onFilterApplied;

  const AgentFilterWidget({
    Key? key,
    required this.agents,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  _AgentFilterWidgetState createState() => _AgentFilterWidgetState();
}

class _AgentFilterWidgetState extends State<AgentFilterWidget> {
  late List<Agent> _filteredAgents;
  List<String> _selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    _filteredAgents = List.from(widget.agents);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Text('Select languages:'),
            Wrap(
              spacing: 8.0,
              children: _buildLanguageChips(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Apply'),
          onPressed: () {
            _applyFilters();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  List<Widget> _buildLanguageChips() {
    List<String> languages = ['English', 'Spanish', 'French', 'German'];
    return languages.map((String language) {
      return ChoiceChip(
        label: Text(language),
        selected: _selectedLanguages.contains(language),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedLanguages.add(language);
            } else {
              _selectedLanguages.remove(language);
            }
          });
        },
      );
    }).toList();
  }

  void _applyFilters() {
    setState(() {
      _filteredAgents = widget.agents.where((agent) {
        bool matchesLanguage = _selectedLanguages.isEmpty ||
            agent.languages
                .any((language) => _selectedLanguages.contains(language));
        return matchesLanguage;
      }).toList();
    });
    widget.onFilterApplied(_filteredAgents);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Agent> _agents = [];

  @override
  void initState() {
    super.initState();
    _initializeAgents();
  }

  Future<void> _initializeAgents() async {
    try {
      List<Agent> agents = [
        Agent(
            name: 'Agent 1',
            photoAsset: AssetImage(defaultImage),
            languages: ['English', 'Spanish'],
            isAvailable: true,
            hourlyPrice: 20.0,
            isFavorite: false,
            rating: 4.5,
            reviews: []),
        Agent(
            name: 'Agent 2',
            photoAsset: AssetImage(defaultImage),
            languages: ['English', 'French'],
            isAvailable: false,
            hourlyPrice: 25.0,
            isFavorite: false,
            rating: 4.0,
            reviews: []),
        Agent(
            name: 'Agent 3',
            photoAsset: AssetImage(defaultImage),
            languages: ['English', 'Spanish'],
            isAvailable: true,
            hourlyPrice: 30.0,
            isFavorite: false,
            rating: 4.2,
            reviews: []),
        // Add other agents here
      ];
      setState(() {
        _agents = agents;
      });
    } catch (e) {
      print('Error initializing agents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showFilterDialog();
          },
          child: Text('Open Filter Dialog'),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AgentFilterWidget(
          agents: _agents,
          onFilterApplied: (filteredAgents) {
            // Handle filtered agents
          },
        );
      },
    );
  }
}

const String defaultImage = 'image/ppp.jpg';
