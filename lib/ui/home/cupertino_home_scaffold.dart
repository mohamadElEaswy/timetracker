import 'package:flutter/cupertino.dart';
import 'package:timetracker/ui/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key? key,
    required this.currentTab,
    required this.onSelectedTab,
    required this.widgetBuilders,
  }) : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account)
        ],
        onTap: (index) {},
      ),
      tabBuilder: (BuildContext context, int index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          builder: (context) => widgetBuilders[item]!(context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final TabItemData? itemData = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        itemData!.icon,
      ),
      label: itemData.title,
    );
  }
}
