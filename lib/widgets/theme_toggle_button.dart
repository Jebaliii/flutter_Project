import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';

/// App bar button that switches between the light and dark theme.
class ThemeToggleButton extends StatelessWidget {
  final Color? color;

  const ThemeToggleButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    return IconButton(
      // Shows the theme you will switch to.
      icon: Icon(dark ? Icons.light_mode : Icons.dark_mode, color: color),
      tooltip: dark ? context.l10n.lightTheme : context.l10n.darkTheme,
      onPressed: () =>
          context.read<ThemeController>().toggle(Theme.of(context).brightness),
    );
  }
}
