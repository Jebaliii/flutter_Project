import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_controller.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../widgets/language_menu_button.dart';
import '../booking/my_bookings_screen.dart';
import 'hotels_map_screen.dart';

enum HomeTab { explore, bookings }

/// Selected bottom tab. Global so other screens (payment, notifications)
/// can send the user to a tab of the home screen.
final homeTab = ValueNotifier(HomeTab.explore);

/// Goes back to the home screen and selects [tab].
void showHomeTab(BuildContext context, HomeTab tab) {
  homeTab.value = tab;
  Navigator.of(context).popUntil((route) => route.isFirst);
}

/// Home screen: Drawer + BottomNavigationBar around the main tabs.
class HomeShell extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeShell({super.key, required this.onLogout});

  /// Opens the drawer of the enclosing [HomeShell] (tabs have their own
  /// Scaffold, so `Scaffold.of` would find the wrong one).
  static void openDrawer(BuildContext context) => context
      .findAncestorStateOfType<_HomeShellState>()
      ?._scaffoldKey
      .currentState
      ?.openDrawer();

  /// Whether [context] is inside a [HomeShell] (menu button shown or not).
  static bool isIn(BuildContext context) =>
      context.findAncestorStateOfType<_HomeShellState>() != null;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ValueListenableBuilder<HomeTab>(
      valueListenable: homeTab,
      builder: (context, tab, _) => Scaffold(
        key: _scaffoldKey,
        drawer: _AppDrawer(
          current: tab,
          onSelect: (t) => homeTab.value = t,
          onLogout: widget.onLogout,
        ),
        // Both tabs stay alive (map position, filters, Firestore stream).
        body: IndexedStack(
          index: tab.index,
          children: [
            for (final t in HomeTab.values)
              // Hidden tabs must not take part in Hero animations.
              HeroMode(
                enabled: t == tab,
                child: switch (t) {
                  HomeTab.explore => const HotelsMapScreen(),
                  HomeTab.bookings => const MyBookingsScreen(),
                },
              ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The navigation bar below already handles the bottom inset.
            MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: const BannerAdWidget(),
            ),
            BottomNavigationBar(
              currentIndex: tab.index,
              onTap: (i) => homeTab.value = HomeTab.values[i],
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.explore_outlined),
                  activeIcon: const Icon(Icons.explore),
                  label: l.navExplore,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.book_online_outlined),
                  activeIcon: const Icon(Icons.book_online),
                  label: l.myBookings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// App bar button opening the [HomeShell] drawer.
class MenuButton extends StatelessWidget {
  final Color? color;

  const MenuButton({super.key, this.color});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: Icon(Icons.menu, color: color),
    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    onPressed: () => HomeShell.openDrawer(context),
  );
}

class _AppDrawer extends StatelessWidget {
  final HomeTab current;
  final ValueChanged<HomeTab> onSelect;
  final VoidCallback onLogout;

  const _AppDrawer({
    required this.current,
    required this.onSelect,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    // Close the drawer first, then run the action.
    void select(HomeTab t) {
      Navigator.pop(context);
      onSelect(t);
    }

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                email.isEmpty ? '?' : email[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ),
            accountName: Text(
              l.appName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // Email addresses are always written left-to-right.
            accountEmail: Text(email, textDirection: TextDirection.ltr),
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: Text(l.navExplore),
            selected: current == HomeTab.explore,
            onTap: () => select(HomeTab.explore),
          ),
          ListTile(
            leading: const Icon(Icons.book_online),
            title: Text(l.myBookings),
            selected: current == HomeTab.bookings,
            onTap: () => select(HomeTab.bookings),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: Text(l.darkTheme),
            value: context.isDark,
            onChanged: (_) => context.read<ThemeController>().toggle(
              Theme.of(context).brightness,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            trailing: const LanguageMenuButton(),
          ),
          const Spacer(),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: ListTile(
              leading: Icon(Icons.logout, color: context.colors.error),
              title: Text(
                l.logout,
                style: TextStyle(color: context.colors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
