import 'package:flutter/material.dart';

import 'package:megatel/home/agent.dart';
import 'package:megatel/home/basket.dart';
import 'package:megatel/home/buttom.dart';
import 'package:megatel/home/chat.dart';
import 'package:megatel/home/filtre.dart';
import 'package:megatel/home/myordre.dart';
import 'package:megatel/home/notif.dart';
import 'package:megatel/home/order.dart';
import 'package:megatel/home/parametre/privcy.dart';
import 'package:megatel/home/parametre/setting.dart';
import 'package:megatel/home/profile.dart';
import 'package:megatel/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'favrorite.dart';

const String logoImage = 'image/logo.png';
const String defaultImage = 'image/ppp.jpg';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Agent> _agents = [];
  final List<Agent> _basket = [];
  final List<Agent> _favoriteAgents = [];
  String _userName = '';
  String _userEmail = '';
  late AnimationController _controller;
  List<Agent> _filteredAgents = [];
  bool _hasNotifications = true;
  double _minPrice = 0.0;
  bool _isDarkModeEnabled = false;
  bool _isSearching = false;
  late TextEditingController _searchController;
  int _selectedIndex = 0;
  late ThemeData _theme;
  ScrollController _scrollController = ScrollController();
  double _agentTileHeight = 100.0;
  List<String> _selectedLanguages = [];
  late Map<String, dynamic> _localizedStrings = {};

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
    _searchController = TextEditingController();
    _initializeTheme();
    _loadLocalizedStrings();
    _getUserData();
    _initializeAgents();
  }

  Future<void> _loadLocalizedStrings() async {
    try {
      String jsonString = await rootBundle.loadString(
          'languges/${Localizations.localeOf(context).languageCode}.json');
      setState(() {
        _localizedStrings = json.decode(jsonString);
      });
    } catch (e) {
      print('Error loading localized strings: $e');
    }
  }

  Future<void> _getUserData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.56.1:3000/'));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _userName = userData['name'] ?? '';
          _userEmail = userData['email'] ?? '';
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
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
        _filteredAgents = agents;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

      if (!hasSeenWelcome) {
        await _showWelcomeNotification();
        await prefs.setBool('hasSeenWelcome', true);
      }
    } catch (e) {
      print('Error initializing agents: $e');
    }
  }

  Future<void> _showWelcomeNotification() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Welcome to Mega Tel!'),
        content: Text(
            'Thank you for joining us. Start exploring agents and enjoy our services!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _initializeAnimationController() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _initializeTheme() {
    _theme = ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.white,
        secondary: Colors.orange,
        error: Colors.red,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            logoImage,
            fit: BoxFit.cover,
            width: 40,
          ),
          const SizedBox(width: 8),
          Text(
            _localizedStrings['mega_tel'] ?? 'Mega Tel',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      centerTitle: false,
      backgroundColor: Color(0xFFF5F5F5),
      elevation: 0,
      actions: [
        IconButton(
          icon: _isSearching
              ? Icon(Icons.cancel, color: Colors.black)
              : Icon(Icons.search, color: Colors.black),
          onPressed: _toggleSearch,
        ),
        Stack(
          children: [
            IconButton(
              icon: _hasNotifications
                  ? AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _controller,
                    )
                  : (Icon(Icons.notifications, color: Colors.black)),
              onPressed: () {
                if (_hasNotifications) {
                  _showFilterDialog();
                } else {
                  _navigateToNotificationHistory(); // Navigate to Notification History Screen
                }
              },
            ),
            Positioned(
              right: -2,
              top: -2,
              child: _hasNotifications
                  ? Icon(Icons.brightness_1, size: 8.0, color: Colors.red)
                  : Container(),
            )
          ],
        )
      ],
      bottom: _isSearching
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for agent',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: _filterSearchResults,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Home',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.black),
                onPressed: _showFilterDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredAgents.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final agent = _filteredAgents[index];

              return GestureDetector(
                onTap: () => _navigateToAgentProfile(context, agent),
                child: AgentTile(
                  agent: agent,
                  agentTileHeight: _agentTileHeight,
                  scrollController: _scrollController,
                  onToggleFavorite: _toggleFavorite,
                  onAddToBasket: _addToBasket,
                  onRemoveFromBasket: _removeFromBasket,
                  onTap: () => _navigateToAgentProfile(
                      context, agent), // Navigate to profile on tap
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.orange,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(Icons.home),
          ),
          label: _localizedStrings['home'] ?? 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(Icons.shopping_basket),
          ),
          label: _localizedStrings['my_order'] ?? 'My Order',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(Icons.favorite),
          ),
          label: _localizedStrings['favorite'] ?? 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(Icons.person),
          ),
          label: _localizedStrings['profile'] ?? 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BasketScreen1(
            basket: _basket,
            selectedAgents: _agents.where((agent) => agent.isSelected).toList(),
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoriteScreen(
            favoriteAgents: _favoriteAgents,
            onRemoveFavorite: _toggleFavorite,
          ),
        ),
      );
    } else {
      setState(() {
        _filteredAgents = List.from(_agents);
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterSearchResults('');
      }
    });
  }

  void _filterSearchResults(String query) {
    final String lowercaseQuery = query.toLowerCase();

    setState(() {
      _filteredAgents = _agents.where((agent) {
        final String lowercaseName = agent.name.toLowerCase();
        final bool matchesName = lowercaseName.contains(lowercaseQuery);
        final bool matchesLanguage = agent.languages
            .any((language) => language.toLowerCase().contains(lowercaseQuery));
        if (matchesName || matchesLanguage) {
          agent.highlightedName =
              _applyTextHighlighting(agent.name, lowercaseQuery);
          agent.highlightedLanguages = agent.languages
              .map((language) =>
                  _applyTextHighlighting(language, lowercaseQuery))
              .toList();
        } else {
          agent.highlightedName = agent.name;
          agent.highlightedLanguages = agent.languages;
        }
        return matchesName || matchesLanguage;
      }).toList();
    });
  }

  String _applyTextHighlighting(String text, String query) {
    if (query.isEmpty) return text;

    List<String> parts = text.split(RegExp('($query)', caseSensitive: false));

    List<TextSpan> spans = parts.map<TextSpan>((part) {
      if (part.toLowerCase() == query) {
        return TextSpan(
          text: part,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return TextSpan(text: part);
      }
    }).toList();

    return RichText(
      text: TextSpan(children: spans),
    ).toString();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AgentFilterWidget(
          agents: _agents,
          onFilterApplied: (filteredAgents) {
            setState(() {
              _filteredAgents = filteredAgents;
            });
          },
        );
      },
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
      _filteredAgents = _agents.where((agent) {
        bool matchesLanguage = _selectedLanguages.isEmpty ||
            agent.languages
                .any((language) => _selectedLanguages.contains(language));
        bool matchesPrice = agent.hourlyPrice >= _minPrice;
        return matchesLanguage && matchesPrice;
      }).toList();
    });
  }

  void _toggleFavorite(Agent agent) {
    setState(() {
      agent.isFavorite = !agent.isFavorite;
      if (agent.isFavorite) {
        _favoriteAgents.add(agent);
      } else {
        _favoriteAgents.remove(agent);
      }
    });
  }

  void _toggleBasket(Agent agent) {
    setState(() {
      if (!_basket.contains(agent)) {
        _basket.add(agent);
        agent.isSelected = true;
      } else {
        _basket.remove(agent);
        agent.isSelected = false;
      }
    });
  }

  void _addToBasket(Agent agent) {
    _toggleBasket(agent);
  }

  void _removeFromBasket(Agent agent) {
    _toggleBasket(agent);
  }

  void _navigateToNotificationHistory() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationHistoryScreen()),
      );
    } catch (e) {
      print("Navigation Error: $e");
    }
  }

  void _navigateToAgentProfile(BuildContext context, Agent agent) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgentProfile(
            agent: agent,
            addToBasket: (Agent) {},
          ),
        ),
      );
    } catch (e) {
      print("Navigation Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error navigating to agent profile')),
      );
    }
  }

  Widget _buildDrawer() {
    int numberOfAgentsChosen = _basket.length;

    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(defaultImage),
            ),
            accountName: Text(
              'Aymen Mabrouk',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              'aymenmabrouk803@gmail.com',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            otherAccountsPictures: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ListTile(
                    leading:
                        Icon(Icons.logout, color: Colors.red.withOpacity(0.8)),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red.withOpacity(0.8)),
                    ),
                    onTap: _logout,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text('Dark Mode'),
                  trailing: Switch(
                    value: _isDarkModeEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _isDarkModeEnabled = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text('My Basket'),
                  subtitle: Text(
                    '$numberOfAgentsChosen agents chosen',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  onTap: _navigateToBasket,
                ),
                _buildDrawerItem(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: _navigateToPrivacyPolicy,
                ),
                _buildDrawerItem(
                  icon: Icons.receipt_long,
                  title: 'Order History',
                  onTap: _navigateToOrders,
                ),
                _buildDrawerItem(
                  icon: Icons.credit_card,
                  title: 'Payment Methods',
                  onTap: _navigateToMyCards,
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: _navigateToSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _navigateToBasket() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BasketScreen(
            selectedAgents: _basket,
            basket: [],
          ),
        ),
      );
    } catch (e) {
      print("Navigation Error: $e");
    }
  }

  void _navigateToProfile(Agent agent) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgentProfile(
            agent: agent,
            addToBasket: (Agent) {},
          ),
        ),
      );
    } catch (e) {
      print("Navigation Error: $e");
    }
  }

  void _navigateToSettings() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParameterScreen(theme: _theme),
        ),
      );
    } catch (e) {
      print("Navigation Error: $e");
    }
  }

  void _logout() {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print("Navigation Error: $e");
    }
  }

  void _navigateToPrivacyPolicy() {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
      );
    } catch (e) {
      print("Navigation Error: $e");
    } // Implement navigation logic
  }

  void _navigateToOrders() {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
      );
    } catch (e) {
      print("Navigation Error: $e");
    } // Implement navigation logic
  }

  void _navigateToMyCards() {
    // Implement navigation logic
  }

  @override
  Widget build(BuildContext context) {
    _theme = _isDarkModeEnabled
        ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.grey[900]!,
              secondary: Colors.orange,
              error: Colors.red,
            ),
            textTheme: ThemeData.dark().textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
          )
        : ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              secondary: Colors.orange,
              error: Colors.red,
            ),
            textTheme: ThemeData.light().textTheme.apply(
                  bodyColor: Colors.black,
                  displayColor: Colors.black,
                ),
          );

    return Theme(
      data: _theme,
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(),
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNavigationBar(
          onItemTapped: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          backgroundColor: Colors.orange,
          child: Icon(Icons.chat_bubble),
        ),
      ),
    );
  }
}
