import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:megatel/home/home.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  LanguageScreen({required this.onLocaleChange});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Locale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.translate('language_screen_title') ??
              'Language Screen',
        ),
      ),
      body: FutureBuilder<List<LanguageOption>>(
        future: _getLanguages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading languages'));
          } else {
            List<LanguageOption>? languages = snapshot.data;
            return _buildLanguageList(context, languages!);
          }
        },
      ),
    );
  }

  Future<List<LanguageOption>> _getLanguages() async {
    return [
      LanguageOption(Locale('en', ''), 'image/languge/us.png', 'English'),
      LanguageOption(Locale('es', ''), 'image/languge/es.png', 'Español'),
      LanguageOption(Locale('fr', ''), 'image/languge/fr.png', 'Français'),
    ];
  }

  Widget _buildLanguageList(
      BuildContext context, List<LanguageOption> languages) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)?.translate('select_language') ??
                'Select your language',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return _buildLanguageOption(context, languages[index]);
              },
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _selectedLocale != null
                ? () async {
                    widget.onLocaleChange(_selectedLocale!);
                    await _setSelectedLanguage(_selectedLocale!);
                    AppLocalizations.of(context)?.reload(_selectedLocale!);
                    _navigateToNextPage(context);
                  }
                : null,
            child: Text('Next'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 247, 136, 0),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, LanguageOption languageOption) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(
          languageOption.imagePath,
          width: 30,
          height: 20,
        ),
        title: Text(
          languageOption.name,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedLocale = languageOption.locale;
          });
        },
        selected: _selectedLocale == languageOption.locale,
      ),
    );
  }

  void _navigateToNextPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  Future<void> _setSelectedLanguage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_locale', locale.languageCode);
    print('Selected Locale: ${locale.languageCode}');
  }
}

class LanguageOption {
  final Locale locale;
  final String imagePath;
  final String name;

  LanguageOption(this.locale, this.imagePath, this.name);
}

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String> _localizedStrings = {};

  Future<void> load(Locale locale) async {
    try {
      String jsonString =
          await rootBundle.loadString('languges/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      print(
          'Loaded Localized Strings for ${locale.languageCode}: $_localizedStrings');
    } catch (e) {
      print('Error loading localized strings: $e');
    }
  }

  Future<void> reload(Locale newLocale) async {
    await load(newLocale);
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations();
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
