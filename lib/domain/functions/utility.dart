import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



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

String formatDateTimeManually(DateTime dateTime) {
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString();
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');

  return '$day/$month/$year\n$hour:$minute';
}

String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) {
    return 'N/A';
  } else{
  final DateTime dateTime = timestamp.toDate();
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(dateTime);

  if (difference.inMinutes < 1) return 'Adesso';
  if (difference.inMinutes < 60) return '${difference.inMinutes} min fa';
  if (difference.inHours < 24) return '${difference.inHours} h fa';

  return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
         'alle ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}



  


