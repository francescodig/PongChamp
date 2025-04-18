import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:PongChamp/domain/models/marker_model.dart';

class MapViewModel extends ChangeNotifier{
  Set<Marker> _markers = {};   //_markers ha tutti i marker da mostrare
  bool _isLoading = true;      //indica se stiamo caricando i marker

  Set<Marker> get markers => _markers;
  bool get isLoading => _isLoading;

  Future<void> loadMarkers() async {
    try{
      final String response = await rootBundle.loadString('assets/markers.json');
      final List<dynamic> data = json.decode(response);   //conversione del file (stringa JSON) in lista dinamica
      _markers = data.map((item) {
        final markerData = MarkerData.fromJson(item);
        return Marker(
          markerId: MarkerId(markerData.id),
          position: LatLng(markerData.latitude, markerData.longitude),
          icon: BitmapDescriptor.defaultMarker,
        );
      }).toSet(); //converte la lista di Marker in un Set (evito i duplicati)

      _isLoading = false; //caricamento completato
    } catch (error) {
      _isLoading = false;
      print("Errore nel caricare i marker: $error");
    }
    notifyListeners(); //notifica i listener del caricamento
  }

}