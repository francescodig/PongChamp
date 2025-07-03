import 'package:PongChamp/data/services/repositories/user_repository.dart';
import 'package:PongChamp/domain/models/event_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/viewmodel/post_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';
import 'package:PongChamp/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';


void main() {
  late UserViewModel userViewModel;
  late PostViewModel postViewModel;
  late MockUserService mockUserService;

  setUp(() {
    mockUserService = MockUserService();
    userViewModel = UserViewModel(UserRepository(mockUserService));
    postViewModel = MockPostViewModel();

    // Configura i mock
    when(postViewModel.getCreatorProfileImageUrl("user123")).thenAnswer((_) async => null);
    when(userViewModel.getUserById("user123")).thenAnswer((_) async => AppUser(
      name: "NomeUtente",
      surname: "CognomeUtente",
      phoneNumber: "+39 320 886 1714",
      birthDay: DateTime.now(),
      profileImage: "mock.url",
      sex: "Male",
      id: 'user123',
      nickname: 'MockUser',
      email: 'mock@email.com',
      ));
  });

  testWidgets('CustomCard renders correctly with all elements', (tester) async {

    //Forza il binding a non caricare realmente le immagini
    TestWidgetsFlutterBinding.ensureInitialized();
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.renderView.configuration = TestViewConfiguration(
      size: const Size(1920, 1080),
    ); 

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
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserViewModel>.value(value: userViewModel),
          ChangeNotifierProvider<PostViewModel>.value(value: postViewModel),
        ],
        child: MaterialApp(
          home: Scaffold(
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

    await tester.pumpAndSettle();

    expect(find.text('Evento Test'), findsOneWidget);
    expect(find.text('MockUser'), findsOneWidget);
    expect(find.text('5 / 10'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Partecipa'), findsOneWidget);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(find.byIcon(Icons.group), findsOneWidget);
  });
}