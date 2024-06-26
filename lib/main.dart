import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geofence_service/geofence_service.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _locationStreamController = StreamController<Location>();
  late GeofenceService _geofenceService;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initGeofenceService();
  }

  void _initGeofenceService() {
    _geofenceService = GeofenceService.instance.setup(
      interval: 200, // zaman aralığı (ms)
      accuracy: 100,// kesinlik (%percentage)
      loiteringDelayMs: 60000, // konumun sabit kalma süresi (bu süre kadar sabit kalırsa status lotering olacak
      statusChangeDelayMs: 10000, // statusun değişmesini ne kadar sürede algılayacağı süre
      useActivityRecognition: false, //  cihaz aktivitesi tanıma özelliği (?)
      allowMockLocations: false, // sahte konum kabul etme durumu
      printDevLog: false, // konsola yazdırma
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC, // yarıcapı küçükten büyüğe sırala
    );

    // Start listening for location updates
    _geofenceService.addLocationChangeListener(_onLocationChanged);
    _geofenceService.start([]).catchError(_onError);
  
  }

  void _onLocationChanged(Location location) {
    print('Location: ${location.toJson()}');
    _locationStreamController.sink.add(location);

    // Update map marker
    _updateMapMarker(location);
  }

  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      return;
    }

    print('ErrorCode: $errorCode');
  }
  
  void _updateMapMarker(Location location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _locationStreamController.close();
    _geofenceService.stop(); // Stop location updates when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Location Tracker'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _buildMapView(), // Harita görünümü
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: _buildLocationInfo(), // Konum bilgi kutusu
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(37.7749, -122.4194), // Başlangıçta gösterilecek konum
        zoom: 14.0, // Başlangıçta gösterilecek yakınlık seviyesi
      ),
      myLocationEnabled: true, // Kullanıcının konumunu haritada göster
      compassEnabled: true, // Pusula göster
      mapType: MapType.normal, // Harita tipi
      markers: _markers, // Harita işaretçileri
    );
  }

  Widget _buildLocationInfo() {
    return StreamBuilder<Location>(
      stream: _locationStreamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final location = snapshot.data!;
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text('Current Location: ${location.latitude}, ${location.longitude}'),
        );
      },
    );
  }
}
