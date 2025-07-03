import 'package:mockito/annotations.dart';
import 'package:PongChamp/data/services/auth_service.dart';
import 'package:PongChamp/data/services/user_service.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/post_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

@GenerateMocks([
  AuthService,
  UserService,
  UserViewModel,
  PostViewModel,
  FirebaseAuth,
  User,
])
void main() {}