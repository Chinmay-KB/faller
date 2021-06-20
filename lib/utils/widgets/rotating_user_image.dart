import 'package:faller/utils/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

class RotatingUserImage extends StatelessWidget {
  RotatingUserImage(
      {required this.onTap,
      required this.isOpen,
      required this.offset,
      required this.data,
      required this.radius});

  final Function(int index) onTap;
  final bool isOpen;
  final Offset offset;
  final Map<String, String> data;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: PortalEntry(
        visible: isOpen,
        portalAnchor: Alignment.bottomCenter,
        childAnchor: Alignment.topCenter,
        portal: Material(
          //TODO: Make the dialog into a widget
          child: Container(
            color: Colors.blue,
            width: 120,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text("Here Here"),
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => onTap(int.parse(data['index']!)),
          child: CircularImage(radius),
        ),
      ),
      top: offset.dy,
      left: offset.dx,
    );
  }
}
