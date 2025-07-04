import 'package:PongChamp/ui/pages/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '/data/services/event_service.dart';
import '/data/services/repositories/event_repository.dart';
import '/data/services/uploadImage_service.dart';
import '/data/services/match_service.dart';
import '/data/services/repositories/match_repository.dart';
import '/data/services/repositories/profile_page_repository.dart';
import '/data/services/repositories/search_repository.dart';
import '/data/services/repositories/user_repository.dart';
import '/data/services/search_service.dart';
import '/data/services/user_service.dart';
import '/ui/pages/viewmodel/forgot_password_view_model.dart';
import '/ui/pages/viewmodel/notification_view_model.dart';
import '/ui/pages/viewmodel/match_view_model.dart';
import '/ui/pages/viewmodel/search_view_model.dart';
import '/ui/pages/viewmodel/user_view_model.dart';
import '/ui/pages/viewmodel/participants_view_model.dart';
import '/data/services/post_service.dart';
import '/data/services/repositories/post_repository.dart';
import '/ui/pages/viewmodel/post_view_model.dart';
import '../config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'ui/pages/viewmodel/register_view_model.dart';
import 'ui/pages/viewmodel/login_view_model.dart';
import 'ui/pages/view/login_page.dart';
import 'data/services/auth_service.dart';
import 'ui/pages/viewmodel/map_view_model.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import 'data/services/profile_page_service.dart';
import 'ui/pages/viewmodel/profile_view_model.dart';
import 'ui/pages/viewmodel/expired_view_model.dart';

void main() async {
  //Aggiunta perchè dava errori strani in debugging
  Provider.debugCheckInvalidValueType = null;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform,
  ); 
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<SearchService>(create: (_) => SearchService()),
        Provider<EventService>(create: (_) => EventService()),
        Provider<MatchService>(create: (_) => MatchService()),
        Provider<PostService>(create: (_) => PostService()),
        Provider<ImageService>(create: (_) => ImageService()),
        Provider<ProfilePageService>(create: (_) => ProfilePageService()),

        Provider<EventRepository>(
          create: (context) => EventRepository(context.read<EventService>()),
        ),
        Provider<MatchRepository>(
          create:
              (context) => MatchRepository(
                context.read<MatchService>(),
                context.read<EventRepository>(),
              ),
        ),
        Provider<PostRepository>(
          create:
              (context) => PostRepository(
                context.read<PostService>(),
                context.read<MatchRepository>(),
              ),
        ),

        ChangeNotifierProvider(
          create: (context) => MatchViewModel(context.read<MatchRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => PostViewModel(context.read<PostRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ForgotPasswordViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(UserRepository(UserService())),
        ),
        ChangeNotifierProvider(
          create: (context) => EventViewModel(context.read<EventRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ParticipantsViewModel()),

        ProxyProvider<ProfilePageService, ProfilePageRepository>(
          update:
              (_, profilePageService, __) =>
                  ProfilePageRepository(profilePageService),
        ),
        ProxyProvider<SearchService, SearchRepository>(
          update: (_, service, __) => SearchRepository(service),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  ProfileViewModel(context.read<ProfilePageRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => SearchViewModel(context.read<SearchRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => ExpiredViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // L'utente è loggato
          return HomePage(currentUserId: FirebaseAuth.instance.currentUser!.uid);
        } else {
          // L'utente non è loggato
          return LoginPage();
        }
      },
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      home:  AuthWrapper(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(currentUserId: FirebaseAuth.instance.currentUser!.uid),
      },
    );
  }
}
