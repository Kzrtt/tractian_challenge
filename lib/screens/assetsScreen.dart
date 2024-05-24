import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tractian_challenge/components/buttonWithIcon.dart';
import 'package:tractian_challenge/components/customAssetExpansionTile.dart';
import 'package:tractian_challenge/components/customExpasionTile.dart';
import 'package:tractian_challenge/models/asset.dart';
import 'package:tractian_challenge/models/location.dart';
import 'package:tractian_challenge/providers/assetsScreenProvider.dart';

class AssetsScreen extends ConsumerStatefulWidget {
  String companyId;

  AssetsScreen({
    super.key,
    required this.companyId,
  });

  @override
  _AssetsScreenState createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen> {
  TextEditingController searchController = TextEditingController();

  Widget buildAssetTile(Asset asset, {double leftPadding = 16}) {
    if (asset.assetList.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.only(left: leftPadding + 42),
        title: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                "assets/component.png",
              ),
            ),
            const SizedBox(width: 10),
            Text(
              asset.name,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            asset.sensorType == "energy"
                ? const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.bolt_outlined,
                        color: Colors.green,
                        size: 18,
                      ),
                    ],
                  )
                : asset.sensorType == "vibration"
                    ? const Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(
                            Icons.vibration_outlined,
                            color: Colors.green,
                            size: 18,
                          ),
                        ],
                      )
                    : const Center(),
            asset.status != "alert"
                ? const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 16,
                      ),
                    ],
                  )
                : const Center(),
          ],
        ),
      );
    } else {
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: CustomAssetExpansionTile(
          asset: asset,
          leftPadding: leftPadding,
          buildTile: buildAssetTile,
        ),
      );
    }
  }

  Widget buildTile(Location location, {double leftPadding = 16}) {
    if (location.childLocations.isEmpty && location.assetLists.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.only(left: leftPadding),
        title: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                "assets/location.png",
              ),
            ),
            const SizedBox(width: 10),
            Text(
              location.name,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: CustomExpansionTile(
          location: location,
          leftPadding: leftPadding,
          buildTile: buildTile,
          buildAssetTile: buildAssetTile,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Chama fetchCompanies quando o widget for inicializado
    ref.read(assetsScreenProvider).fetchLocationList(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    final screenProvider = ref.read(assetsScreenProvider.notifier);
    final screenModel = ref.watch(assetsScreenProvider).value;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(23, 25, 45, 1),
            centerTitle: true,
            title: const Text(
              "Assets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: InkWell(
              onTap: () => GoRouter.of(context).pop(),
              child: const SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 90,
                    width: constraints.maxWidth * .95,
                    child: TextFormField(
                      controller: searchController,
                      onChanged: (value) {
                        if (value != "") {
                          ref.read(assetsScreenProvider).searchInList(value);
                        } else {
                          ref.read(assetsScreenProvider).resetList();
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(.2),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        hintText: "Buscar Ativo ou Local",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWithIcon(
                          buttonText: "Sensor de Energia",
                          height: 40,
                          width: 200,
                          borderRadius: 10,
                          onTap: () => screenProvider.toggleEletricButton(),
                          icon: Icons.bolt_outlined,
                          iconSize: 25,
                          textColor: screenModel.isToggledEnergy ? Colors.blue : Colors.grey,
                          iconColor: screenModel.isToggledEnergy ? Colors.blue : Colors.grey,
                          borderColor: screenModel.isToggledEnergy ? Colors.blue : Colors.grey,
                          buttonColor: Colors.transparent,
                        ),
                        ButtonWithIcon(
                          buttonText: "Critico",
                          height: 40,
                          width: 150,
                          borderRadius: 10,
                          onTap: () => screenProvider.toggleCriticButton(),
                          icon: Icons.error_outline,
                          iconSize: 25,
                          textColor: screenModel.isToggledCritic ? Colors.red : Colors.grey,
                          iconColor: screenModel.isToggledCritic ? Colors.red : Colors.grey,
                          borderColor: screenModel.isToggledCritic ? Colors.red : Colors.grey,
                          buttonColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  screenModel.visualizationLocationList.isEmpty
                      ? screenModel.baseLocationList.isEmpty
                          ? const Column(
                              children: [
                                SizedBox(height: 100),
                                CircularProgressIndicator(
                                  color: Color.fromRGBO(23, 25, 45, 1),
                                ),
                              ],
                            )
                          : const Text("Sem Resultados para busca...")
                      : Expanded(
                          child: ListView(
                            children: screenModel.visualizationLocationList.map((e) => buildTile(e)).toList(),
                          ),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
