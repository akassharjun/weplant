import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_plant/model/plant_information.dart';

import '../constants.dart';

class PlantInformationScreen extends StatefulWidget {
  static const String ROUTE = '/plantInfo';

  @override
  _PlantInformationScreenState createState() => _PlantInformationScreenState();
}

class _PlantInformationScreenState extends State<PlantInformationScreen> {
  var location = new Location();

  ScreenScaler scaler = ScreenScaler();

  final _formKey = GlobalKey<FormState>();

  int numberOfSeeds = 1;

  bool sendingData = false;

  Future<Map<String, String>> getLocation() async {
    LocationData currentLocation;
    Map<String, String> locationData = {};
    try {
      currentLocation = await location.getLocation();
      // From coordinates
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      String country = first.countryName;
      locationData['countryName'] = country;
      locationData['latitude'] = currentLocation.latitude.toString();
      locationData['longitude'] = currentLocation.longitude.toString();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return locationData;
  }

  Future submitForm() async {
    Map<String, String> locationData = await getLocation();

    setState(() {
      sendingData = true;
    });

    if (locationData.isEmpty) {
      setState(() {
        sendingData = false;
      });

      return;
    }

    if (_formKey.currentState.validate()) {
//      Scaffold.of(context)
//          .showSnackBar(SnackBar(content: Text('Processing Data')));

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String clubName = prefs.getString('clubName');
      int userID = prefs.getInt('userID');

      PlantInformation plantInformation = new PlantInformation(
        id: 0,
        userId: userID,
        clubName: clubName,
        latitude: double.parse(locationData['latitude']),
        longitude: double.parse(locationData['longitude']),
        countryName: locationData['countryName'],
        updatedBy: 'Admin',
        createdBy: 'Admin',
      );

      savePlantInformation(plantInformation);
    }
  }

  Future savePlantInformation(PlantInformation plantInformation) async {
    http.Response response = await http.post(
      Constants.URL_PLANT_INFORMATION,
      headers: {'content-type': 'application/json'},
      body: plantInformation.toJson(),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      setState(() {
        sendingData = false;
      });
    }
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: submitForm,
      color: Colors.green,
      child: Text(
        'SUBMIT',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Enter Information"),
      ),
      body: Center(
        child: Container(
          child: SafeArea(
              child: !sendingData
                  ? Container(
                      padding: EdgeInsets.all(12.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Number Of Seeds planted",
                              style: TextStyle(
                                fontSize: scaler.getTextSize(12),
                              ),
                            ),
                            SizedBox(
                              height: scaler.getHeight(3),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FloatingActionButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  elevation: 0.0,
                                  heroTag: "Remove",
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    if (numberOfSeeds == 1) {
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text(
                                              'You have to plant atleast a minimum of 1 seed.')));
                                      return;
                                    }
                                    setState(() {
                                      numberOfSeeds--;
                                    });
                                  },
                                  child: Icon(Icons.remove),
                                ),
                                Text(
                                  numberOfSeeds.toString(),
                                  style: TextStyle(
                                    fontSize: scaler.getTextSize(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FloatingActionButton(
                                  elevation: 0.0,
                                  heroTag: "Add",
                                  backgroundColor: Colors.green,
                                  onPressed: () {
                                    setState(() {
                                      numberOfSeeds++;
                                    });

                                  },
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: scaler.getHeight(5),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: _buildSubmitButton(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator()),
        ),
      ),
    );
  }
}
