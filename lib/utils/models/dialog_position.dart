import 'package:flutter/material.dart';

/// PODO for info dialog position
class DialogPosition {
  /// Location of info dialog that should anchor to the planet.
  final Alignment portalAnchor;

  /// Location of planet that should anchor to the info dialog
  final Alignment childAnchor;

  /// Constructor for [DialogPosition]
  DialogPosition({required this.portalAnchor, required this.childAnchor});
}
