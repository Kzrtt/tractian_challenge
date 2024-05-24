import 'package:tractian_challenge/models/location.dart';

class AssetsScreenModel {
  bool isToggledEnergy;
  bool isToggledCritic;
  List<Location> baseLocationList;
  List<Location> visualizationLocationList;

  AssetsScreenModel({
    required this.isToggledCritic,
    required this.isToggledEnergy,
    required this.baseLocationList,
    required this.visualizationLocationList,
  });
}
