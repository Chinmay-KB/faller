import 'package:faller/utils/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RotatingUserImage extends StatelessWidget {
  RotatingUserImage(
      {required this.onTap,
      required this.isOpen,
      required this.offset,
      required this.data,
      required this.radius,
      required this.width});

  final Function(int index) onTap;
  final bool isOpen;
  final Offset offset;
  final Map<String?, String?> data;
  final double radius;
  final double width;

  @override
  Widget build(BuildContext context) {
    var dialogPosition = calculateDialogPosition();
    return Positioned(
      child: PortalEntry(
        visible: isOpen,
        portalAnchor: dialogPosition.portalAnchor,
        childAnchor: dialogPosition.childAnchor,
        portal: Material(
          color: Color(0xFF3B366D), borderRadius: BorderRadius.circular(8),
          shadowColor: Color(0xFF9E9ACA),
          elevation: 2,

          //TODO: Make the dialog into a widget
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name']!,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          data['info']!,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RatingBar.builder(
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                      ),
                      itemSize: 18,
                      onRatingUpdate: (_) => null,
                      itemCount: 5,
                      initialRating: int.parse(data['rating']!) * 1.0,
                      direction: Axis.horizontal,
                    ),
                  )
                ],
              ),
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

  DialogPosition calculateDialogPosition() {
    double x = offset.dx;
    if (data['index'] == '-1')
      return DialogPosition(
        portalAnchor: Alignment.bottomCenter,
        childAnchor: Alignment.topCenter,
      );
    if (x < width / 2)
      return DialogPosition(
        portalAnchor: Alignment.centerLeft,
        childAnchor: Alignment.centerRight,
      );
    else
      return DialogPosition(
        portalAnchor: Alignment.centerRight,
        childAnchor: Alignment.centerLeft,
      );
  }
}

class DialogPosition {
  final Alignment portalAnchor, childAnchor;
  DialogPosition({required this.portalAnchor, required this.childAnchor});
}
