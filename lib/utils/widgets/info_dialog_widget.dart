import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Widget for showing info about a planet
class InfoDialog extends StatelessWidget {
  /// Constructor for [InfoDialog]
  const InfoDialog({
    Key? key,
    required this.data,
  }) : super(key: key);

  /// Data payload associated with the planet
  final Map<String?, String?> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  data['info']!,
                  style: const TextStyle(
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
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amberAccent,
              ),
              itemSize: 18,
              onRatingUpdate: (_) => {},
              ignoreGestures: true,
              itemCount: 5,
              initialRating: int.parse(data['rating']!) * 1.0,
              direction: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }
}
