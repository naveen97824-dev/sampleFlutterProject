import 'dart:convert';
import 'dart:math';

import 'package:sampleFlutterProject/function/dataBaseInitize.dart';
import 'package:sampleFlutterProject/models/postModel.dart';
import 'package:flutter/services.dart';

class DataInsertion {
  static DataInsertion shared = DataInsertion();

  userStory() async {
    Random random = new Random();
    String jsonString = await rootBundle.loadString('assets/json/data.json');
    final jsonResponse = json.decode(jsonString);
    List<dynamic> stories = jsonResponse;
    print(stories.length);
    stories.forEach((eachStory) {
      PostModel singlePost = new PostModel(
          mediaUrl: eachStory["mediaUrl"],
          isUserStory: eachStory["isUserStory"],
          likeCount: eachStory["likeCount"],
          commentCount: eachStory["commentCount"],
          date: (DateTime.now().subtract(Duration(days: random.nextInt(100))))
              .toLocal()
              .toString(),
          hashTag: eachStory["hashTag"]);
      insertToDb(singlePost);
    });
  }

  insertToDb(PostModel story) async {
    await StoryDatabase.instance.create(story);
  }
}
