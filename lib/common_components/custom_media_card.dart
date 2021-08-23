import 'dart:convert';
import 'dart:typed_data';

import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomMediaCard extends StatefulWidget {
  final BasicData basicData;
  late final ThemeData themeData;
  CustomMediaCard({required this.basicData, required this.themeData});

  @override
  _CustomMediaCardState createState() => _CustomMediaCardState();
}

class _CustomMediaCardState extends State<CustomMediaCard> {
  late bool _isDark, _isImage = false, _isVideo = false;
  Uint8List? customImage;
  late YoutubePlayerController _controller;

  void setThemeData(BuildContext context) {
    _isDark = widget.themeData.scaffoldBackgroundColor == ColorConstants.white;
  }

  @override
  void initState() {
    if (widget.basicData.type == CustomContentType.Image.name) {
      _isImage = true;
      if (widget.basicData.value is String) {
        widget.basicData.value = json.decode(widget.basicData.value);
      }
      var intList = widget.basicData.value!.cast<int>();
      customImage = Uint8List.fromList(intList);
    } else if (widget.basicData.type == CustomContentType.Youtube.name) {
      // getting youtube video ID
      String videoId = widget.basicData.value.split('/').last;
      if (videoId.contains('watch?v=')) {
        videoId = videoId.replaceAll('watch?v=', '');
      }

      _isVideo = true;

      /// initializing [_controller]
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setThemeData(context);
    return Container(
      color: widget.themeData.highlightColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.basicData.accountName!,
              style: TextStyles.lightText(
                  widget.themeData.primaryColor.withOpacity(0.5),
                  size: 16),
            ),
            SizedBox(height: 6),
            ((widget.basicData.valueDescription != null) &&
                    (widget.basicData.valueDescription != 'null'))
                ? Text(
                    widget.basicData.valueDescription!,
                    style: _isDark
                        ? TextStyles.lightText(widget.themeData.primaryColor,
                            size: 18)
                        : TextStyles.lightText(widget.themeData.highlightColor,
                            size: 18),
                  )
                : SizedBox(),
            _isImage && customImage != null
                ? Image.memory(
                    customImage as Uint8List,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.fill,
                  )
                : SizedBox(),
            _isVideo
                ? YoutubePlayer(
                    controller: _controller,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(isExpanded: true),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
