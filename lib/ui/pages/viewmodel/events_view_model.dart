import '/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/data/services/event_service.dart';
import '/domain/models/event_model.dart';
import 'package:flutter/material.dart';

class EventViewModel extends ChangeNotifier {
  
  final EventService _eventService = EventService();
  final AuthService _authService=AuthService();

  List<Event> _events = [];
  List<Event> _userEvents = [];
  bool _isLoading = false;
  
  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> creaEvento({
    required String title,
    required String location,
    required int maxParticipants,
    required String matchType,
    required DateTime orario,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
    // 1. Recupera l'id dell'utente attualmente loggato
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("Nessun utente loggato.");
    }

    //2. Chiama il Service per ottenere un oggetto User
    final user = await _authService.fetchUserById(userId);

    //3. Crea l'oggetto Event
    final nuovoEvento = Event(
      id : "", //verrà assegnato poi dal Service (una volta generato da Firestore)
      creatorId: userId, 
      creatorNickname: user.nickname, 
      creatorProfileImage: user.profileImage, 
      title: title,
      location: location,
      participants: 1,
      maxParticipants: maxParticipants,
      matchType: matchType,
      createdAt: null, //verrà assegnato dal Service (al momento del salvataggio su Firestore)
      orario : orario,
    );

    //4. Salva il nuovo Event
    final eventoSalvato = await _eventService.addEvent(nuovoEvento);
    _events.add(eventoSalvato);

    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();

    }
  }
   
  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();
    _events = await _eventService.fetchUpcomingEvents();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserEvents() async {
    _isLoading = true;
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    _userEvents = await _eventService.fetchUserEvents(uid!);
    _isLoading = false;
    notifyListeners();
  }

  void participate(Event event) {
    // logica partecipazione
    print("Partecipi a: ${event.title}");
  }
}
