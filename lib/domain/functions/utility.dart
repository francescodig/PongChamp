import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//Funzione per la navigazione nella navBar
void navigateTo(BuildContext context, Widget page, String routeName) {
  final ModalRoute? currentRoute = ModalRoute.of(context);

  if (currentRoute?.settings.name != routeName) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(name: routeName),
      ),
      (route) => route.isFirst,
    );
  }
}




