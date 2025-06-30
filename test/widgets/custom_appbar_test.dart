import 'package:PongChamp/ui/pages/view/home_page.dart';
import 'package:PongChamp/ui/pages/view/notifications_page.dart';
import 'package:PongChamp/ui/pages/view/search_page.dart';
import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Il logo è visibile e tappabile', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(), // usa qui il tuo widget da testare
      ),
      routes: {
        '/home': (context) => HomePage(),
      },
    ),
  );

  // Assicura che il widget sia visibile
  final logoFinder = find.byKey(const Key('logo_cliccabile'));
  expect(logoFinder, findsOneWidget);

  // Esegui il tap
  await tester.tap(logoFinder);
  await tester.pumpAndSettle();

  // Verifica che sia navigato a HomePage
  expect(find.byType(HomePage), findsOneWidget);
});
  /*
  testWidgets('Navigazione alla SearchPage tramite icona search', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(appBar: CustomAppBar())));

    final searchIcon = find.byIcon(Icons.search);
    expect(searchIcon, findsOneWidget);

    await tester.tap(searchIcon);
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
  });

  testWidgets('Navigazione alla NotificationsPage tramite icona notifiche', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(appBar: CustomAppBar())));

    final notifIcon = find.byIcon(Icons.notifications_none);
    expect(notifIcon, findsOneWidget);

    await tester.tap(notifIcon);
    await tester.pumpAndSettle();

    expect(find.byType(NotificationsPage), findsOneWidget);
  });
  */
}
