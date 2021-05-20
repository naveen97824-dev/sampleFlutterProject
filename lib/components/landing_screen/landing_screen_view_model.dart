import 'dart:convert';

import 'package:sampleFlutterProject/actions/storyAction/story_action.dart';
import 'package:sampleFlutterProject/function/dataBaseInitize.dart';
import 'package:sampleFlutterProject/function/utils.dart';
import 'package:sampleFlutterProject/models/bottomNavigationModel.dart';
import 'package:sampleFlutterProject/models/postModel.dart';
import 'package:sampleFlutterProject/states/app_state.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

class LandingScreenViewModel {
  // Add your state and logic here
  Map<int, IconModel> bottomNavigationIcon = Map();
  bool pageLoading = false;
  
  checkForTags(Store<AppState> store) async {
    if (store.state.storyState != null &&
        (store.state.storyState.hashTags == null ||
            (store.state.storyState.hashTags != null &&
                store.state.storyState.hashTags.isEmpty))) {
      String jsonString =
          await rootBundle.loadString('assets/json/hashTag.json');
      final jsonResponse = json.decode(jsonString);
      List<String> hashTagArray = jsonResponse != null
          ? Utils.shared.renderArray(jsonResponse)
          : List();

      store.dispatch(HashTagAction(hashTagArray: hashTagArray));
    }
  }
}
