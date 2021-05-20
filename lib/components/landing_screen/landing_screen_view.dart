import 'package:sampleFlutterProject/actions/bottomNavigation/bottom_navigation_action.dart';
import 'package:sampleFlutterProject/asserts.dart';
import 'package:sampleFlutterProject/components/home_page/home_page.dart';
import 'package:sampleFlutterProject/components/landing_screen/landing_screen.dart';
import 'package:sampleFlutterProject/function/dataBaseInitize.dart';
import 'package:sampleFlutterProject/function/insertDataToDb.dart';
import 'package:sampleFlutterProject/models/bottomNavigationModel.dart';
import 'package:sampleFlutterProject/models/postModel.dart';
import 'package:sampleFlutterProject/states/app_state.dart';
import 'package:sampleFlutterProject/states/bottomNavigationState/bottomNavigationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './landing_screen_view_model.dart';
import 'package:redux/redux.dart';

class LandingScreenView extends State<LandingScreen> {
  Store<AppState> store1;
  LandingScreenViewModel model;
  LandingScreenView() {
    model = new LandingScreenViewModel();
  }

  List<PostModel> stories;

  @override
  void initState() {
    super.initState();
    model.bottomNavigationIcon[0] =
        IconModel(iconString: AssertImages.home_icon, labelName: "Home");
    model.bottomNavigationIcon[1] =
        IconModel(iconString: AssertImages.profile_icon, labelName: "Profile");
    model.bottomNavigationIcon[2] =
        IconModel(iconString: AssertImages.insight_icon, labelName: "Insights");
    model.bottomNavigationIcon[3] = IconModel(
        iconString: AssertImages.notify_icon, labelName: "Notifications");
  }

  checkForDataInDb() async {
    stories = [];
    stories = await StoryDatabase.instance.readAllStories();
    if (stories != null && stories.isNotEmpty) {
      if (mounted) {
        setState(() {
          model.pageLoading = false;
        });
      }
    } else {
      await DataInsertion.shared.userStory();
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            model.pageLoading = false;
          });
        }
      });

      // model.insertData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Scaffold(
      body: StoreConnector<AppState, int>(onInit: (store) {
        store1 = store;
        model.checkForTags(store);
        model.pageLoading = true;
        checkForDataInDb();
      }, converter: (store) {
        return store.state.bottomNavigationState.selectedIndex;
      }, builder: (storecontext, choosenIndex) {
        return (model.pageLoading)
            ? loaderWidget()
            : Column(
                children: [
                  Expanded(
                    child: pageRenderBasedOnTab(choosenIndex),
                  ),
                  Container(
                    child: bottomNavigation(),
                  ),
                ],
              );
      }),
    );
  }

  Widget pageRenderBasedOnTab(int index) {
    return (index != null && index == 0)
        ? HomePage()
        : new Container(
            child: emptyStateWidget(),
          );
  }

  Widget bottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: model.bottomNavigationIcon
            .map(
              (key, value) => MapEntry(
                key,
                InkWell(
                    onTap: () {
                      print(key);
                      store1
                          .dispatch(BottomNavigationAction(selectedIndex: key));
                    },
                    child: bottomIcon(
                        value,
                        (store1.state.bottomNavigationState?.selectedIndex !=
                                    null &&
                                store1.state.bottomNavigationState
                                        .selectedIndex ==
                                    key)
                            ? true
                            : false)),
              ),
            )
            .values
            .toList(),
      ),
    );
  }

  Widget bottomIcon(IconModel tabInfo, bool isChoosen) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 6),
            child: SvgPicture.asset(
              tabInfo.iconString,
              color: (isChoosen != null && isChoosen)
                  ? Colors.orange
                  : Colors.black,
              height: 20,
            ),
          ),
          Container(
            child: Text(
              tabInfo.labelName,
              style: TextStyle(
                  color: (isChoosen != null && isChoosen)
                      ? Colors.orange
                      : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyStateWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 350,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                image: AssetImage(
                  AssertImages.emptyState,
                ),
              ),
            ),
          ),
          Container(
            child: Text("Under development",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                )),
          ),
        ],
      ),
    );
  }

  Widget loaderWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 20, width: 20, child: CircularProgressIndicator()),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Loading... Please wait",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
