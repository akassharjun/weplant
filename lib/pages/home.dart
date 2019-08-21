import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:we_plant/model/plant_information.dart';
import 'package:we_plant/pages/plant_information.dart';
import 'package:we_plant/pages/search_by_country.dart';
import 'package:we_plant/scoped_model/home.dart';

class HomePage extends StatefulWidget {
  static const String ROUTE = "home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  final HomeModel homeModel = HomeModel();
  ScreenScaler scaler;

  static LatLng _center = LatLng(6.865183, 79.859787);
  var location = new Location();
  Set<Marker> _markers = new Set();
  LatLng _lastMapPosition = _center;

  bool foundLocation = false;

  @override
  void initState() {
    super.initState();
    _addTreeMarkers();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _markers = new Set();
        _addTreeMarkers();
      });
    }
  }

  // Methods

  Future _addTreeMarkers() async {
    await homeModel.retrievePreviousPlantInformation();

    homeModel.plantInformationList.forEach((plantInformation) {
      _addMarker(plantInformation);
    });
  }

  void _addMarker(PlantInformation plantInformation) async {
    ImageConfiguration imageConfiguration =
        new ImageConfiguration(size: Size(5, 5));
    String assetName = 'assets/tree';

    Platform.isIOS ? assetName += "_ios.png" : assetName += "_android.png";

    print(assetName);
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(imageConfiguration, assetName);
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(
            LatLng(plantInformation.latitude, plantInformation.longitude)
                .toString()),
        position: LatLng(plantInformation.latitude, plantInformation.longitude),
        infoWindow: InfoWindow(
          title: 'Planted by the',
          snippet: plantInformation.clubName,
        ),
        icon: bitmapDescriptor,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _goToTheCurrentLocation();
  }

  Future<LatLng> _getLocation() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  Future<void> _goToTheCurrentLocation() async {
    LatLng coordinates = await _getLocation();
    CameraPosition currentLocation = CameraPosition(
      target: LatLng(coordinates.latitude, coordinates.longitude),
      zoom: 15.0,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
    setState(() {
      foundLocation = true;
    });
  }

  // Widgets

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      padding: EdgeInsets.all(5.0),
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10.0,
      ),
      mapType: MapType.normal,
      markers: _markers,
      onCameraMove: _onCameraMove,
      myLocationButtonEnabled: false,
    );
  }

  Widget _buildBottomToolBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _goToTheCurrentLocation,
              child: Icon(
                Icons.my_location,
                color: Colors.black54,
              ),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: scaler.getHeight(2)),
            FloatingActionButton.extended(
              heroTag: "Fab",
              onPressed: () {
                Navigator.pushNamed(context, PlantInformationScreen.ROUTE);
              },
              label: Text(
                'Plant A Tree',
                style: TextStyle(
                  fontSize: scaler.getTextSize(11),
                ),
              ),
              icon: Icon(Icons.toys),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopToolbar(BuildContext context) {
    return Positioned(
      top: 5,
      right: 5,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SearchByCountryPage(homeModel.plantInformationList);
              }));
            },
            heroTag: "Find",
            child: Icon(
              Icons.search,
              color: Colors.black54,
            ),
            backgroundColor: Colors.white,
          )),
    );
  }

  Widget _buildAppLogo() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: scaler.getHeight(18),
        width: scaler.getHeight(18),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: scaler.getHeight(10),
//                          color: Colors.black,
                    child: Image.asset('assets/plant.png'),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "WePlant",
//                        textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: scaler.getTextSize(15),
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252525),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    scaler = new ScreenScaler()..init(context);

    return ScopedModel(
      model: homeModel,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              _buildGoogleMap(),
              _buildAppLogo(),
              _buildTopToolbar(context),
              _buildBottomToolBar(context)
            ],
          ),
        ),
      ),
    );
  }
}
