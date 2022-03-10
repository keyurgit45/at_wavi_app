import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatelessWidget {
  final String? title, subtitle;
  final bool isUrl;
  late bool _isDark;
  late ThemeData themeData;
  CustomCard(
      {this.title,
      required this.subtitle,
      this.isUrl = false,
      required this.themeData});

  void setThemeData(BuildContext context) {
    _isDark = themeData.scaffoldBackgroundColor == ColorConstants.black;
  }

  @override
  Widget build(BuildContext context) {
    setThemeData(context);
    return Container(
      color: themeData.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title != null
                ? Text(
                    '${title![0].toUpperCase()}${title!.substring(1)}',
                    style: TextStyles.lightText(
                        themeData.primaryColor.withOpacity(0.5),
                        size: 16),
                  )
                : SizedBox(),
            SizedBox(height: 6),
            subtitle != null
                ? GestureDetector(
                    onTap: () async {
                      if (subtitle != null) {
                        
                    },
                    child: HtmlWidget(
                      subtitle!,
                      textStyle: TextStyle(
                        color: isUrl
                            ? ColorConstants.orange
                            : themeData.primaryColor,
                        fontSize: 16.toFont,
                      ),
                      webView: true,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
