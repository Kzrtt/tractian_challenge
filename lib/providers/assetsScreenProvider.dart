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
          AssetsScreenModel(
            isToggledCritic: false,
            isToggledEnergy: false,
            isToggledVibration: false,
            baseLocationList: [],
            visualizationLocationList: [],
          ),
        );

  CompanyController companyController = CompanyController();

  //? Método que carrega as listas no provider
  Future<void> fetchLocationList(String companyId) async {
    value.baseLocationList = await companyController.fetchLocations(companyId);
    List<Asset> assetList = await companyController.fetchAssets(companyId);
    organizeLists(assetList, value.baseLocationList);
    Iterable<Location> noChildLocations = value.baseLocationList.where((e) => e.childLocations.isEmpty && e.assetLists.isEmpty);
    Iterable<Location> childLocations = value.baseLocationList.where((e) => e.childLocations.isNotEmpty || e.assetLists.isNotEmpty);
    value.baseLocationList = [...childLocations, ...noChildLocations];
    value.visualizationLocationList = value.baseLocationList;
    notifyListeners();
  }

  //? Método para limpar a busca
  void resetList() {
    value.visualizationLocationList = value.baseLocationList;
    notifyListeners();
  }

  //? Método que vincula o asset ao local
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

  //? Métodos da busca por texto
  void filterLocations(String text, String btnType, String val) {
    String searchQuery = text.toLowerCase();
    if (text != "") {
      value.visualizationLocationList = value.visualizationLocationList.where((location) {
        return _applySearchFilter(location, searchQuery);
      }).toList();
    }
    if (val != "" && btnType != "") {
      value.visualizationLocationList = value.visualizationLocationList.where((location) {
        return _applySearchFilterViaButton(location, btnType, val);
      }).toList();
    }
    notifyListeners();
  }

  bool _applySearchFilter(Location location, String query) {
    bool response = false;
    if (location.name.toLowerCase().contains(query)) {
      response = true;
    }
    for (var asset in location.assetLists) {
      if (asset.name.toLowerCase().contains(query)) {
        response = true;
      } else {
        response = validateAssets(asset.assetList, query);
      }
    }
    for (var child in location.childLocations) {
      if (_applySearchFilter(child, query)) {
        response = true;
      }
    }
    return response;
  }

  bool validateAssets(List<Asset> assetList, String text) {
    for (var asset in assetList) {
      if (asset.name.toLowerCase().contains(text)) {
        return true;
      }
      if (asset.assetList.isNotEmpty) {
        validateAssets(asset.assetList, text);
      }
    }
    return false;
  }

  //! -------------------------------------------------------------------------- !//

  //? Métodos de busca para os botões
  bool _applySearchFilterViaButton(Location location, String btnType, String val) {
    bool response = false;
    if (btnType == "sensorType") {
      for (var asset in location.assetLists) {
        if (asset.sensorType.toLowerCase().contains(val)) {
          response = true;
        } else {
          response = validateAssetsViaButton(asset.assetList, btnType, val);
        }
      }
      for (var child in location.childLocations) {
        if (_applySearchFilterViaButton(child, btnType, val)) {
          response = true;
        }
      }
    } else if (btnType == "status") {
      for (var asset in location.assetLists) {
        if (asset.status.toLowerCase().contains(val)) {
          response = true;
        } else {
          response = validateAssetsViaButton(asset.assetList, btnType, val);
        }
      }
      for (var child in location.childLocations) {
        if (_applySearchFilterViaButton(child, btnType, val)) {
          response = true;
        }
      }
    }
    return response;
  }

  bool validateAssetsViaButton(List<Asset> assetList, String btnType, String val) {
    for (var asset in assetList) {
      if (btnType == "sensorType") {
        if (asset.sensorType.toLowerCase().contains(val)) {
          return true;
        }
      } else if (btnType == "status") {
        if (asset.status.toLowerCase().contains(val)) {
          return true;
        }
      }
      if (asset.assetList.isNotEmpty) {
        validateAssetsViaButton(asset.assetList, btnType, val);
      }
    }
    return false;
  }

  toggleEletricButton() {
    value.isToggledEnergy = !value.isToggledEnergy;
    if (value.isToggledEnergy) {
      filterLocations("", "sensorType", "energy");
    } else {
      resetList();
    }
    notifyListeners();
  }

  toggleCriticButton() {
    value.isToggledCritic = !value.isToggledCritic;
    if (value.isToggledCritic) {
      filterLocations("", "status", "alert");
    } else {
      resetList();
    }
    notifyListeners();
  }

  toggleVibrationButton() {
    value.isToggledVibration = !value.isToggledVibration;
    if (value.isToggledVibration) {
      filterLocations("", "sensorType", "vibration");
    } else {
      resetList();
    }
    notifyListeners();
  }
}
