import 'package:at_wavi_app/desktop/screens/desktop_notification/desktop_new_request_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_notification/desktop_notification_list_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:flutter/material.dart';

class DesktopNotificationPage extends StatefulWidget {
  DesktopNotificationPage({
    Key? key,
  }) : super(key: key);

  @override
  _DesktopNotificationPageState createState() =>
      _DesktopNotificationPageState();
}

class _DesktopNotificationPageState extends State<DesktopNotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            right: 112,
            top: 112,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: appTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.borderColor,
                        offset: Offset(2, 2),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        indicatorColor: appTheme.primaryColor,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 3,
                        unselectedLabelStyle: TextStyle(
                          fontSize: 13,
                          color: appTheme.borderColor,
                          fontFamily: 'Inter',
                        ),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          color: appTheme.primaryTextColor,
                          fontFamily: 'Inter',
                        ),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Text(
                              Strings.desktop_notifications,
                              style: TextStyle(
                                fontSize: 13,
                                color: appTheme.primaryTextColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              Strings.desktop_new_request,
                              style: TextStyle(
                                fontSize: 13,
                                color: appTheme.primaryTextColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            DesktopNotificationListPage(),
                            DesktopNewRequestPage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
