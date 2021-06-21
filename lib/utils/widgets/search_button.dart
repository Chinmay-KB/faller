import 'package:faller/home/home_viewmodel.dart';
import 'package:faller/utils/colors.dart';
import 'package:flutter/material.dart';

/// Widget for search button
class SearchButton extends StatelessWidget {
  /// Holding HomeViewModel reference
  final HomeViewModel model;

  /// Constructor for [SearchButton]
  const SearchButton({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0.8),
      child: ElevatedButton(
        onPressed: () => model.startBang(),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Text('Search',
              style: TextStyle(
                fontSize: 24,
              )),
        ),
        style: ElevatedButton.styleFrom(
            primary: AppColors.searchButtonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24))),
      ),
    );
  }
}
