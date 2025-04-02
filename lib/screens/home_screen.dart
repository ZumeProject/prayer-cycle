import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/language_selector.dart';
import '../widgets/prayer_timer.dart';

class HomeScreen extends StatelessWidget {
  final Function(Locale)? setLocale;

  const HomeScreen({super.key, this.setLocale});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final localizations = AppLocalizations.of(context);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.homeTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                tooltip: localizations.languageSelection,
                onPressed: () => LanguageSelector.show(context, setLocale),
              ),
            ],
          ),
          drawer: DrawerMenu(setLocale: setLocale),
          body: const PrayerTimer(),
        );
      },
    );
  }
} 