import 'package:tractian_challenge/models/asset.dart';

class Location {
  String id;
  String name;
  String parentId;
  List<Location> childLocations;
  List<Asset> assetLists;

  Location({
    required this.id,
    required this.name,
    required this.parentId,
    required this.childLocations,
    required this.assetLists,
  });

  static fromJson(Map<String, dynamic> data) {
    return Location(
      id: data['id'],
      name: data['name'],
      parentId: data['parentId'] ?? "",
      childLocations: [],
      assetLists: [],
    );
  }
}
