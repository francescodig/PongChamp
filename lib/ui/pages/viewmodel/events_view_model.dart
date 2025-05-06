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

  ///Lista contenente solo gli eventi a cui l'utente partecipa ,che non ha creato
  List<Event> get userOnlyParticipatedEvents {
    final createdIds = _userEvents.map((e) => e.id).toSet();
    return _userParticipatedEvents
        .where((e) => !createdIds.contains(e.id))
        .toList();
  }
  
  List<Event> get events => _events;
  List<Event> get userEvents => _userEvents;
  List<Event> get userPartecipates => _userParticipatedEvents;
  bool get isLoading => _isLoading;
  String? get userId => _authService.currentUserId;

  Future<void> creaEvento({
    required String title,
    required MarkerData location,
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
      id : "", //verrà assegnato poi dal Service, una volta generato da Firestore
      creatorId: userId, 
      creatorNickname: user.nickname, 
      creatorProfileImage: user.profileImage, 
      title: title,
      locationId: location.id,
      locationName: location.nome,
      participants: 1,
      maxParticipants: maxParticipants,
      participantIds: [userId], //il creatore è il primo partecipante
      matchType: matchType,
      createdAt: null, //verrà assegnato dal Service, al momento del salvataggio su Firestore
      orario : orario,
    );
    //4. Salva il nuovo Event
    final eventoSalvato = await _eventService.addEvent(nuovoEvento);
    _events.add(eventoSalvato);
    } catch (e) {
      debugPrint("$e");
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

  Future<void> fetchPartecipateEvents() async {
    _isLoading = true;
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    _userParticipatedEvents = await _eventService.fetchEventsUserParticipates(uid!);
    _isLoading = false;
    notifyListeners();
  }

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

  Future<List<MarkerData>> loadLocationsFromJson() async {
    final jsonString = await rootBundle.loadString('assets/markers.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => MarkerData.fromJson(item)).toList();
  }

  List<MarkerData> _markers = [];
  Future<void> fetchMarkers() async {
    try {
      final loadedMarkers = await loadLocationsFromJson(); // questo deve già esserci
      _markers = loadedMarkers;
      notifyListeners();
    } catch (e) {
      debugPrint("Errore nel caricamento dei Marker: $e");
    }
  }
  MarkerData? _selectedLocation;

  List<MarkerData> get markers => _markers;
  MarkerData? get selectedLocation => _selectedLocation;

  void setSelectedLocation(MarkerData? loc) {
    _selectedLocation = loc;
    notifyListeners();
  }
}



