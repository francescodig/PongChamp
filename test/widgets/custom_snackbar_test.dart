import 'package:PongChamp/ui/pages/widgets/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomSnackBar mostra uno SnackBar con testo e icona', (WidgetTester tester) async {
    const testMessage = 'Messaggio di test';
    const testIcon = Icons.check;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Placeholder(),
        ),
      ),
    );

    // Mostra lo SnackBar
    CustomSnackBar.show(
      tester.element(find.byType(Placeholder)),
      message: testMessage,
      icon: testIcon,
    );

    // Fa avanzare il frame per far comparire lo SnackBar
    await tester.pump(); // inizializza animazione
    await tester.pump(const Duration(milliseconds: 200)); // lascia che appaia visivamente

    // Verifiche
    expect(find.text(testMessage), findsOneWidget);
    expect(find.byIcon(testIcon), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
