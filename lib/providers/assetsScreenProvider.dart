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
    value.isToggledCritic = false;
    value.isToggledEnergy = false;
    value.isToggledVibration = false;
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

  //? Métodos que filtram a arvore de assets
  void filterLocations(String search) {
    search = search.toLowerCase(); // Normaliza a string de busca para comparação case-insensitive
    value.visualizationLocationList = _filterLocationsRecursive(value.baseLocationList, search);
    notifyListeners();
  }

  List<Location> _filterLocationsRecursive(List<Location> locations, String search) {
    List<Location> filteredList = [];

    for (var location in locations) {
      bool matchesQuery = location.name.toLowerCase().contains(search);

      // Filtra a lista de assets desta localização, incluindo subAssets recursivamente
      List<Asset> filteredAssets = _filterAssetsRecursive(location.assetLists, search);

      // Filtra a lista de child locations recursivamente
      List<Location> filteredChildLocations = _filterLocationsRecursive(location.childLocations, search);

      // Adiciona à lista filtrada se a localização, seus assets ou filhos correspondem ao critério de busca
      if ((matchesQuery && (filteredAssets.isNotEmpty || filteredChildLocations.isNotEmpty)) || filteredAssets.isNotEmpty || filteredChildLocations.isNotEmpty) {
        location = Location(
          id: location.id,
          name: location.name,
          parentId: location.parentId,
          childLocations: filteredChildLocations,
          assetLists: filteredAssets,
        );
        filteredList.add(location);
      }
    }

    return filteredList;
  }

  List<Asset> _filterAssetsRecursive(List<Asset> assets, String search) {
    List<Asset> filteredList = [];

    for (var asset in assets) {
      bool matchesQuery = asset.name.toLowerCase().contains(search);

      // Verifica os filtros adicionais
      bool matchesCritic = !value.isToggledCritic || asset.status == "alert";
      bool matchesEnergy = !value.isToggledEnergy || asset.sensorType == "energy";
      bool matchesVibration = !value.isToggledVibration || asset.sensorType == "vibration";

      // Filtra a lista de subAssets recursivamente
      List<Asset> filteredSubAssets = _filterAssetsRecursive(asset.assetList, search);

      // Adiciona à lista filtrada se o asset ou seus subAssets correspondem ao critério de busca e filtros
      if ((matchesQuery || search.isEmpty) && matchesCritic && matchesVibration && matchesEnergy || filteredSubAssets.isNotEmpty) {
        asset = Asset(
          id: asset.id,
          name: asset.name,
          locationId: asset.locationId,
          assetList: filteredSubAssets,
          parentId: asset.parentId,
          sensorType: asset.sensorType,
          status: asset.status,
        );
        filteredList.add(asset);
      }
    }

    return filteredList;
  }

  //! ---------------------------------------------------------------------------------------------------- !//
  //! Botões da Tela

  filtterButton(String text) {
    filterLocations(text);
  }

  toggleEletricButton(String currenttext) {
    value.isToggledEnergy = !value.isToggledEnergy;
    if (value.isToggledEnergy) {
      filtterButton(currenttext);
    }
    notifyListeners();
  }

  toggleCriticButton(String currenttext) {
    value.isToggledCritic = !value.isToggledCritic;
    if (value.isToggledCritic) {
      filtterButton(currenttext);
    }
    notifyListeners();
  }

  toggleVibrationButton(String currenttext) {
    value.isToggledVibration = !value.isToggledVibration;
    if (value.isToggledVibration) {
      filtterButton(currenttext);
    }
    notifyListeners();
  }
}
