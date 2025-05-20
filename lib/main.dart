import 'package:PongChamp/data/services/repositories/match_repository.dart';
import 'package:PongChamp/data/services/repositories/profile_page_repository.dart';
import 'package:PongChamp/data/services/repositories/search_repository.dart';
import 'package:PongChamp/data/services/repositories/user_repository.dart';
import 'package:PongChamp/data/services/search_service.dart';
import 'package:PongChamp/data/services/user_service.dart';
import 'package:PongChamp/ui/pages/viewmodel/forgot_password_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/notification_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/match_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/search_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';

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
import 'data/services/repositories/profile_page_repository.dart';
import 'ui/pages/viewmodel/profile_view_model.dart';
import 'ui/pages/viewmodel/expired_view_model.dart';




void main () async {

  //vedere questa cosa in un secondo momento... Aggiunta perchè dava errori strani in debugging
  Provider.debugCheckInvalidValueType = null;




  final postService = PostService();
  final postRepository = PostRepository(postService);
  final postViewModel = PostViewModel(postRepository);


  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // se usi firebase_options.dart
  );
  runApp(
    MultiProvider(
    providers: [
      Provider<AuthService>(create: (_) => AuthService()),
      Provider<SearchService>(create: (_) => SearchService()),
      Provider<MatchRepository>(create: (_) => MatchRepository()),
      ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ChangeNotifierProvider(create: (context) => LoginViewModel(context.read<AuthService>())),
      ChangeNotifierProvider(create: (context)=> ForgotPasswordViewModel(context.read<AuthService>())),
      ChangeNotifierProvider(create: (context) => MatchViewModel(context.read<MatchRepository>())),
      Provider<PostViewModel>.value(value: postViewModel),
      ChangeNotifierProvider(create: (_) => MapViewModel()),
      ChangeNotifierProvider(create: (_) => UserViewModel(UserRepository(UserService()))),
      ChangeNotifierProvider(create: (_) => EventViewModel()),
      ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ChangeNotifierProvider(create: (_) => ParticipantsViewModel()),
      Provider<PostRepository>(create: (_) => PostRepository(postService)),
      Provider<ProfilePageService>(create: (_) => ProfilePageService()),
      ProxyProvider<ProfilePageService, ProfilePageRepository>(update: (_, profilePageService, __) => ProfilePageRepository(profilePageService)),
       ProxyProvider<SearchService, SearchRepository>(
          update: (_, service, __) => SearchRepository(service),
        ),
      ChangeNotifierProvider(create: (context) => ProfileViewModel(context.read<ProfilePageRepository>())),
      ChangeNotifierProvider(create:  (context) => SearchViewModel(context.read<SearchRepository>())),
      ChangeNotifierProvider(create: (_) => ExpiredViewModel())
    ],
    child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      home: LoginPage(),
    );
  }
}
