import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_0/l10n/l10n.dart';
import 'package:project_0/l10n/locale_controller.dart';
import 'package:project_0/main.dart';

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
          ],
        ),
      );
}

Future<LocaleController> _pump(WidgetTester tester, [Locale? locale]) async {
  final controller = LocaleController(locale);
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: controller,
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

  testWidgets('Switching to Arabic turns the app right-to-left and is saved',
      (tester) async {
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
          const Locale('de'), AppLocalizations.supportedLocales),
      const Locale('fr'),
    );
  });
}
