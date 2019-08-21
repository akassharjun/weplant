import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:we_plant/model/plant_information.dart';

import '../constants.dart';

class HomeModel extends Model {
  List<PlantInformation> _plantInformationList = [];

  void addPlantInformation(PlantInformation plantInformation) {
    _plantInformationList.add(plantInformation);
  }

  List<PlantInformation> get plantInformationList {
    return List.from(_plantInformationList);
  }

  Future retrievePreviousPlantInformation() async {
    http.Response response = await http.get(Constants.URL_PLANT_INFORMATION);

    List<dynamic> jsonArray = json.decode(response.body.toString());

    jsonArray.forEach((plantInformation) {
      plantInformation = json.encode(plantInformation);

      PlantInformation plantInformationDet =
          PlantInformation.fromJson(plantInformation);

      addPlantInformation(plantInformationDet);
    });
  }
}
