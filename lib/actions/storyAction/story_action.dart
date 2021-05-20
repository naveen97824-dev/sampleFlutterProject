

import 'package:sampleFlutterProject/models/postModel.dart';

class UserStoryAction {
  final List<PostModel> userStory;
  UserStoryAction({this.userStory});
}

class SimilarStoryAction {
  final List<PostModel> similarStory;
  SimilarStoryAction({this.similarStory});
}

class FilteredStoryAction {
  final List<PostModel> filteredSimilarStory;
  FilteredStoryAction({this.filteredSimilarStory});
}

class HashTagAction {
  final List<String> hashTagArray;
  HashTagAction({this.hashTagArray});
}
