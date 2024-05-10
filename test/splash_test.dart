import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangaland_flutter/page/splash/splash_page.dart';

void main() {
  testWidgets('Splash Page displays logo', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SplashPage(),
    ));

    expect(find.byType(Image), findsOneWidget);
  });
}
