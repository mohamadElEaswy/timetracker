import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/ui/home/cupertino_home_scaffold.dart';
import 'package:timetracker/ui/home/home_screen.dart';
import 'package:timetracker/ui/home/tab_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TabItem _currentTab = TabItem.jobs;
  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => const HomeScreen(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => Container(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectedTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }
}
