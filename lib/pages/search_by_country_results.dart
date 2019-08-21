import 'package:flutter/material.dart';
import 'package:we_plant/model/plant_information.dart';

class SearchByCountryResultPage extends StatelessWidget {
  final String _countryName;
  final List<PlantInformation> _plantInformationList;

  SearchByCountryResultPage(this._countryName, this._plantInformationList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_countryName),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: <Widget>[
                Text("Planted By ${_plantInformationList[index].clubName}"),
                Text("Planted at ${_plantInformationList[index].plantedAt}"),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
          height: 2,
        ),
        itemCount: _plantInformationList.length,
      ),
    );
  }
}
