import 'dart:convert';
import 'package:PongChamp/ui/pages/view/event_location_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:PongChamp/domain/models/marker_model.dart';
import 'package:geolocator/geolocator.dart';

class MapViewModel extends ChangeNotifier {
  Set<Marker> _markers = {};  // conserva i marker filtrati
  Set<Marker> _allMarkers = {}; // conserva tutti i marker originali
  bool _isLoading = true; // stato di caricamento
  String _searchQuery = ''; // query di ricerca
  Position? _userPosition; // posizione dell'utente
  CameraPosition? _cameraPosition; // posizione della camera

  Set<Marker> get markers => _markers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  Position? get userPosition => _userPosition;
  CameraPosition? get cameraPosition => _cameraPosition;

  Future<void> setInitialLocation(context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servizi di localizzazione non abilitati')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _userPosition = position;
    _cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );

    addUserLocationMarker(position);
    notifyListeners();
    
  }


  Future<void> addUserLocationMarker(position) async {
    final userMarker = Marker(
      markerId: const MarkerId('user_position'),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(
        title: 'La tua posizione',
      ),
    );

    // Aggiungi il marker alla collezione dei marker
    _allMarkers.add(userMarker);
    _markers = _searchQuery.isEmpty
        ? _allMarkers
        : _allMarkers.where((marker) {
            final title = marker.infoWindow.title?.toLowerCase() ?? '';
            final snippet = marker.infoWindow.snippet?.toLowerCase() ?? '';
            return title.contains(_searchQuery) || snippet.contains(_searchQuery);
          }).toSet();

    notifyListeners();
  }


  Future<void> loadMarkers(BuildContext context) async {  // carica i marker da un file JSON e li salva in _allMarkers 
    try {
      final String response = await rootBundle.loadString('assets/markers.json');
      final List<dynamic> data = json.decode(response);
      
      _allMarkers = data.map((item) {
        final markerData = MarkerData.fromJson(item);
        return Marker(
          markerId: MarkerId(markerData.id),
          position: LatLng(markerData.latitude, markerData.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: markerData.nome,
            snippet: 'Clicca per dettagli',
          ),
          onTap: () {
            _showMarkerDetails(context, markerData);
          },
        );
      }).toSet();

      _markers = _allMarkers; // Inizialmente mostra tutti i marker
      _isLoading = false;
    } catch (error) {
      _isLoading = false;
      print("Errore nel caricare i marker: $error");
    }
    notifyListeners();
  }

  // Funzione di ricerca
  void searchMarkers(String query) { // aggiorna la query di ricerca e filtra i marker
    _searchQuery = query.toLowerCase();
    
    if (_searchQuery.isEmpty) {
      _markers = _allMarkers;
    } else {
      _markers = _allMarkers.where((marker) {
        final markerTitle = marker.infoWindow.title?.toLowerCase() ?? '';
        final markerSnippet = marker.infoWindow.snippet?.toLowerCase() ?? '';
        return markerTitle.contains(_searchQuery) || 
               markerSnippet.contains(_searchQuery);
      }).toSet();
    }
    
    notifyListeners();
  }

  void _showMarkerDetails(BuildContext context, MarkerData markerData) { // mostra i dettagli del marker in un dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Dettagli per: ${markerData.nome}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Orario di apertura: ${markerData.orario}'),
            if (markerData.descrizione != null)
              Text('Descrizione: ${markerData.descrizione}'),
            TextButton(
              onPressed:() { Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventLocationPage(location: markerData.id),
                ),
              );},
              child: Text('Vai agli eventi')),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Chiudi'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}