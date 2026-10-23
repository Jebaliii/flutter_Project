import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_0/l10n/l10n.dart';
import 'package:project_0/l10n/locale_controller.dart';
import 'package:project_0/main.dart';
import 'package:project_0/services/app_exception.dart';
import 'package:project_0/theme/theme_controller.dart';
import 'package:project_0/widgets/app_feedback.dart';
import 'package:project_0/widgets/theme_toggle_button.dart';

/// Minimal page (no Firebase) showing a translated text + text direction.
class _Probe extends StatelessWidget {
  const _Probe();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        Text(context.l10n.bookThisHotel),
        Text(context.l10n.nightsCount(3)),
        Text('dir:${Directionality.of(context).name}'),
        Text('theme:${Theme.of(context).brightness.name}'),
        const ThemeToggleButton(),
      ],
    ),
  );
}

Future<LocaleController> _pump(
  WidgetTester tester, [
  Locale? locale,
  ThemeController? theme,
]) async {
  final controller = LocaleController(locale);
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: controller),
        ChangeNotifierProvider.value(value: theme ?? ThemeController()),
      ],
      child: const MyApp(home: _Probe()),
    ),
  );
  await tester.pumpAndSettle();
  return controller;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('French, left-to-right', (tester) async {
    await _pump(tester, const Locale('fr'));
    expect(find.text('Réserver cet hôtel'), findsOneWidget);
    expect(find.text('3 nuits'), findsOneWidget);
    expect(find.text('dir:ltr'), findsOneWidget);
  });

  testWidgets('English, left-to-right', (tester) async {
    await _pump(tester, const Locale('en'));
    expect(find.text('Book this hotel'), findsOneWidget);
    expect(find.text('3 nights'), findsOneWidget);
    expect(find.text('dir:ltr'), findsOneWidget);
  });

  testWidgets('Switching to Arabic turns the app right-to-left and is saved', (
    tester,
  ) async {
    final controller = await _pump(tester, const Locale('fr'));

    await controller.setLocale(const Locale('ar'));
    await tester.pumpAndSettle();

    expect(find.text('احجز هذا الفندق'), findsOneWidget);
    expect(find.text('3 ليالٍ'), findsOneWidget);
    expect(find.text('dir:rtl'), findsOneWidget);

    final reloaded = await LocaleController.load();
    expect(reloaded.locale, const Locale('ar'));
  });

  test('Unsupported device language falls back to French', () {
    expect(
      LocaleController.resolve(
        const Locale('de'),
        AppLocalizations.supportedLocales,
      ),
      const Locale('fr'),
    );
  });

  testWidgets('Theme button switches light <-> dark and the choice is saved', (
    tester,
  ) async {
    await _pump(tester, const Locale('fr'), ThemeController(ThemeMode.light));
    expect(find.text('theme:light'), findsOneWidget);

    await tester.tap(find.byType(ThemeToggleButton));
    await tester.pumpAndSettle();
    expect(find.text('theme:dark'), findsOneWidget);
    expect((await ThemeController.load()).mode, ThemeMode.dark);

    await tester.tap(find.byType(ThemeToggleButton));
    await tester.pumpAndSettle();
    expect(find.text('theme:light'), findsOneWidget);
    expect((await ThemeController.load()).mode, ThemeMode.light);
  });

  test('Without a saved choice the theme follows the device', () async {
    expect((await ThemeController.load()).mode, ThemeMode.system);
  });

  testWidgets('Firebase error codes become translated messages',
      (tester) async {
    await _pump(tester, const Locale('fr'));
    final l = AppLocalizations.of(tester.element(find.byType(_Probe)));

    expect(localizeError(l, AppException.fromFirebaseCode('invalid-credential')),
        'E-mail ou mot de passe incorrect');
    expect(localizeError(l, AppException.fromFirebaseCode('email-already-in-use')),
        'Cet e-mail est déjà utilisé par un autre compte');
    expect(localizeError(l, AppException.fromFirebaseCode('network-request-failed')),
        startsWith('Pas de connexion Internet'));
    // Unknown errors never leak technical text.
    expect(localizeError(l, StateError('boom')), l.errorUnknown);
  });

  testWidgets('Error SnackBar shows the translated message', (tester) async {
    await _pump(tester, const Locale('en'));
    tester
        .element(find.byType(_Probe))
        .showError(const AppException(AppErrorCode.weakPassword));
    await tester.pump();
    expect(find.text('Password too weak (at least 6 characters)'),
        findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('Error state shows a Retry button that calls back',
      (tester) async {
    var retried = 0;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: LocaleController(const Locale('fr'))),
          ChangeNotifierProvider.value(value: ThemeController()),
        ],
        child: MyApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => StateMessage.error(
                context,
                error: const AppException(AppErrorCode.network),
                onRetry: () => retried++,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Erreur de chargement'), findsOneWidget);
    await tester.tap(find.text('Réessayer'));
    expect(retried, 1);
  });
}
