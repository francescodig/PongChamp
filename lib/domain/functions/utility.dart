import 'package:flutter/material.dart';

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
