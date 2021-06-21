import 'package:faller/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final HomeViewModel model;
  const SearchButton({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0.8),
      child: ElevatedButton(
        onPressed: () => model.startBang(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Text('Search',
              style: TextStyle(
                fontSize: 24,
              )),
        ),
        style: ElevatedButton.styleFrom(
            primary: Color(0xffE5707E),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24))),
      ),
    );
  }
}
