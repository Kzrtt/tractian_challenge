import 'package:flutter/material.dart';
import 'package:tractian_challenge/models/asset.dart';

class CustomAssetExpansionTile extends StatefulWidget {
  Asset asset;
  double leftPadding;
  Widget Function(Asset asset, {double leftPadding}) buildTile;

  CustomAssetExpansionTile({
    super.key,
    required this.asset,
    required this.leftPadding,
    required this.buildTile,
  });

  @override
  State<CustomAssetExpansionTile> createState() => _CustomAssetExpansionTileState();
}

class _CustomAssetExpansionTileState extends State<CustomAssetExpansionTile> {
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
              "assets/asset.png",
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.asset.name,
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
        ...widget.asset.assetList.map((e) => widget.buildTile(e, leftPadding: 16 + widget.leftPadding)),
      ],
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
    );
  }
}
