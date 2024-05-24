import 'package:dio/dio.dart';
import 'package:tractian_challenge/models/asset.dart';
import 'package:tractian_challenge/models/company.dart';
import 'package:tractian_challenge/models/location.dart';

class CompanyController {
  Future<List<Company>> fetchCompanies() async {
    List<Company> companiesList = [];
    try {
      var response = await Dio().get("https://fake-api.tractian.com/companies");
      for (var element in response.data) {
        companiesList.add(Company.fromJson(element));
      }
    } catch (e) {
      throw Error();
    }
    return companiesList;
  }

  Future<List<Asset>> fetchAssets(String companyId) async {
    List<Asset> assetList = [];
    try {
      var response = await Dio().get("https://fake-api.tractian.com/companies/$companyId/assets");
      for (var json in response.data) {
        Asset asset = Asset.fromJson(json);
        if (asset.parentId == "") {
          assetList.add(asset);
        }
      }

      for (var json in response.data) {
        Asset asset = Asset.fromJson(json);
        if (asset.parentId != "") {
          for (var element in assetList) {
            if (asset.parentId == element.id) {
              element.assetList.add(asset);
            }
          }
        }
      }

      Iterable<Asset> noChildAssets = assetList.where((element) => element.assetList.isEmpty);
      Iterable<Asset> childAssets = assetList.where((element) => element.assetList.isNotEmpty);
      assetList = [...noChildAssets, ...childAssets];
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
    return assetList;
  }

  Future<List<Location>> fetchLocations(String companyId) async {
    List<Location> locationList = [];
    try {
      var response = await Dio().get("https://fake-api.tractian.com/companies/$companyId/locations");
      for (var json in response.data) {
        Location location = Location.fromJson(json);
        if (location.parentId == "") {
          locationList.add(location);
        }
      }

      for (var json in response.data) {
        Location location = Location.fromJson(json);
        if (location.parentId != "") {
          for (var element in locationList) {
            if (location.parentId == element.id) {
              element.childLocations.add(location);
            }
          }
        }
      }

      Iterable<Location> noChildLocations = locationList.where((element) => element.childLocations.isEmpty);
      Iterable<Location> childLocations = locationList.where((element) => element.childLocations.isNotEmpty);
      locationList = [...childLocations, ...noChildLocations];
    } catch (e) {
      print(e);
      throw Error();
    }
    return locationList;
  }
}
