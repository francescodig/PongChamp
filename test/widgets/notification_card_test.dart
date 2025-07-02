import 'package:PongChamp/domain/models/notification_model.dart';
import 'package:PongChamp/ui/pages/widgets/notification_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NotificationCard mostra correttamente titolo, messaggio, data e icona',
      (WidgetTester tester) async {
    // Crea un oggetto fittizio NotificationModel
    final notification = NotificationModel(
      idNotifica: '1',
      idEvento: '1',
      userId: '1',
      title: 'Nuovo torneo disponibile',
      message: 'Partecipa subito al torneo estivo!',
      timestamp: Timestamp.fromDate(DateTime(2025, 6, 5, 16, 45)),
      read: false,
    );

    // Costruisce il widget nel test
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCard(notification: notification),
        ),
      ),
    );

    // Verifica che titolo e messaggio siano presenti
    expect(find.text('Nuovo torneo disponibile'), findsOneWidget);
    expect(find.text('Partecipa subito al torneo estivo!'), findsOneWidget);

    // Verifica che la data formattata sia corretta
    expect(find.text('05/06/2025\n16:45'), findsOneWidget);

    // Verifica che venga mostrata l'icona 'NUOVO' perché non è stata letta
    expect(find.text('NUOVO'), findsOneWidget);

    // Verifica che venga mostrata l'icona corretta (notifications_active)
    final iconFinder = find.byIcon(Icons.notifications_active);
    expect(iconFinder, findsOneWidget);
  });

  testWidgets('NotificationCard mostra lo stato "letto" correttamente', (WidgetTester tester) async {
    // Modello con read: true
    final notification = NotificationModel(
      idNotifica: '2',
      idEvento: '2',
      userId: '2',
      title: 'Allenamento confermato',
      message: 'Il tuo allenamento è stato confermato per domani.',
      timestamp: Timestamp.fromDate(DateTime(2025, 6, 6, 10, 30)),
      read: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCard(notification: notification),
        ),
      ),
    );

    // Verifica testi
    expect(find.text('Allenamento confermato'), findsOneWidget);
    expect(find.text('Il tuo allenamento è stato confermato per domani.'), findsOneWidget);
    expect(find.text('06/06/2025\n10:30'), findsOneWidget);

    // Verifica che NON ci sia il badge "NUOVO"
    expect(find.text('NUOVO'), findsNothing);

    // Verifica che l'icona sia notifications_none
    expect(find.byIcon(Icons.notifications_none), findsOneWidget);
  });

}