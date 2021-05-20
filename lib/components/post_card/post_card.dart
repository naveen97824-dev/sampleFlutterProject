import 'package:sampleFlutterProject/models/postModel.dart';
import 'package:flutter/material.dart';
import './post_card_view.dart';

class PostCard extends StatefulWidget {
  final PostModel storyData;

  const PostCard({Key key, this.storyData}) : super(key: key);
  @override
  PostCardView createState() => new PostCardView();
}
  
