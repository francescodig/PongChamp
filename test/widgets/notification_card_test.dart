import 'package:PongChamp/domain/models/notification_model.dart';
import 'package:PongChamp/ui/pages/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Visualizza correttamente titolo, messaggio e data', (WidgetTester tester) async {
    final notification = NotificationModel(
      userId: "tyuio",
      eventId: "rtgsbcn",
      idNotifica: "fghjkl",
      title: 'Titolo',
      message: 'Messaggio di test',
      timestamp: DateTime(2024, 12, 24, 15, 30),
      read: true,
    );

    await tester.pumpWidget(MaterialApp(
      home: NotificationCard(notification: notification),
    ));

    expect(find.text('Titolo'), findsOneWidget);
    expect(find.textContaining('Messaggio di test'), findsOneWidget);
    expect(find.textContaining('24/12/2024'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none), findsOneWidget);
  });

  testWidgets('Mostra badge NUOVO e testo in grassetto se non letta', (WidgetTester tester) async {
    final notification = NotificationModel(
      userId: "tyuio",
      eventId: "rtgsbcn",
      idNotifica: "fghjkl",
      title: 'Notifica Nuova',
      message: 'Messaggio importante',
      timestamp: DateTime.now(),
      read: false,
    );

    await tester.pumpWidget(MaterialApp(
      home: NotificationCard(notification: notification),
    ));

    expect(find.text('NUOVO'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_active), findsOneWidget);

    final title = tester.widget<Text>(find.text('Notifica Nuova'));
    expect(title.style?.fontWeight, FontWeight.bold);
  });

  testWidgets('Non mostra badge se notifica è già letta', (WidgetTester tester) async {
    final notification = NotificationModel(
      userId: "tyuio",
      eventId: "rtgsbcn",
      idNotifica: "fghjkl",
      title: 'Già letta',
      message: 'Messaggio già visto',
      timestamp: DateTime.now(),
      read: true,
    );

    await tester.pumpWidget(MaterialApp(
      home: NotificationCard(notification: notification),
    ));

    expect(find.text('NUOVO'), findsNothing);
    expect(find.byIcon(Icons.notifications_none), findsOneWidget);

    final title = tester.widget<Text>(find.text('Già letta'));
    expect(title.style?.fontWeight, isNot(FontWeight.bold));
  });

  testWidgets('Il messaggio troppo lungo viene troncato con ellissi', (WidgetTester tester) async {
    final longMessage = 'Questo è un messaggio molto lungo che dovrebbe essere troncato a due righe...';
    final notification = NotificationModel(
      userId: "tyuio",
      eventId: "rtgsbcn",
      idNotifica: "fghjkl",
      title: 'Titolo',
      message: longMessage,
      timestamp: DateTime.now(),
      read: false,
    );

    await tester.pumpWidget(MaterialApp(
      home: NotificationCard(notification: notification),
    ));

    final textWidget = tester.widget<Text>(find.textContaining('Questo'));
    expect(textWidget.maxLines, 2);
    expect(textWidget.overflow, TextOverflow.ellipsis);
  });

}