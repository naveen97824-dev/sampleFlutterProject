import 'package:sampleFlutterProject/states/bottomNavigationState/bottomNavigationState.dart';
import 'package:sampleFlutterProject/states/storyState/storyState.dart';
import 'package:flutter/material.dart';

@immutable
class AppState {
  // final UserState userState;
  // final CartState cartState;
  // final ProductListState productListState;
  // final LocationState locationState;
  // final OffersState offersState;
  final StoryState storyState;
  final BottomNavigationState bottomNavigationState;

  AppState({
    this.bottomNavigationState,
    this.storyState,
    // this.productListState,
    // this.cartState,
    // this.locationState,
    // this.offersState,
    // this.configState
  });

  ///loads the default value when the app is first opened and no data available in database
  factory AppState.initial() {
    return new AppState(
      bottomNavigationState: BottomNavigationState.initial(),
      storyState: StoryState.initial(),
      // cartState: CartState.initial(),
      // productListState: ProductListState.initial(),
      // locationState: LocationState.initial(),
      // offersState: OffersState.initial(),
      // configState: ConfigState.initial()
    );
  }

  /// loads the data back to AppState Object from json
  static AppState fromJson(dynamic json) {
    return AppState(
      bottomNavigationState:
          (json != null && json["bottomNavigationState"] != null)
              ? BottomNavigationState.fromJson(json["bottomNavigationState"])
              : BottomNavigationState.initial(),
      storyState: (json != null && json["storyState"] != null)
          ? StoryState.fromJson(json["storyState"])
          : StoryState.initial(),
      // productListState: (json != null && json["productListState"] != null)
      //     ? ProductListState.fromJson(json["productListState"])
      //     : ProductListState.initial(),
      // locationState: (json != null && json["locationState"] != null)
      //     ? LocationState.fromJson(json["locationState"])
      //     : LocationState.initial(),
      // offersState: (json != null && json["offersState"] != null)
      //     ? OffersState.fromJson(json["offersState"])
      //     : OffersState.initial(),
      // configState:  (json != null && json["configState"] != null)
      //     ? ConfigState.fromJson(json["configState"])
      //     : ConfigState.initial(),
    );
  }

  /// converts data of AppState model object to json data, used to store data in database
  dynamic toJson() => {
        'bottomNavigationState': bottomNavigationState != null
            ? bottomNavigationState.toJson()
            : null,
        'storyState': storyState != null ? storyState.toJson() : null,
        // 'cartState': cartState != null ? cartState.toJson() : null,
        // 'locationState': locationState != null ? locationState.toJson() : null,
        // 'productListState':
        //     productListState != null ? productListState.toJson() : null,
        // 'offersState': offersState != null ? offersState.toJson() : null,
        // 'configState': configState != null ? configState.toJson() : null
      };
}
