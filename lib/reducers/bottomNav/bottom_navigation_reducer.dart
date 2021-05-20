import 'package:sampleFlutterProject/actions/bottomNavigation/bottom_navigation_action.dart';
import 'package:sampleFlutterProject/states/bottomNavigationState/bottomNavigationState.dart';

BottomNavigationState bottomNavigationReducer(
    BottomNavigationState state, dynamic action) {
  if (action is BottomNavigationAction) {
    return state.copyWith(selectedIndex: action.selectedIndex);
  }
  return state;
}
