import 'package:sampleFlutterProject/reducers/bottomNav/bottom_navigation_reducer.dart';
import 'package:sampleFlutterProject/reducers/storyReducer/storyReducer.dart';
import 'package:sampleFlutterProject/states/app_state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    bottomNavigationState:
        bottomNavigationReducer(state.bottomNavigationState, action),
    storyState: storyReducer(state.storyState, action),
  );
}
