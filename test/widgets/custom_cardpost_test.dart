import 'package:PongChamp/data/services/event_service.dart';
import 'package:PongChamp/data/services/match_service.dart';
import 'package:PongChamp/data/services/post_service.dart';
import 'package:PongChamp/data/services/repositories/event_repository.dart';
import 'package:PongChamp/data/services/repositories/match_repository.dart';
import 'package:PongChamp/data/services/repositories/post_repository.dart';
import 'package:PongChamp/data/services/repositories/user_repository.dart';
import 'package:PongChamp/data/services/user_service.dart';
import 'package:PongChamp/domain/models/event_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/viewmodel/post_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';
import 'package:PongChamp/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  final userViewModel = UserViewModel(UserRepository(UserService()));
  testWidgets('CustomCard renders correctly with all elements', (tester) async {
    final event = Event(
      id: '1',
      createdAt: DateTime.now(),
      hasMatch: true,
      title: 'Evento Test',
      locationId: 'Milano',
      participants: 5,
      maxParticipants: 10,
      eventType: 'Torneo',
      dataEvento: DateTime(2025, 6, 30, 18, 0),
      creatorId: 'user123',
      participantIds: ['user1', 'user2'],
    );

    await tester.pumpWidget(
      MaterialApp(
          home: ChangeNotifierProvider<UserViewModel>.value(
            value: userViewModel,
            child: Scaffold(
              body: CustomCard(
                event: event,
                onTap: () {},
                buttonText: 'Partecipa',
                buttonColor: Colors.blue,
              ),
            ),
          ),
      ),
    );

    // Dobbiamo aspettare che i FutureBuilder finiscano
    await tester.pumpAndSettle();

    // Verifica che il titolo evento sia presente
    expect(find.text('Evento Test'), findsOneWidget);

    // Verifica che nickname mock sia mostrato
    expect(find.text('MockUser'), findsOneWidget);

    // Verifica che il testo partecipanti sia corretto
    expect(find.text('5 / 10'), findsOneWidget);

    // Verifica la presenza del bottone con il testo corretto
    expect(find.widgetWithText(ElevatedButton, 'Partecipa'), findsOneWidget);

    // Verifica la presenza delle icone
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(find.byIcon(Icons.group), findsOneWidget);

    // Verifica che la CircleAvatar con immagine sia presente
    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar).first);
    expect(avatar.backgroundImage, isNotNull);
  });
}
