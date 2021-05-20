import 'package:sampleFlutterProject/actions/storyAction/story_action.dart';
import 'package:sampleFlutterProject/states/storyState/storyState.dart';

StoryState storyReducer(StoryState state, dynamic action) {
  if (action is UserStoryAction) {
    return state.copyWith(
        userStory: action.userStory,
        filteredSimilarStory: state.filteredSimilarStory,
        similarStory: state.similarStory,
        hashTag: state.hashTags);
  }
  if (action is SimilarStoryAction) {
    return state.copyWith(
        userStory: state.userStory,
        filteredSimilarStory: state.filteredSimilarStory,
        similarStory: action.similarStory,
        hashTag: state.hashTags);
  }
  if (action is FilteredStoryAction) {
    return state.copyWith(
        userStory: state.userStory,
        filteredSimilarStory: action.filteredSimilarStory,
        similarStory: state.similarStory,
        hashTag: state.hashTags);
  }

  if (action is HashTagAction) {
    return state.copyWith(
        userStory: state.userStory,
        filteredSimilarStory: state.filteredSimilarStory,
        similarStory: state.similarStory,
        hashTag: action.hashTagArray);
  }
  return state;
}
