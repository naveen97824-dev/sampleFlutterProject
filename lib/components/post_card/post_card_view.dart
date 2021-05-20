import 'package:sampleFlutterProject/asserts.dart';
import 'package:sampleFlutterProject/components/post_card/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './post_card_view_model.dart';
import 'package:intl/intl.dart';

class PostCardView extends State<PostCard> {
  PostCardViewModel model;
  PostCardView() {
    model = new PostCardViewModel();
  }
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Container(
      decoration: BoxDecoration(
          color: Colors.orange.withOpacity(.2),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: <Widget>[
          Expanded(
            child: topSection(),
          ),
          Container(
            child: bottomSection(),
          ),
        ],
      ),
    );
  }

  Widget bottomSection() {
    return Container(
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: <Widget>[
          Expanded(child: Container()),
          countSection(
              AssertImages.like,
              (widget.storyData != null && widget.storyData?.likeCount != null)
                  ? widget.storyData.likeCount
                  : "0"),
          SizedBox(width: 20),
          countSection(
              AssertImages.notify_icon,
              (widget.storyData != null &&
                      widget.storyData?.commentCount != null)
                  ? widget.storyData.commentCount
                  : "0"),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget countSection(String icon, String count) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              child: SvgPicture.asset(
            icon,
            color: Colors.black,
            height: 15,
          )),
          Container(
            padding: EdgeInsets.only(left: 4),
            child: (count != "0") ? Text(countFormatter(count)) : Text(""),
          ),
        ],
      ),
    );
  }

  Widget topSection() {
    return Container(
      child: Stack(
        children: <Widget>[
          // Container(),
          Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: AssetImage(
            //       AssertImages.emptyState,
            //     ),
            //   ),
            // ),
            child: (widget.storyData != null &&
                    widget.storyData.mediaUrl != null &&
                    widget.storyData.mediaUrl.split(".").last != "mp4")
                ? imagePreview(widget.storyData.mediaUrl)
                : (widget.storyData != null &&
                        widget.storyData.mediaUrl != null &&
                        widget.storyData.mediaUrl.split(".").last == "mp4")
                    ? videoThumbnail()
                    : new Container(),
          ),
          Positioned(
              top: 10,
              left: 10,
              child: (widget.storyData != null && widget.storyData.date != null)
                  ? Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 6),
                          child: SvgPicture.asset(
                            AssertImages.clock,
                            color: Colors.white,
                            height: 12,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM').format(
                              DateTime.parse(widget.storyData.date).toLocal()),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  : new Container()),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(.8),
              ),
              padding: EdgeInsets.all(5),
              child: SvgPicture.asset(
                (widget.storyData != null &&
                        widget.storyData.mediaUrl != null &&
                        widget.storyData.mediaUrl.split(".").last == "mp4")
                    ? AssertImages.play
                    : AssertImages.image,
                color: Colors.black,
                height: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget videoThumbnail() {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        AssertImages.unspported,
        color: Colors.black,
        height: 40,
      ),
    );
  }

  Widget imagePreview(String url) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: url,
        // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFo3uyrOaBKYsomVMRk7twseG7EzUW6DnQ83V3qUdVeVzJQwmoQurMCud0_ff5q7XUoAw&usqp=CAU",
        placeholder: (context, url) => Container(
            alignment: Alignment.center,
            // width: 250,
            // height: 250,
            padding: EdgeInsets.all(20),
            child: Container(
                // color: Colors.white,
                height: 20,
                width: 20,
                child: CircularProgressIndicator())),
        fit: BoxFit.cover,
        height: (MediaQuery.of(context).size.width < 600)
            ? (MediaQuery.of(context).size.width - 40) / 2
            : 275,
        width: (MediaQuery.of(context).size.width < 600)
            ? (MediaQuery.of(context).size.width - 40) / 2
            : 275,
        errorWidget: (context, url, error) => Container(
            alignment: Alignment.center,
            color: Colors.orange.withOpacity(.3),
            // margin: EdgeInsets.all(20),
            child: Container(
                height: 20, width: 20, child: CircularProgressIndicator())),
      ),
    );
  }

  String countFormatter(String count) {
    int value = int.parse(count);
    double dividedValue = (value / 1000);
    if (dividedValue > 0.99) {
      if (int.parse(dividedValue.toString().split(".").last) >= 1) {
        return "${dividedValue.toStringAsFixed(1)}k";
      } else {
        return "${(dividedValue.toInt()).toString()}k";
      }
    } else {
      return count;
    }
  }
}
