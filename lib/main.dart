import 'package:PongChamp/data/services/post_service.dart';
import 'package:PongChamp/data/services/repositories/post_repository.dart';
import 'package:PongChamp/ui/pages/viewmodel/post_view_model.dart';

import '../config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'ui/pages/viewmodel/register_view_model.dart';
import 'ui/pages/viewmodel/login_view_model.dart';
import 'ui/pages/view/login_page.dart';
import 'data/services/auth_service.dart';

import 'ui/pages/viewmodel/map_view_model.dart';

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
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel(context.read<AuthService>())),
        Provider<PostViewModel>.value(value: postViewModel),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        // altri ViewModel
        
      ],
      child: MyApp(),
    ),
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
