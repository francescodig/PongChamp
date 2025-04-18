import 'package:PongChamp/ui/pages/view/organises_page.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:PongChamp/ui/pages/view/settings_page.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:PongChamp/ui/pages/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:PongChamp/ui/pages/viewmodel/map_view_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(42.34, 13.39),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    // carico i marker una volta che la pagina è montata
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapViewModel>(context, listen: false).loadMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);  //uso il provider per accedere al viewmodel

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mappa"),
        backgroundColor: Colors.yellow,
      ),
      body: viewModel.isLoading
        ? Center(child: CircularProgressIndicator())  // mostro un caricamento finché i marker non sono pronti
        : GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: viewModel.markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
          ),
          bottomNavigationBar: CustomNavBar(
          ),
    );
  }
}