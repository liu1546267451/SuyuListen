// ignore: must_be_immutable
import 'dart:async';
import 'dart:ui';

import '../../../constant/theme_color.dart';
import '../../../model/article_entity.dart';
import '../../components/animation/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:ionicons/ionicons.dart' as icon_2;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayArticleFrontWidget extends StatefulWidget {
  const TodayArticleFrontWidget({
    this.model,
    Key key,
  }) : super(key: key);
  final ArticleEntity model;
  @override
  _TodayArticleFrontWidgetState createState() =>
      _TodayArticleFrontWidgetState();
}

class _TodayArticleFrontWidgetState extends State<TodayArticleFrontWidget> {
  ArticleEntity model;
  Image myImage;
  Timer timer;
  @override
  void initState() {
    myImage = Image.asset("assets/jupiter.png");
    model = widget.model;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
  }

  void tapBookMark() {
    EasyLoading.showSuccess(model.isMark ? "取消收藏" : "已收藏");
    model.isMark = !model.isMark;
    setState(() {});
  }

  void tapDownloadingButton() {
    if (model.isDownloading) {
      EasyLoading.showError("取消下载");
      // 取消下载
      model.downloadValue = 0;
      timer.cancel();
    } else {
      const timeout = const Duration(milliseconds: 100);

      timer = Timer.periodic(timeout, (timer) {
        model.downloadValue += 0.01;
        if (model.downloadValue >= 1) {
          timer.cancel();
          EasyLoading.showSuccess("下载完成");
        }
        setState(() {});
      });
    }
    model.isDownloading = !model.isDownloading;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320.h,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      // margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        // color: blue,
        gradient: listTileGradient,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: myImage.image,
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 标题
                    FadeAnimation(
                        1,
                        Text(
                          model.title,
                          maxLines: 2,
                          style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                    offset: Offset(0, 0))
                              ],
                              color: Colors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 20.h,
                    ),
                    // 积分
                    FadeAnimation(
                        1.1,
                        Container(
                          width: 100.w,
                          child: Row(
                            children: [
                              Icon(
                                icon_2.Ionicons.flower,
                                size: 30.sp,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                model.coint.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 34.sp),
                              ),
                            ],
                          ),
                        )),
                    // 难度
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: FadeAnimation(
                        1.1,
                        RatingBar(
                          rating: model.level.index.toDouble(),
                          icon: Icon(
                            Icons.star,
                            size: 30.sp,
                            color: Colors.white,
                          ),
                          color: yellow,
                          starCount: 5,
                          spacing: 1.0.w,
                          size: 30.w,
                          isIndicator: true,
                          allowHalfRating: true,
                          onRatingCallback:
                              (double value, ValueNotifier<bool> isIndicator) {
                            print('Number of stars-->  $value');
                            //change the isIndicator from false  to true ,the       RatingBar cannot support touch event;
                            isIndicator.value = true;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FadeAnimation(
                  1.2,
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => tapDownloadingButton(),
                        child: model.isDownloading
                            ? Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 55.h,
                                width: 55.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: model.downloadValue < 1
                                        ? Colors.white
                                        : yellow),
                                child: model.downloadValue < 1
                                    ? Center(
                                        child: LiquidCircularProgressIndicator(
                                          value: model
                                              .downloadValue, // Defaults to 0.5.
                                          valueColor: AlwaysStoppedAnimation(
                                              yellow), // Defaults to the current Theme's accentColor.
                                          backgroundColor: Colors
                                              .transparent, // Defaults to the current Theme's backgroundColor.
                                          direction: Axis
                                              .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                          center: Text(
                                            (model.downloadValue * 100)
                                                    .toInt()
                                                    .toString() +
                                                "%",
                                            style: TextStyle(
                                                fontSize: 22.sp,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          icon_2.Ionicons.checkmark,
                                          color: Colors.black,
                                          size: 36.sp,
                                        ),
                                      ),
                              )
                            : Container(
                                margin: EdgeInsets.only(left: 10),
                                width: 55.h,
                                height: 55.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Icon(
                                    icon_2.Ionicons.cloud_download_outline,
                                    color: Colors.black,
                                    size: 36.sp,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      GestureDetector(
                        onTap: () => tapBookMark(),
                        child: Container(
                          width: 55.h,
                          height: 55.h,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: model.isMark ? yellow : Colors.white),
                          child: Center(
                            child: Icon(
                              Icons.bookmark_border_rounded,
                              color: Colors.black,
                              size: 36.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          // 进度
          FadeAnimation(
              1.3,
              Text(
                model.studyProgress.toString() + "%",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.sp,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
