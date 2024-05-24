import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tractian_challenge/controllers/companyController.dart';
import 'package:tractian_challenge/models/asset.dart';
import 'package:tractian_challenge/models/assetsScreenModel.dart';
import 'package:tractian_challenge/models/homeScreenModel.dart';
import 'package:tractian_challenge/models/location.dart';

final assetsScreenProvider = ChangeNotifierProvider(
  (ref) => AssetsScreenProvider(),
);

class AssetsScreenProvider extends ValueNotifier<AssetsScreenModel> {
  AssetsScreenProvider()
      : super(
          AssetsScreenModel(isToggledCritic: false, isToggledEnergy: false, baseLocationList: [], visualizationLocationList: []),
        );

  CompanyController companyController = CompanyController();
  List<Location> lListFromAPI = [];
  List<Asset> aListFromAPI = [];

  Future<void> fetchLocationList(String companyId) async {
    value.baseLocationList = await companyController.fetchLocations(companyId);
    List<Asset> assetList = await companyController.fetchAssets(companyId);
    lListFromAPI = value.baseLocationList;
    aListFromAPI = assetList;
    organizeLists(assetList, value.baseLocationList);
    setLists();
    notifyListeners();
  }

  Future<void> searchInList(String text) async {
    List<Asset> aTempList = aListFromAPI.where((element) => element.name.toLowerCase().contains(text)).toList();
    organizeLists(aTempList, value.visualizationLocationList);
    setLists();
    notifyListeners();
  }

  void setLists() {
    Iterable<Location> noChildLocations = value.baseLocationList.where((e) => e.childLocations.isEmpty && e.assetLists.isEmpty);
    Iterable<Location> childLocations = value.baseLocationList.where((e) => e.childLocations.isNotEmpty || e.assetLists.isNotEmpty);
    value.baseLocationList = [...childLocations, ...noChildLocations];
    value.visualizationLocationList = value.baseLocationList;
  }

  void resetList() {
    value.visualizationLocationList = value.baseLocationList;
    notifyListeners();
  }

  void organizeLists(List<Asset> aList, List<Location> lList) {
    for (var location in lList) {
      for (var asset in aList) {
        if (location.id == asset.locationId) {
          location.assetLists.add(asset);
        }
      }
      // Chamada recursiva movida para fora do loop de assets
      organizeLists(aList, location.childLocations);
    }
  }

  toggleEletricButton() {
    value.isToggledEnergy = !value.isToggledEnergy;
    notifyListeners();
  }

  toggleCriticButton() {
    value.isToggledCritic = !value.isToggledCritic;
    notifyListeners();
  }
}
