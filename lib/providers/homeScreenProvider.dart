import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tractian_challenge/controllers/companyController.dart';
import 'package:tractian_challenge/models/homeScreenModel.dart';

final homeScreenProvider = ChangeNotifierProvider(
  (ref) => HomeScreenProvider(),
);

class HomeScreenProvider extends ValueNotifier<HomeScreenModel> {
  HomeScreenProvider() : super(HomeScreenModel(companiesList: []));

  CompanyController companyController = CompanyController();

  Future<void> fetchCompanies() async {
    value.companiesList = await companyController.fetchCompanies();
    notifyListeners();
  }
}
