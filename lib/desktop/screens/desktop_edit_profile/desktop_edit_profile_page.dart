import 'package:at_wavi_app/desktop/screens/desktop_appearance/desktop_appearance_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_my_profile/desktop_details/desktop_basic_detail/desktop_basic_detail_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_edit_profile_model.dart';
import 'desktop_side_menu.dart';
import 'widgets/desktop_side_menu_widget.dart';

class DesktopEditProfilePage extends StatefulWidget {
  const DesktopEditProfilePage({Key? key}) : super(key: key);

  @override
  _DesktopEditProfilePageState createState() => _DesktopEditProfilePageState();
}

class _DesktopEditProfilePageState extends State<DesktopEditProfilePage> {
  late DesktopEditProfileModel _model;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    _model = DesktopEditProfileModel();
    super.initState();
    _model.addListener(() {
      final index = DesktopSideMenu.values.indexOf(_model.selectedMenu);
      if (index >= 0) {
        _pageController.jumpToPage(index);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => _model,
      child: Scaffold(
        body: Row(
          children: [
            buildSideMenus(),
            Container(
              width: 1,
              height: double.infinity,
              color: appTheme.separatorColor,
            ),
            Expanded(
              child: buildContentPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSideMenus() {
    final appTheme = AppTheme.of(context);
    return Consumer<DesktopEditProfileModel>(
      builder: (context, provider, child) {
        return Container(
          width: 360,
          margin: EdgeInsets.only(right: 1),
          child: Column(
            children: [
              Container(
                height: 150,
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        appTheme.isDark ? Images.logoLight : Images.logoDark,
                        width: 89,
                        height: 33,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: DesktopIconButton(
                        iconData: Icons.close_rounded,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: DesktopSideMenu.values.length,
                  itemBuilder: (context, index) {
                    final menu = DesktopSideMenu.values[index];
                    return DesktopSideMenuWidget(
                      menu: menu,
                      isSelected: menu == _model.selectedMenu,
                      onPressed: () {
                        _model.changeMenu(menu);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: appTheme.primaryLighterColor,
          ),
        );
      },
    );
  }

  Widget buildContentPage() {
    return Container(
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: DesktopSideMenu.values.map((e) {
          switch (e) {
            case DesktopSideMenu.profile:
              return Container(color: Colors.red);
            case DesktopSideMenu.basicDetails:
              return DesktopBasicDetailPage(atCategory: AtCategory.DETAILS);
            case DesktopSideMenu.additionalDetails:
              return DesktopBasicDetailPage(
                  atCategory: AtCategory.ADDITIONAL_DETAILS);
            case DesktopSideMenu.location:
              return DesktopBasicDetailPage(atCategory: AtCategory.LOCATION);
            case DesktopSideMenu.socialChannel:
              return DesktopBasicDetailPage(atCategory: AtCategory.SOCIAL);
            case DesktopSideMenu.gameChannel:
              return DesktopBasicDetailPage(atCategory: AtCategory.GAMER);
            case DesktopSideMenu.appearance:
              return DesktopAppearancePage();
            default:
              return Container(color: Colors.green);
          }
        }).toList(),
      ),
    );
  }
}
