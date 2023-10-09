import 'package:flutter/material.dart';

class FaceIdModel extends ChangeNotifier {
  String? _faceId;

  String? get faceId => _faceId;

  void setFaceId(String? id) {
    _faceId = id;
    notifyListeners();
  }

  void clearFaceId() {
    _faceId = null;
    notifyListeners();
  }
}
