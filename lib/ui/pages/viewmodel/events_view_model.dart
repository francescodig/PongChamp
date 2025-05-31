import 'dart:convert';
import '/domain/models/marker_model.dart';
import 'package:flutter/services.dart';
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
  List<Event> _userParticipatedEvents=[];

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get userId => _authService.currentUserId;

  List<Event> get events => _events;
  List<Event> get userEvents => _userEvents;
  List<Event> get userPartecipates => _userParticipatedEvents;

  ///Lista contenente solo gli eventi a cui l'utente partecipa ,che non ha creato
  List<Event> get userOnlyParticipatedEvents {
    final createdIds = _userEvents.map((e) => e.id).toSet();
    return _userParticipatedEvents
        .where((e) => !createdIds.contains(e.id))
        .toList();
  }
  
  ///Lista contente solo gli eventi creati dall'utente non ancora scaduti
  List<Event> get userFutureEvents {
    return _userEvents
    .where((e) => e.dataEvento.isAfter(DateTime.now()))
    .toList();
  }

  ///Lista contente solo gli eventi a cui l'utente partecipa non ancora scaduti
  List<Event> get onlyParticipatedFutureEvents {
    return userOnlyParticipatedEvents
    .where((e) => e.dataEvento.isAfter(DateTime.now()))
    .toList();
  }

  ///Lista contenente gli eventi creati o a cui l'utente partecipa ma scaduti e con partecipanti massimi
  List<Event> get userExpiredEvents {
    final now = DateTime.now();
    final allUserEvents = [...userEvents, ...userOnlyParticipatedEvents];
    return allUserEvents.where((event) => 
      event.dataEvento.isBefore(now) &&
      event.participantIds.length >= event.maxParticipants
      ).toList();
  }

  Future<void> creaEvento({
    required String title,
    required MarkerData location,
    required int maxParticipants,
    required String eventType,
    required DateTime dataEvento,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
    //Recupera l'id dell'utente attualmente loggato
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("Nessun utente loggato.");
    }
    //Crea l'oggetto Event
    final nuovoEvento = Event(
      id : "", //verrà assegnato poi dal Service, una volta generato da Firestore
      creatorId: userId,  
      title: title,
      locationId: location.id,
      participants: 1,
      maxParticipants: maxParticipants,
      participantIds: [userId], //il creatore è il primo partecipante
      eventType: eventType,
      createdAt: DateTime.now(), //verrà assegnato dal Service, al momento del salvataggio su Firestore
      dataEvento : dataEvento,
      hasMatch: false,
    );
    //Salva il nuovo Event
    final eventoSalvato = await _eventService.addEvent(nuovoEvento);
    _events.add(eventoSalvato);
    } catch (e) {
      debugPrint("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEvent(Event event, String userId) async {
    _isLoading = true;
    notifyListeners();
    if (event.creatorId != userId) {
      return false;
    }
    final eventId = event.id;
    final success =await _eventService.removeEvent(event,userId);
    if (success){
      _events.remove((e) => e.id = eventId);
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  //Carica tutti gli eventi nella variabile _events
  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();
    _events = await _eventService.fetchUpcomingEvents();
    _isLoading = false;
    notifyListeners();
  }

  //Carica tutti gli eventi creati dall'utente nella variabile _userEvents
  Future<void> fetchUserEvents() async {
    _isLoading = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    _userEvents = await _eventService.fetchUserEvents(uid);
    _isLoading = false;
    notifyListeners();
  }

  //Carica tutti gli eventi a cui l'utente partecipa nella variabile _userParticipatedEvents
  Future<void> fetchPartecipateEvents() async {
    _isLoading = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    _userParticipatedEvents = await _eventService.fetchEventsUserParticipates(uid);
    _isLoading = false;
    notifyListeners();
  }

  //Funzione di partecipazione ad un evento
  Future<void> partecipateToEvent(Event event) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    // Controlla se l'utente è già nella lista
    if (event.participantIds.contains(userId)) {
      debugPrint("L'utente è già iscritto all'evento."); //da modificare
      return;
    }
    // Controlla se c'è ancora spazio
    if (event.participantIds.length >= event.maxParticipants) {
      debugPrint("L'evento ha raggiunto il numero massimo di partecipanti."); //da modificare
      return;
    }
    try {
      // Chiede al Service di aggiornare l'evento su Firestore
      final updatedEvent = await _eventService.addParticipant(event, userId);
      // Aggiorna l'evento localmente
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Errore durante la partecipazione: $e");
    }
  }

  List<Event> getEventsByLocation(String location) {
    return _events.where((event) => event.locationId.toLowerCase() == location.toLowerCase()).toList();
  }

  //Funzione di rimozione partecipazione ad un evento
  Future<bool> removeParticipant(Event event, String? userId) async{
    //Controllo se l'utente è partecipante
    if (!event.participantIds.contains(userId)) {
    return false; // Non fare nulla se non è partecipante
    }
    try {
      // Chiamata al Service
      await _eventService.removeParticipant(event, userId);
      // Aggiorna la lista localmente
      event.participantIds.remove(userId);
      event.participants = event.participantIds.length;
      notifyListeners();
      return true;
    } catch(e){
      debugPrint("Errore durante la rimozione del partecipante: $e");
      return false;
    }
  }

  //Carica tutti i markers esistenti nella variabile _markers
  List<MarkerData> _markers = [];
  Future<List<MarkerData>> loadLocationsFromJson() async {
    final jsonString = await rootBundle.loadString('assets/markers.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => MarkerData.fromJson(item)).toList();
  }
  Future<void> fetchMarkers() async {
    try {
      final loadedMarkers = await loadLocationsFromJson(); // questo deve già esserci
      _markers = loadedMarkers;
      notifyListeners();
    } catch (e) {
      debugPrint("Errore nel caricamento dei Marker: $e");
    }
  }

  //Per la gestione della scelta della location nella creazione di un evento
  MarkerData? _selectedLocation;

  List<MarkerData> get markers => _markers;
  MarkerData? get selectedLocation => _selectedLocation;

  void setSelectedLocation(MarkerData? loc) {
    _selectedLocation = loc;
    notifyListeners();
  }

}



