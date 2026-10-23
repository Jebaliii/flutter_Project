import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:project_0/l10n/locale_controller.dart';
import 'package:project_0/main.dart';
import 'package:project_0/models/hotel.dart';
import 'package:project_0/theme/theme_controller.dart';
import 'package:project_0/widgets/animations.dart';

const _hotel = Hotel(
  id: 'h1',
  name: 'Test Hotel',
  city: 'Tunis',
  lat: 0,
  lng: 0,
  stars: 4,
  pricePerNight: 100,
);

Widget _app(Widget home) => MultiProvider(
  providers: [
    ChangeNotifierProvider.value(value: LocaleController(const Locale('fr'))),
    ChangeNotifierProvider.value(value: ThemeController()),
  ],
  child: MyApp(home: home),
);

void main() {
  test('The success Lottie file is a valid animation', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final bytes = await rootBundle.load('assets/lottie/success.json');
    final composition = await LottieComposition.fromByteData(bytes);
    expect(composition.layers, hasLength(3));
    expect(composition.duration, const Duration(milliseconds: 1500));
  });

  testWidgets('FadeSlideIn goes from transparent to visible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: FadeSlideIn(child: Text('hello'))),
    );
    AnimatedOpacity opacity() => tester.widget(find.byType(AnimatedOpacity));

    expect(opacity().opacity, 0);
    await tester.pumpAndSettle();
    expect(opacity().opacity, 1);
  });

  testWidgets('Hotel avatar flies with a Hero to the next screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Scaffold(
                    body: Center(child: HotelAvatar(hotel: _hotel, size: 120)),
                  ),
                ),
              ),
              child: const HotelAvatar(hotel: _hotel),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(HotelAvatar));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // Mid-flight, the flying badge is between the start (56) and end (120)
    // sizes.
    final badge = find
        .ancestor(
          of: find.byIcon(Icons.hotel).last,
          matching: find.byType(Container),
        )
        .first;
    final size = tester.getSize(badge);
    expect(size.width, greaterThan(56));
    expect(size.width, lessThan(120));

    await tester.pumpAndSettle();
    expect(find.byType(HotelAvatar), findsOneWidget);
  });

  testWidgets('Booking success dialog shows the Lottie animation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showBookingSuccessDialog(context, online: true),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(LottieBuilder), findsOneWidget);
    expect(find.text('Réservation enregistrée !'), findsOneWidget);
    await tester.tap(find.text('Voir mes réservations'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
