import 'package:faller/utils/models/dialog_position.dart';
import 'package:faller/utils/widgets/circular_image.dart';
import 'package:faller/utils/widgets/info_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

/// Widget to show planets rotating on orbits
class PlanetWidget extends StatelessWidget {
  /// Constructor for [PlanetWidget]
  const PlanetWidget(
      {required this.onTap,
      required this.isOpen,
      required this.offset,
      required this.data,
      required this.radius,
      required this.width,
      required this.image,
      Key? key})
      : super(key: key);

  /// Callback for when planet is tapped
  final Function(int index) onTap;

  /// Returns `true` if info dialog is open
  final bool isOpen;

  /// Position of planet along the orbit
  final Offset offset;

  /// Additional data paylaod associated with the planet
  final Map<String?, String?> data;

  /// Radius of the image shown
  final double radius;

  /// Screen width used to calculate the position of info dialog
  final double width;

  /// Circular image shown in the planet
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    var dialogPosition = calculateDialogPosition();
    return Positioned(
      child: PortalEntry(
        visible: isOpen,
        portalAnchor: dialogPosition.portalAnchor,
        childAnchor: dialogPosition.childAnchor,
        portal: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFF3B366D),
            borderRadius: BorderRadius.circular(8),
            shadowColor: const Color(0xFF9E9ACA),
            elevation: 2,
            child: InfoDialog(data: data),
          ),
        ),
        child: GestureDetector(
          onTap: () => onTap(int.parse(data['index']!)),
          child: CircularImage(radius, image),
        ),
      ),
      top: offset.dy,
      left: offset.dx,
    );
  }

  /// Determines info dialog position depending on which screen edge is closer to
  /// the planet
  DialogPosition calculateDialogPosition() {
    double x = offset.dx;
    if (data['index'] == '-1') {
      return DialogPosition(
        portalAnchor: Alignment.bottomCenter,
        childAnchor: Alignment.topCenter,
      );
    }
    if (x < width / 2) {
      return DialogPosition(
        portalAnchor: Alignment.centerLeft,
        childAnchor: Alignment.centerRight,
      );
    } else {
      return DialogPosition(
        portalAnchor: Alignment.centerRight,
        childAnchor: Alignment.centerLeft,
      );
    }
  }
}
