import 'package:PongChamp/ui/pages/widgets/custom_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomSectionheader mostra titolo e Divider', (WidgetTester tester) async {
    const testTitle = 'Sezione Prova';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomSectionheader(title: testTitle),
        ),
      ),
    );

    // Verifica che il titolo venga mostrato
    expect(find.text(testTitle), findsOneWidget);

    // Verifica che il Divider sia presente
    expect(find.byType(Divider), findsOneWidget);
  });
}
