import 'package:sampleFlutterProject/function/utils.dart';
import 'package:sampleFlutterProject/models/postModel.dart';

class StoryState {
  List<PostModel> userStory;
  List<PostModel> similarStory;
  List<PostModel> filteredSimilarStory;
  List<String> hashTags;

  StoryState(
      {this.filteredSimilarStory,
      this.similarStory,
      this.userStory,
      this.hashTags});

  StoryState copyWith(
      {List<PostModel> userStory,
      List<PostModel> similarStory,
      List<PostModel> filteredSimilarStory,
      List<String> hashTag}) {
    return new StoryState(
        filteredSimilarStory: filteredSimilarStory,
        similarStory: similarStory,
        userStory: userStory,
        hashTags: hashTag);
  }

  /// initial data when bottom navigation bar doesnt have any choices done on the app, during first time load
  factory StoryState.initial() {
    return new StoryState(
        filteredSimilarStory: null, similarStory: null, userStory: null);
  }

  /// converts json data to BottomNavState object
  static StoryState fromJson(dynamic json) {
    return StoryState(
      filteredSimilarStory: json['filteredSimilarStory'] != null
          ? Utils.shared.renderArray(json['filteredSimilarStory'],
              A: PostModel,
              obj: new List<PostModel>.filled(
                  (json['filteredSimilarStory'] as List).length,
                  new PostModel(),
                  growable: false))
          : null,
      similarStory: json['similarStory'] != null
          ? Utils.shared.renderArray(json['similarStory'],
              A: PostModel,
              obj: new List<PostModel>.filled(
                  (json['similarStory'] as List).length, new PostModel(),
                  growable: false))
          : null,
      userStory: json['userStory'] != null
          ? Utils.shared.renderArray(json['userStory'],
              A: PostModel,
              obj: new List<PostModel>.filled(
                  (json['userStory'] as List).length, new PostModel(),
                  growable: false))
          : null,
      hashTags: json['hashTags'] != null
          ? Utils.shared.renderArray(json['hashTags'])
          : List(),
    );
  }

  /// converts BottomNavState object to json data to store in database
  dynamic toJson() => {
        'hashTags': hashTags,
        // 'selectedIndex': selectedIndex,
      };
}
