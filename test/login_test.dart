import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangaland_flutter/page/login/login_page.dart';
import 'package:mangaland_flutter/page/login/login_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Login Page UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    ));
    expect(find.byType(Image), findsOneWidget);

    expect(find.text('Username'), findsOneWidget);
    expect(find.byKey(const Key('Username')), findsOneWidget);

    expect(find.text('Password'), findsOneWidget);
    expect(find.byKey(const Key('Password')), findsOneWidget);

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Login with empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    ));
    await tester.pump();

    await tester.tap(find.text("Login"));
    await tester.pump();

    expect(find.text('Username cannot be empty'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsOneWidget);
  });
  testWidgets('Login at least 6 characters', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    ));
    await tester.pump();

    await tester.enterText(find.byKey(Key("Username")), 'dafa');
    await tester.enterText(find.byKey(Key("Password")), 'dafa');

    await tester.tap(find.text("Login"));
    await tester.pump();

    expect(find.text('Username must be at least 6 characters long'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters long'), findsOneWidget);
  });
}
