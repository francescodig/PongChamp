import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodel/map_view_model.dart';

class MapPage extends StatefulWidget {
  final LatLng? targetPosition; 
  const MapPage({Key? key, this.targetPosition}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  CameraPosition? _initialPosition;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapViewModel>(context, listen: false).loadMarkers(context);
      Provider.of<MapViewModel>(context, listen: false).setInitialLocation(context);
    });


  }

  

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }


  @override
    Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);
    

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
      
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca per nome luogo...',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          viewModel.searchMarkers('');
                          FocusScope.of(context).unfocus();
                        },
                      ),
              ),
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (value == _searchController.text) {
                    viewModel.searchMarkers(value);
                          // Sposta la camera se trova un marker
                    final position = viewModel.getCoordinatesByPlaceName(value);
                    if (position != null && _mapController != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLngZoom(position, 16),
                      );
                    }
                  }
                });
              },
            ),
          ),

          // Visualizzazione risultati
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${viewModel.markers.length} risultati',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (viewModel.markers.isNotEmpty)
                    TextButton(
                      child: const Text('Mostra tutti'),
                      onPressed: () {
                        _searchController.clear();
                        viewModel.searchMarkers('');
                      },
                    ),
                ],
              ),
            ),

          // Mappa
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: _initialPosition ??
                            CameraPosition(
                                target: LatLng(0, 0), 
                                zoom: 2,
                              ),
                            markers: viewModel.markers,
                            onMapCreated: (controller) {
                              _mapController = controller;
                              print("TARGET POSITION: ${widget.targetPosition}");
                              if (widget.targetPosition != null) {
                                _mapController!.moveCamera(
                                  CameraUpdate.newLatLngZoom(widget.targetPosition!, 16),
                                );
                              } else if (viewModel.cameraPosition != null) {
                                _mapController!.moveCamera(
                                  CameraUpdate.newCameraPosition(viewModel.cameraPosition!),
                                );
                              }
                            },
                            myLocationEnabled: true,
                          ),
                          if (_searchController.text.isNotEmpty && 
                              viewModel.markers.isEmpty)
                            const Center(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Nessun risultato trovato'),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}