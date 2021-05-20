import 'package:sampleFlutterProject/actions/storyAction/story_action.dart';
import 'package:sampleFlutterProject/components/home_page/home_page.dart';
import 'package:sampleFlutterProject/components/post_card/post_card.dart';
import 'package:sampleFlutterProject/function/dataBaseInitize.dart';
import 'package:sampleFlutterProject/function/size_config.dart';
import 'package:sampleFlutterProject/models/postModel.dart';
import 'package:sampleFlutterProject/states/app_state.dart';
import 'package:sampleFlutterProject/states/storyState/storyState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import './home_page_view_model.dart';
import 'package:redux/redux.dart';

class HomePageView extends State<HomePage> {
  HomePageViewModel model;
  Store<AppState> store1;

  HomePageView() {
    model = new HomePageViewModel();
  }
  List<PostModel> allStories, userStories, similarStories, filteredBasedOnTags;
  @override
  void initState() {
    super.initState();
  }

  getDataFromDb() async {
    allStories = [];
    userStories = [];
    similarStories = [];
    filteredBasedOnTags = [];
    // allStories = await StoryDatabase.instance.readAllStories();
    userStories = await StoryDatabase.instance.readUserStories();
    similarStories = await StoryDatabase.instance.readSimilarStories();
    store1.dispatch(UserStoryAction(userStory: userStories));
    store1.dispatch(SimilarStoryAction(similarStory: similarStories));
    store1.dispatch(FilteredStoryAction(filteredSimilarStory: similarStories));
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: topBar(),
        ),
        body: StoreConnector<AppState, StoryState>(onInit: (store) {
          store1 = store;
          getDataFromDb();

          if (store.state.storyState != null &&
              store.state.storyState.hashTags != null &&
              store.state.storyState.hashTags.isNotEmpty) {
            model.hashTag.addAll(store.state.storyState.hashTags);
          }
        }, converter: (store) {
          return store.state.storyState;
        }, builder: (storecontext, storyState) {
          return scrollableSection();
        }),
      ),
    );
  }

  Widget scrollableSection() {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: searchArea(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: hashTagSection(),
          ),
          Container(
            height: (MediaQuery.of(context).size.width < 600)
                ? (MediaQuery.of(context).size.width) / 1.7
                : 300,
            child: yourPostSection(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: similarPostSection(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: (store1.state.storyState != null &&
                      store1.state.storyState.filteredSimilarStory != null &&
                      store1.state.storyState.filteredSimilarStory.isNotEmpty)
                  ? store1.state.storyState.filteredSimilarStory
                      .asMap()
                      .map((key, value) => MapEntry(
                          key,
                          Container(
                            height: (MediaQuery.of(context).size.width < 600)
                                ? (MediaQuery.of(context).size.width - 40) / 2
                                : 275,
                            width: (MediaQuery.of(context).size.width < 600)
                                ? (MediaQuery.of(context).size.width - 40) / 2
                                : 275,
                            child: PostCard(
                              storyData: value,
                            ),
                          )))
                      .values
                      .toList()
                  : [new Container()],
            ),
          ),
        ],
      ),
    );
  }

  Widget similarPostSection() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // scrollDirection: Axis.horizontal,
        children: [
          Container(
              child: Text("Similar posts",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ))),
          Container(
            child: Text(
                "${(store1.state.storyState != null && store1.state.storyState.filteredSimilarStory != null && store1.state.storyState.filteredSimilarStory.isNotEmpty) ? (store1.state.storyState.filteredSimilarStory.length).toString() : '0'} ${(store1.state.storyState != null && store1.state.storyState.filteredSimilarStory != null && store1.state.storyState.filteredSimilarStory.isNotEmpty && store1.state.storyState.filteredSimilarStory.length > 1) ? 'Posts' : 'Post'}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }

  Widget yourPostSection() {
    return Container(
      margin: EdgeInsets.only(left: 15),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text("Your posts",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ))),
          Expanded(
            child: ListView(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: (store1.state?.storyState?.userStory != null &&
                        store1.state.storyState.userStory.isNotEmpty)
                    ? store1.state.storyState.userStory
                        .asMap()
                        .map(
                          (key, value) => MapEntry(
                            key,
                            Container(
                              height: (MediaQuery.of(context).size.width < 600)
                                  ? (MediaQuery.of(context).size.width - 40) / 2
                                  : 275,
                              width: (MediaQuery.of(context).size.width < 600)
                                  ? (MediaQuery.of(context).size.width - 40) / 2
                                  : 275,
                              margin: EdgeInsets.only(right: 15),
                              child: PostCard(
                                storyData: value,
                              ),
                            ),
                          ),
                        )
                        .values
                        .toList()
                    : [new Container()]),
          ),
        ],
      ),
    );
  }

  Widget hashTagSection() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: (model.hashTag.isNotEmpty)
                ? Text(
                    "Hashtags : ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : new Container(),
          ),
          Expanded(
            child: Wrap(
              children: model.hashTag
                  .asMap()
                  .map((key, value) => MapEntry(
                      key,
                      FittedBox(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: InkWell(
                              onTap: () async {
                                if (mounted) {
                                  setState(() {
                                    model.choosenFilter.add(value);
                                    model.hashTag.removeWhere(
                                        (eachTag) => eachTag == value);
                                  });
                                }
                                filteredBasedOnTags = await StoryDatabase
                                    .instance
                                    .readBasedOnHashTagStories(
                                        model.choosenFilter);
                                store1.dispatch(FilteredStoryAction(
                                    filteredSimilarStory: filteredBasedOnTags));
                              },
                              child: chips(value, false)),
                        ),
                      )))
                  .values
                  .toList(),
              // [
              //   chips("Cheese", false),
              // ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchArea() {
    return Container(
      // height: 40,
      padding: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: 15,
        ),
        child: Container(
          child: Wrap(
            runSpacing: 6,
            children: (model.choosenFilter != null &&
                    model.choosenFilter.isNotEmpty)
                ? model.choosenFilter
                    .asMap()
                    .map(
                      (key, value) => MapEntry(
                        key,
                        Container(
                          child: Container(
                              // color: Colors.red,
                              padding: EdgeInsets.only(right: 6),
                              child: chips(value, (key > 1) ? true : false)),
                        ),
                      ),
                    )
                    .values
                    .toList()
                : [
                    Container(
                        padding: EdgeInsets.only(right: 6),
                        child: chips("Cheeselove", false)),
                    Container(
                        padding: EdgeInsets.only(right: 6),
                        child: chips("Influence", false))
                  ],
          ),
        ),
      ),
    );
  }

  Widget chips(String text, bool showRemove) {
    return FittedBox(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.orange,
          // ),
          color: Colors.orange.withOpacity(.2),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: Text("#$text"),
            ),
            (showRemove != null && showRemove)
                ? Container(
                    padding: EdgeInsets.only(top: 2, left: 6),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            model.choosenFilter
                                .removeWhere((each) => each == text);
                            model.hashTag.add(text);
                            if (model.choosenFilter.length == 2) {
                              store1.dispatch(FilteredStoryAction(
                                  filteredSimilarStory: similarStories));
                            }
                          });
                        },
                        child: Icon(Icons.close, size: 14)),
                  )
                : new Container(),
          ],
        ),
      ),
    );
  }

  Widget topBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Container(
            child: Text(
              "Details",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.textMultiplier * 3.5),
            ),
          ),
          Container(
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
