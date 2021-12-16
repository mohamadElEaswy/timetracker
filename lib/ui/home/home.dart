import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/ui/home/account/account_screen.dart';
import 'package:timetracker/ui/home/cupertino_home_scaffold.dart';
import 'package:timetracker/ui/home/entries/entries_page.dart';
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
    if (tabItem == _currentTab) {
      //if pop to first route
      return navigatorKeys[tabItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else if (tabItem != _currentTab) {
      return setState(() => _currentTab = tabItem);
    }
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => const HomeScreen(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => const AccountScreen(),
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
