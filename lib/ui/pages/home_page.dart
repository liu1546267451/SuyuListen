import 'package:SuyuListening/provider/theme_provider.dart';
import 'package:SuyuListening/ui/components/Menu/menu_widget.dart';
import 'package:SuyuListening/ui/pages/article/article_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).innerDrawerKey =
        GlobalKey<InnerDrawerState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: Provider.of<ThemeProvider>(context).innerDrawerKey,
      leftChild: _buildLeftChild(context),
      scaffold: ArticleListPage(),
      // 一些配置
      onTapClose: true,

      swipe: true,
      colorTransitionChild: Colors.grey[900],
      colorTransitionScaffold: Colors.white70,
      offset: IDOffset.only(bottom: 0, right: 0, left: 0.3),
      proportionalChildArea: true,
      borderRadius: 0,
      leftAnimationType: InnerDrawerAnimation.linear,
      backgroundDecoration: BoxDecoration(color: Colors.grey[900]),
      innerDrawerCallback: (a) => {},
    );
  }
}

Widget _buildLeftChild(BuildContext context) {
  return GestureDetector(
      onHorizontalDragEnd: (detail) {
        Provider.of<ThemeProvider>(context, listen: false)
            .innerDrawerKey
            .currentState
            .toggle(direction: InnerDrawerDirection.start);
      },
      child: MenuWidget());
}