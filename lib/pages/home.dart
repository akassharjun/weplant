import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:we_plant/model/plant_information.dart';
import 'package:we_plant/pages/plant_information.dart';

ScreenScaler scaler;

class HomePage extends StatefulWidget {
  static const String ROUTE = "home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static LatLng _center = LatLng(6.865183, 79.859787);

  var location = new Location();

  final Set<Marker> _markers = new Set();

  LatLng _lastMapPosition = _center;

  bool foundLocation = false;

  @override
  void initState() {
    super.initState();
//    SystemChrome.setSystemUIOverlayStyle(
//        SystemUiOverlayStyle(statusBarColor: Colors.black));
    _retrievePreviousPlantInformation();
  }

  void _retrievePreviousPlantInformation() {
    Future<http.Response> response =
        http.get('http://192.168.1.6:8080/api/v1/plantInformation');

    response.then((onValue) {
      print(onValue.body.toString());

      List<dynamic> list = json.decode(onValue.body.toString());
      var value = json.encode(list);

//      onValue.body

      List<PlantInformation> plantInformationList = [];

      list.forEach((plantInformation) {
        plantInformation = json.encode(plantInformation);

        PlantInformation plantInformationDet =
            PlantInformation.fromJson(plantInformation);

        _addMarker(plantInformationDet);
        plantInformationList.add(plantInformationDet);
      });
    });
  }

  void _addMarker(PlantInformation plantInformation) async {
    ImageConfiguration imageConfiguration =
        new ImageConfiguration(size: Size(5, 5));
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
        imageConfiguration, 'assets/tree.png');
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
    _getLocation();
  }

  Future<LatLng> _getLocation() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
      // From coordinates
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      print("ADDRESS");
      print("${first.featureName} : ${first.addressLine}");
      print("${first.countryName} : ${first.countryCode}");

      print("${currentLocation.toString()}");
      print(
          "Latidude : ${currentLocation.latitude}, Longitude : ${currentLocation.longitude}");
      _goToTheCurrentLocation(
          currentLocation.latitude, currentLocation.longitude);
      _center =  LatLng(currentLocation.latitude, currentLocation.longitude);
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  Future<void> _goToTheCurrentLocation(double lat, double long) async {
    CameraPosition currentLocation = CameraPosition(
      target: LatLng(lat, long),
      zoom: 15.0,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
    setState(() {
      foundLocation = true;
    });
  }

  Future goToCurrentLocation() async {
    CameraPosition currentLocation = CameraPosition(
      target: LatLng(_center.latitude, _center.longitude),
      zoom: 15.0,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
  }

  @override
  Widget build(BuildContext context) {
    scaler = new ScreenScaler()..init(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              padding: EdgeInsets.all(5.0),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0,
              ),
              mapType: MapType.normal,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
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
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                    onPressed: () {},
                    heroTag: "Find",
                    child: Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                    backgroundColor: Colors.white,
                  )),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: goToCurrentLocation,
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
                          Navigator.pushNamed(
                              context, PlantInformationScreen.ROUTE);
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
                  )),
            )
          ],
        ),
      ),
    );
  }
}
