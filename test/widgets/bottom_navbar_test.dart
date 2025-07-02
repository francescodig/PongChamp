import 'package:PongChamp/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {
  final MockUser _mockUser = MockUser();

  MockFirebaseAuth() {
    when(_mockUser.uid).thenReturn('testUser');
    when(currentUser).thenReturn(_mockUser);
  }
}

class MockAuthService extends Mock implements AuthService {
  MockAuthService() {
    when(currentUserId).thenReturn('testUser');
  }
}

void main() {
  late MockAuthService mockAuthService;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockAuthService = MockAuthService(); // Non serve più MockUser separato
    mockFirebaseAuth = MockFirebaseAuth();
  });

  testWidgets('CustomNavBar mostra tutte le icone', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomNavBar(
            authService: mockAuthService,
            firebaseAuth: mockFirebaseAuth,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.list), findsOneWidget);
    expect(find.byIcon(Icons.map), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}