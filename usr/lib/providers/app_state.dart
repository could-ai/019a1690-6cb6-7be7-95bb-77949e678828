import 'package:flutter/material.dart';
import '../models/profile.dart';

class AppState extends ChangeNotifier {
  List<Profile> matches = [];

  void addMatch(Profile profile) {
    matches.add(profile);
    notifyListeners();
  }

  void removeLastMatch() {
    if (matches.isNotEmpty) {
      matches.removeLast();
      notifyListeners();
    }
  }
}
