import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:we_plant/model/plant_information.dart';
import 'package:we_plant/pages/search_by_country_results.dart';

class SearchByCountryPage extends StatelessWidget {
  static const String ROUTE = "searchByCountry";
  ScreenScaler scaler;

  final List<PlantInformation> _plantInformationList;
  List<String> _countryNames = [];

  SearchByCountryPage(this._plantInformationList);

  void doThis() {
    _plantInformationList.forEach((plantInformation) {
      if (!_countryNames.contains(plantInformation.countryName)) {
        _countryNames.add(plantInformation.countryName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    doThis();
    scaler = ScreenScaler()..init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search By Country"),
        actions: <Widget>[
          Icon(Icons.search),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SearchByCountryResultPage(
                    _countryNames[index],
                    _plantInformationList
                        .where((plantInfo) =>
                            plantInfo.countryName == _countryNames[index])
                        .toList());
              }));
            },
            child: Container(
              padding: EdgeInsets.all(scaler.getTextSize(12)),
              child: Text(
                _countryNames[index],
                style: TextStyle(fontSize: scaler.getTextSize(14)),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
          height: 2,
        ),
        itemCount: _countryNames.length,
      ),
    );
  }
}
