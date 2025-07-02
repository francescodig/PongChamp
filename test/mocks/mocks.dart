import 'package:mockito/annotations.dart';
import 'package:PongChamp/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

@GenerateMocks([
  AuthService,
  FirebaseAuth,
  User,
])
void main() {}