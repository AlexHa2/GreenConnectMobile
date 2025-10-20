// lib/features/settings/presentation/settings_page.dart
import 'package:GreenConnectMobile/features/settings/presentation/providers/settings_notifier.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settings.isDarkMode,
            onChanged: (_) => notifier.toggleTheme(),
          ),
          ListTile(
            title: Text(S.of(context)!.hello_first),
            trailing: DropdownButton<String>(
              value: settings.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
              ],
              onChanged: (value) {
                if (value != null) notifier.changeLanguage(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
