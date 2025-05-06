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
  List<Event> get userEvents => _userEvents;
  bool get isLoading => _isLoading;
  String? get userId => _authService.currentUserId;

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
      participantIds: [userId], //il creatore è il primo partecipante
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

  Future<void> partecipateToEvent(Event evento) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    // Controlla se l'utente è già nella lista
    if (evento.participantIds.contains(userId)) {
      debugPrint("L'utente è già iscritto all'evento."); //da modificare
      return;
    }
    // Controlla se c'è ancora spazio
    if (evento.participantIds.length >= evento.maxParticipants) {
      debugPrint("L'evento ha raggiunto il numero massimo di partecipanti."); //da modificare
      return;
    }
    try {
      // Chiede al Service di aggiornare l'evento su Firestore
      final updatedEvent = await _eventService.addParticipant(evento, userId);
      // Aggiorna l'evento localmente
      final index = _events.indexWhere((e) => e.id == evento.id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Errore durante la partecipazione: $e");
    }
  }

List<Event> getEventsByLocation(String location) {
  return _events.where((event) => event.location.toLowerCase() == location.toLowerCase()).toList();
}


}
