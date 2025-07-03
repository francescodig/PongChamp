import 'package:PongChamp/data/services/repositories/user_repository.dart';
import 'package:PongChamp/data/services/user_service.dart';
import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';
import 'package:PongChamp/ui/pages/widgets/custom_match_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('CustomMatchCard mostra titolo, tipo e punteggio correttamente', (WidgetTester tester) async {
    // Mock di un PongMatch
    final match = PongMatch(
      matchTitle: 'Finale Torneo',
      type: '1 vs 1',
      date: DateTime(2025, 6, 5, 15, 30),
      matchPlayers: ['player1', 'player2'],
      score1: 3,
      score2: 2,
      creatorId: "hdjaklò",
      id: "hbjnkmlò",
      idEvento: "gsvabhn",
      winnerId: "ghsjaklò",
      hasPost: false,
    );

    // UserViewModel mockato o dummy per il test (serve solo per non far crashare il widget)
    final userViewModel = UserViewModel(UserRepository(UserService()));

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<UserViewModel>.value(
          value: userViewModel,
          child: Scaffold(
            body: CustomMatchCard(match: match),
          ),
        ),
      ),
    );

    // Controlla che il titolo della partita sia presente
    expect(find.text('Finale Torneo'), findsOneWidget);

    // Controlla che il tipo sia presente
    expect(find.text('1 vs 1'), findsOneWidget);

    // Controlla che il punteggio sia presente (esempio: "3 - 2")
    expect(find.text('3 - 2'), findsOneWidget);
  });

}