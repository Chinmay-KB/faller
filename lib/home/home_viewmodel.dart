import 'package:stacked/stacked.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/services.dart';

class HomeViewModel extends BaseViewModel {
  late UI.Image _image;

  UI.Image get image => _image;

  init() async {
    setBusy(true);
    _image = await loadUiImage('assets/bean.png');
    setBusy(false);
  }

  Future<UI.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<UI.Image> completer = Completer();
    UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}
