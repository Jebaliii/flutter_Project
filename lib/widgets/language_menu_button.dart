import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../l10n/locale_controller.dart';

/// App bar button that lets the user switch between FR / EN / AR.
class LanguageMenuButton extends StatelessWidget {
  final Color? color;

  const LanguageMenuButton({super.key, this.color});

  // Each language is shown in its own script.
  static const _languages = <(String, String)>[
    ('fr', 'Français'),
    ('en', 'English'),
    ('ar', 'العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;

    return PopupMenuButton<String>(
      tooltip: context.l10n.language,
      icon: Icon(Icons.language, color: color),
      initialValue: current,
      onSelected: (code) =>
          context.read<LocaleController>().setLocale(Locale(code)),
      itemBuilder: (_) => [
        for (final (code, name) in _languages)
          PopupMenuItem(
            value: code,
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: code == current
                      ? const Icon(Icons.check, size: 18)
                      : null,
                ),
                Text(name),
              ],
            ),
          ),
      ],
    );
  }
}
