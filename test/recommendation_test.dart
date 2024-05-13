import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangaland_flutter/env/env.dart';
import 'package:mangaland_flutter/page/recommendation/recommend_page.dart';
import 'package:mangaland_flutter/page/recommendation/recommendation_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('RecommendationPage UI Test', (WidgetTester tester) async {
    Gemini.init(apiKey: Env.geminiApiKey);

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RecommendationViewModel(),
        ),
      ],
      child: const MaterialApp(
        home: RecommendationPage(),
      ),
    ));

    final titleFinder = find.text("Get manga recommendation!!");
    final genreDropdownFinder = find.byType(DropdownButtonFormField<String>);
    final buttonFinder = find.text("Get recommendation");

    expect(titleFinder, findsOneWidget);
    expect(genreDropdownFinder, findsOneWidget);
    expect(buttonFinder, findsOneWidget);
  });
}
