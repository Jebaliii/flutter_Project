import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'l10n/locale_controller.dart';
import 'services/ad_service.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'screens/admin/admin_shell.dart';
import 'screens/home/home_shell.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'widgets/animations.dart';
import 'widgets/app_feedback.dart';
import 'widgets/language_menu_button.dart';
import 'widgets/theme_toggle_button.dart';

/// Lets notification taps navigate without a BuildContext.
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (NotificationService.isSupported) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // Not awaited: ads and the notification permission dialog must never
  // delay app start-up.
  AdService.initialize();
  NotificationService.instance.init();

  final localeController = await LocaleController.load();
  final themeController = await ThemeController.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeController),
        ChangeNotifierProvider.value(value: themeController),
      ],
      child: const MyApp(),
    ),
  );

  NotificationService.instance.attach(_openFromNotification);
}

/// Opens the screen targeted by a tapped notification (`data.screen`).
void _openFromNotification(String screen) {
  final nav = navigatorKey.currentState;
  if (nav == null) {
    // App launched from a notification: wait for the first frame.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _openFromNotification(screen),
    );
    return;
  }
  // Bookings are per user: if logged out, the login page stays shown.
  if (FirebaseAuth.instance.currentUser == null) return;

  switch (screen) {
    case NotificationScreens.myBookings:
      // Home screen as the only route, on the "Mes Réservations" tab.
      homeTab.value = HomeTab.bookings;
      nav.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
  }
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, this.home = const LoginPage()});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleController>().locale;
    final themeMode = context.watch<ThemeController>().mode;

    // MaterialApp sets the text direction from the locale:
    // 'ar' => right-to-left, 'fr' / 'en' => left-to-right.
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appName,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: LocaleController.resolve,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: home,
    );
  }
}

// ===============================
// SHARED: Google button + divider
// ===============================

class GoogleSignInSection extends StatefulWidget {
  final AuthService authService;
  final Future<void> Function(User user) onSuccess;

  const GoogleSignInSection({
    super.key,
    required this.authService,
    required this.onSuccess,
  });

  @override
  State<GoogleSignInSection> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<GoogleSignInSection> {
  bool loading = false;

  Future<void> _signIn() async {
    setState(() => loading = true);
    try {
      final user = await widget.authService.signInWithGoogle();
      if (user != null) await widget.onSuccess(user);
      if (!mounted) return;
      setState(() => loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l.or,
                style: TextStyle(color: context.colors.onSurfaceVariant),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: loading ? null : _signIn,
            icon: loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: context.colors.outlineVariant),
                    ),
                    child: const Text(
                      'G',
                      style: TextStyle(
                        color: Color(0xFFDB4437),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
            label: Text(l.continueWithGoogle),
          ),
        ),
      ],
    );
  }
}

/// Opens the admin interface or the client app depending on the role
/// stored in `users/{uid}`.
Future<void> _enterApp(BuildContext context, User user) async {
  final profile = await AuthService().loadProfile(user);
  if (!context.mounted) return;
  homeTab.value = HomeTab.explore;
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) =>
          profile.isAdmin ? const AdminPage() : const HomePage(),
    ),
    (route) => false,
  );
}

Future<void> _logout(BuildContext context) async {
  try {
    await AuthService().logout();
  } catch (e) {
    debugPrint('Logout error: $e');
    if (context.mounted) context.showError(context.l10n.logoutError);
    return;
  }

  if (!context.mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (route) => false,
  );
}

// ===============================
// LOGIN PAGE
// ===============================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      context.showSnack(context.l10n.fillAllFields);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => loading = true);
    try {
      final user = await authService.login(email, password);
      if (!mounted) return;
      if (user != null) {
        await _enterApp(context, user);
      } else {
        context.showError(context.l10n.loginError);
      }
    } catch (e) {
      if (!mounted) return;
      context.showError(e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.loginTitle),
        actions: const [ThemeToggleButton(), LanguageMenuButton()],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FadeSlideIn(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    // Email addresses are always written left-to-right.
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: l.email,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l.password,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      child: loading ? const ButtonSpinner() : Text(l.signIn),
                    ),
                  ),
                  GoogleSignInSection(
                    authService: authService,
                    onSuccess: (user) => _enterApp(context, user),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(l.createAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================
// REGISTER PAGE
// ===============================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final adminCodeController = TextEditingController();
  final AuthService authService = AuthService();

  bool loading = false;
  bool asAdmin = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    adminCodeController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final adminCode = adminCodeController.text.trim();
    if (email.isEmpty || password.isEmpty || (asAdmin && adminCode.isEmpty)) {
      context.showSnack(context.l10n.fillAllFields);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => loading = true);
    try {
      final user = await authService.register(
        email,
        password,
        adminCode: asAdmin ? adminCode : null,
      );
      if (!mounted) return;
      if (user != null) {
        await _enterApp(context, user);
      } else {
        context.showError(context.l10n.registerError);
      }
    } catch (e) {
      if (!mounted) return;
      context.showError(e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.createAccount),
        actions: const [ThemeToggleButton(), LanguageMenuButton()],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FadeSlideIn(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    // Email addresses are always written left-to-right.
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: l.email,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l.password,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.admin_panel_settings),
                    title: Text(l.registerAsAdmin),
                    value: asAdmin,
                    onChanged: (v) => setState(() => asAdmin = v),
                  ),
                  // The admin code field only appears for admin sign-up.
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    child: asAdmin
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextField(
                              controller: adminCodeController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: l.adminCode,
                                prefixIcon: const Icon(Icons.key),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : register,
                      child: loading
                          ? const ButtonSpinner()
                          : Text(l.createAccountButton),
                    ),
                  ),
                  GoogleSignInSection(
                    authService: authService,
                    onSuccess: (user) => _enterApp(context, user),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================
// HOME PAGE (Drawer + BottomNavigationBar)
// ===============================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) =>
      HomeShell(onLogout: () => _logout(context));
}

// ===============================
// ADMIN PAGE (role 'admin')
// ===============================

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) => AdminShell(
    onLogout: () => _logout(context),
    onClientView: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    ),
  );
}
