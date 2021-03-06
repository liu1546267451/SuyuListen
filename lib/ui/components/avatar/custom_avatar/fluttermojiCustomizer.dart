import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../avatar.dart';
import 'fluttermojiController.dart';
import 'fluttermoji_assets/fluttermojimodel.dart';

/// This widget provides a UI for customizing the Fluttermoji
///
/// Accepts a [outerTextTitle] which defaults to "Customize:"
///
/// Accepts an optional [scaffoldHeight] and [scaffoldWidth].
/// When using in landscape mode, it is advised to pass a [scaffoldWidth] to the widget
///
/// Adapts to the enclosing MaterialApp's dark theme settings
///
/// It is advised that a [FluttermojiCircleAvatar] also be present in the same page.
class FluttermojiCustomizer extends StatefulWidget {
  final String outerTitleText;
  final double scaffoldHeight;
  final double scaffoldWidth;
  FluttermojiCustomizer(
      {Key key,
      this.outerTitleText = 'Customize :',
      this.scaffoldHeight = 0.0,
      this.scaffoldWidth = 0.0})
      : super(key: key);

  @override
  _FluttermojiCustomizerState createState() => _FluttermojiCustomizerState();
}

class _FluttermojiCustomizerState extends State<FluttermojiCustomizer>
    with SingleTickerProviderStateMixin {
  FluttermojiController fluttermojiController;
  TabController tabController;
  var heightFactor = 0.4;
  var widthFactor = 0.95;

  @override
  void initState() {
    super.initState();
    var _fluttermojiController;
    Get.put(FluttermojiController());
    _fluttermojiController = Get.find<FluttermojiController>();
    setState(() {
      tabController = TabController(length: 11, vsync: this);
      fluttermojiController = _fluttermojiController;
    });
  }

  /// Widget that renders an expanded layout for customization
  /// Accepts a [cardTitle] and a [attributes].
  ///
  /// [attribute] is an object with the fields attributeName and attributeKey
  Widget expandedCard(
      {@required String cardTitle,
      @required List<ExpandedFluttermojiCardItem> attributes}) {
    var size = MediaQuery.of(context).size;

    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var iconColor = (!isDarkMode) ? Colors.grey[600] : Colors.white;
    //final double mediumfont = size.height * 0.038;
    var attributeRows = <Widget>[];
    var navbarWidgets = <Widget>[];
    var _appbarcolor = (!isDarkMode) ? Colors.white : Colors.grey[600];
    var _bgcolor = (!isDarkMode) ? Color(0xFFF1F1F1) : Colors.grey[800];

    attributes.forEach((attribute) {
      if (!fluttermojiController.selectedIndexes.containsKey(attribute.key)) {
        fluttermojiController.selectedIndexes[attribute.key] = 0;
      }
      var attributeListLength =
          fluttermojiProperties[attribute.key].property.length ?? 0;
      var gridCrossAxisCount = 4;
      int i = fluttermojiController.selectedIndexes[attribute.key];
      if (attributeListLength < 12)
        gridCrossAxisCount = 3;
      else if (attributeListLength < 9) gridCrossAxisCount = 2;
      Widget bottomNavWidget = Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 12),
          child: SvgPicture.asset(
            attribute.iconAsset,
            height: (attribute.iconsize == 0)
                ? widget.scaffoldHeight > 0
                    ? widget.scaffoldHeight / heightFactor * 0.03
                    : size.height * 0.03
                : attribute.iconsize,
            color: iconColor,
            semanticsLabel: attribute.title,
          ));
      Widget _row = Column(children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: _appbarcolor,
            child: Center(
              child: Text(
                attribute.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: widget.scaffoldHeight > 0
                      ? widget.scaffoldHeight / heightFactor * 0.015
                      : size.height * 0.015,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 11,
          // height: size.height*0.25,
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: attributeListLength,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCrossAxisCount,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0),
            itemBuilder: (BuildContext context, int index) {
              if (index == i) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.green,
                      width: 3.0,
                    ),
                  ),
                  child: SvgPicture.string(
                    fluttermojiController.getComponentSVG(attribute.key, i),
                    height: 20,
                    semanticsLabel: "Your Fluttermoji",
                    placeholderBuilder: (context) => Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                );
              }

              return InkWell(
                onTap: () {
                  fluttermojiController.selectedIndexes[attribute.key] = index;
                  fluttermojiController.updatePreview();
                  setState(() {});
                },
                child: SvgPicture.string(
                  fluttermojiController.getComponentSVG(attribute.key, index),
                  height: 20,
                  semanticsLabel: 'Your Fluttermoji',
                  placeholderBuilder: (context) => Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              );
            },
          ),
        ),
      ]);
      attributeRows.add(_row);
      navbarWidgets.add(bottomNavWidget);
    });

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: widget.scaffoldWidth > 0
                ? widget.scaffoldWidth * widthFactor
                : size.width * widthFactor,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
            child: DefaultTabController(
              length: attributeRows.length,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Scaffold(
                  key: ValueKey('Overview'),
                  backgroundColor: _bgcolor,
                  body: TabBarView(
                      // physics: PageScrollPhysics(),
                      controller: tabController,
                      children: attributeRows),
                  bottomNavigationBar: Container(
                    color: _appbarcolor, //Colors.grey[400],
                    child: TabBar(
                        controller: tabController,
                        isScrollable: true,
                        labelPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        indicatorColor: Colors.blue,
                        indicatorPadding: EdgeInsets.all(2),
                        tabs: navbarWidgets),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.9, -1),
          child: Visibility(
            visible: !(tabController.length == tabController.index + 1),
            child: IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
                size: widget.scaffoldHeight > 0
                    ? widget.scaffoldHeight / heightFactor * 0.02
                    : size.height * 0.02,
              ),
              onPressed: () {
                var _currentIndex = tabController.index;
                tabController.animateTo(_currentIndex < tabController.length
                    ? _currentIndex + 1
                    : _currentIndex);
                setState(() {});
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment(-0.9, -1),
          child: Visibility(
            visible: !(tabController.index == 0),
            child: IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.arrow_back_ios,
                color: iconColor,
                size: widget.scaffoldHeight > 0
                    ? widget.scaffoldHeight / heightFactor * 0.02
                    : size.height * 0.02,
              ),
              onPressed: () {
                int _currentIndex = tabController.index;
                tabController.animateTo(_currentIndex < tabController.length
                    ? _currentIndex - 1
                    : _currentIndex);
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.outerTitleText,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: widget.scaffoldHeight > 0
                          ? widget.scaffoldHeight / heightFactor * 0.02
                          : size.height * 0.02,
                      fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {
                    String newSvgStr = getSvg(randomAvatarOptions());
                    fluttermojiController.setFluttermoji(
                        fluttermojiNew: newSvgStr);

                    fluttermojiController.updatePreview();

                    setState(() {});
                  },
                  child: Text(
                    "随机",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: widget.scaffoldHeight > 0
                ? widget.scaffoldHeight
                : size.height * heightFactor,
            width: widget.scaffoldWidth > 0 ? widget.scaffoldWidth : size.width,
            child: expandedCard(cardTitle: "Customize", attributes: [
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/hair.svg",
                  title: "头发",
                  key: "topType"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/haircolor.svg",
                  title: "头发颜色",
                  key: "hairColor"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/beard.svg",
                  title: "胡须",
                  key: "facialHairType"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/beardcolor.svg",
                  title: "胡须颜色",
                  key: "facialHairColor"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/outfit.svg",
                  title: "上衣",
                  key: "clotheType"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/outfitcolor.svg",
                  title: "上衣颜色",
                  key: "clotheColor"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/eyes.svg",
                  title: "眼睛",
                  key: "eyeType"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/eyebrow.svg",
                  title: "眉毛",
                  key: "eyebrowType"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/mouth.svg",
                  title: "嘴巴",
                  key: "mouthType"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/skin.svg",
                  title: "皮肤颜色",
                  key: "skinColor"),
              ExpandedFluttermojiCardItem(
                  iconAsset: "assets/icons/custom_avatarIcons/accessories.svg",
                  title: "眼镜",
                  key: "accessoriesType"),
            ]),
          )
        ]);
  }
}
