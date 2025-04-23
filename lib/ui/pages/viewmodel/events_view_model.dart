import '/domain/models/event_model.dart';
import 'package:flutter/material.dart';

class EventViewModel extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    // Chiamata API al back-end (mock per ora)
    _events = await EventService.getEvents();

    _isLoading = false;
    notifyListeners();
  }

  void participate(Event event) {
    // logica partecipazione o chiamata API
    print("Partecipi a: ${event.title}");
  }
}

class EventService {
  static getEvents() {}
}