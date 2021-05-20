/// Event for switching selected index of the bottom nav section in home screen of the app
class BottomNavigationAction {
  final int selectedIndex;
  BottomNavigationAction({this.selectedIndex});
}

/// Event for visibility of bottom navigation on the home screen of the app
class BottomNavigationVisibilityAction {
  final bool showNav;
  BottomNavigationVisibilityAction({this.showNav});
}
