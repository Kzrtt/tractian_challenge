import 'package:flutter/material.dart';
import 'package:tractian_challenge/models/asset.dart';
import 'package:tractian_challenge/models/location.dart';

class CustomExpansionTile extends StatefulWidget {
  Location location;
  double leftPadding;
  Widget Function(Location location, {double leftPadding}) buildTile;
  Widget Function(Asset asset, {double leftPadding}) buildAssetTile;

  CustomExpansionTile({
    super.key,
    required this.location,
    required this.leftPadding,
    required this.buildTile,
    required this.buildAssetTile,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
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
            widget.location.name,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
      leading: Icon(
        _isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
        size: _isExpanded ? 20 : 12,
      ),
      trailing: const SizedBox.shrink(),
      tilePadding: EdgeInsets.only(left: widget.leftPadding),
      children: [
        ...widget.location.childLocations.map((e) => widget.buildTile(e, leftPadding: 16 + widget.leftPadding)),
        ...widget.location.assetLists.map((e) => widget.buildAssetTile(e, leftPadding: 16 + widget.leftPadding)),
      ],
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
    );
  }
}
