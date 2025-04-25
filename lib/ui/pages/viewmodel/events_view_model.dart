import '/data/services/event_service.dart';
import '/domain/models/event_model.dart';
import 'package:flutter/material.dart';

class EventViewModel extends ChangeNotifier {
  
  final EventService _eventService = EventService();

  List<Event> _events = [];
  bool _isLoading = false;
  
  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> creaEvento({
    required String username,
    required String title,
    required String location,
    required int maxParticipants,
    required String matchType,
    required DateTime orario,
  }) async {
    try{
    final nuovoEvento = Event(
      id : "", //verrà assegnato poi dal Service (una volta generato da Firestore)
      username: username,
      title: title,
      location: location,
      participants: 1,
      maxParticipants: maxParticipants,
      matchType: matchType,
      createdAt: null,
      orario : orario,
    );

    final eventoSalvato = await _eventService.addEvent(nuovoEvento);

    _events.add(eventoSalvato);
    notifyListeners();
    } catch (e) {
      print(e);
    }
    
  }
   
  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    // Chiamata API al back-end (mock per ora)
    _events = await _eventService.fetchUpcomingEvents();

    _isLoading = false;
    notifyListeners();
  }

  void participate(Event event) {
    // logica partecipazione o chiamata API
    print("Partecipi a: ${event.title}");
  }
}
