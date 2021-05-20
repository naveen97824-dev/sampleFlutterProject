import 'package:flutter/material.dart';

@immutable
class BottomNavigationState {
  @required
  final int selectedIndex;

  BottomNavigationState({this.selectedIndex});

  BottomNavigationState copyWith({int prevIndex, int selectedIndex}) {
    return new BottomNavigationState(
      selectedIndex: selectedIndex == null ? this.selectedIndex : selectedIndex,
    );
  }

  /// initial data when bottom navigation bar doesnt have any choices done on the app, during first time load
  factory BottomNavigationState.initial() {
    return new BottomNavigationState(selectedIndex: 0);
  }

  /// converts json data to BottomNavState object
  static BottomNavigationState fromJson(dynamic json) {
    if (json != null && json["selectedIndex"] is int)
      return BottomNavigationState(
        selectedIndex: json["selectedIndex"] as int,
      );
    else
      return BottomNavigationState(selectedIndex: 0);
  }

  /// converts BottomNavState object to json data to store in database
  dynamic toJson() => {
        'selectedIndex': selectedIndex,
      };
}
