import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_controller.dart';
import '../../widgets/language_menu_button.dart';
import '../../widgets/theme_toggle_button.dart';
import 'admin_bookings_tab.dart';
import 'admin_dashboard_tab.dart';
import 'admin_hotels_tab.dart';
import 'admin_users_tab.dart';
import 'hotel_form_screen.dart';

enum AdminTab { dashboard, bookings, hotels, users }

/// Admin interface: manages bookings, hotels and users.
class AdminShell extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onClientView;

  const AdminShell({
    super.key,
    required this.onLogout,
    required this.onClientView,
  });

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  AdminTab _tab = AdminTab.dashboard;

  void _select(AdminTab tab) => setState(() => _tab = tab);

  String _title(AdminTab t) {
    final l = context.l10n;
    return switch (t) {
      AdminTab.dashboard => l.adminDashboard,
      AdminTab.bookings => l.adminBookings,
      AdminTab.hotels => l.adminHotels,
      AdminTab.users => l.adminUsers,
    };
  }

  IconData _icon(AdminTab t) => switch (t) {
    AdminTab.dashboard => Icons.dashboard,
    AdminTab.bookings => Icons.book_online,
    AdminTab.hotels => Icons.hotel,
    AdminTab.users => Icons.people,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title(_tab)),
        actions: const [ThemeToggleButton(), LanguageMenuButton()],
      ),
      drawer: _AdminDrawer(
        current: _tab,
        title: _title,
        icon: _icon,
        onSelect: _select,
        onClientView: widget.onClientView,
        onLogout: widget.onLogout,
      ),
      // Tabs stay alive so their Firestore streams and filters are kept.
      body: IndexedStack(
        index: _tab.index,
        children: [
          AdminDashboardTab(onOpen: _select),
          const AdminBookingsTab(),
          const AdminHotelsTab(),
          const AdminUsersTab(),
        ],
      ),
      floatingActionButton: _tab == AdminTab.hotels
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: Text(l.addHotel),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HotelFormScreen()),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        // 4 items: keep the labels and a fixed layout.
        type: BottomNavigationBarType.fixed,
        currentIndex: _tab.index,
        onTap: (i) => _select(AdminTab.values[i]),
        items: [
          for (final t in AdminTab.values)
            BottomNavigationBarItem(icon: Icon(_icon(t)), label: _title(t)),
        ],
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  final AdminTab current;
  final String Function(AdminTab) title;
  final IconData Function(AdminTab) icon;
  final ValueChanged<AdminTab> onSelect;
  final VoidCallback onClientView;
  final VoidCallback onLogout;

  const _AdminDrawer({
    required this.current,
    required this.title,
    required this.icon,
    required this.onSelect,
    required this.onClientView,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    // Close the drawer first, then run the action.
    void close(VoidCallback action) {
      Navigator.pop(context);
      action();
    }

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF212529), Color(0xFF495057)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                size: 36,
                color: Color(0xFF212529),
              ),
            ),
            accountName: Text(
              '${l.appName} · ${l.adminTitle}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // Email addresses are always written left-to-right.
            accountEmail: Text(email, textDirection: TextDirection.ltr),
          ),
          for (final t in AdminTab.values)
            ListTile(
              leading: Icon(icon(t)),
              title: Text(title(t)),
              selected: current == t,
              onTap: () => close(() => onSelect(t)),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: Text(l.clientView),
            onTap: () => close(onClientView),
          ),
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
              onTap: () => close(onLogout),
            ),
          ),
        ],
      ),
    );
  }
}
