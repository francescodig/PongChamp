import 'package:PongChamp/data/services/auth_service.dart';
import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/mockito.dart';


class MockAuthService extends Mock implements AuthService {}
void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockAuthService mockAuthService;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    mockAuthService = MockAuthService();

    // Simula un utente loggato
    when(mockAuthService.currentUserId).thenReturn('testUser');
  });

  testWidgets('Mostra CustomAppBar con badge se ci sono notifiche non lette',
      (WidgetTester tester) async {
    // Aggiungi una notifica non letta
    await fakeFirestore.collection('UserNotifications').add({
      'userId': 'testUser',
      'read': false,
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            authService: mockAuthService,
            firestore: fakeFirestore,
          ),
        ),
      ),
    );

    // pumpAndSettle per attendere gli stream
    await tester.pumpAndSettle();

    // Verifica che l'icona sia presente
    expect(find.byIcon(Icons.notifications_none), findsOneWidget);

    // Verifica che il badge mostri "1"
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Mostra CustomAppBar con badge se non ci sono notifiche non lette',
      (WidgetTester tester) async {
    // Aggiungi una notifica letta
    await fakeFirestore.collection('UserNotifications').add({
      'userId': 'testUser',
      'read': true,
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: CustomAppBar(
            authService: mockAuthService,
            firestore: fakeFirestore,
          ),
        ),
      ),
    );

    // pumpAndSettle per attendere gli stream
    await tester.pumpAndSettle();

    // Verifica che l'icona sia presente
    expect(find.byIcon(Icons.notifications_none), findsOneWidget);

    // Verifica che il badge mostri "1"
    expect(find.text('1'), findsNothing);
  });
}

