import 'dart:ui';

class AppUser {
  final String id;
  String name;
  String surname;
  String phoneNumber;
  String email;
  String password;
  Image? profileImage;
  DateTime birthDay;
  String sex;
  String nickname;


  AppUser({
  required this.id,
  required this.name, 
  required this.surname, 
  required this.phoneNumber, 
  required this.email, 
  required this.password,
  required this.profileImage,
  required this.birthDay,
  required this.sex,
  required this.nickname,
  });
}
