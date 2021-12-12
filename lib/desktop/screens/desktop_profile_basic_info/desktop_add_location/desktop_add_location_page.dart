import 'package:at_location_flutter/map_content/flutter_map/flutter_map.dart';
import 'package:at_wavi_app/common_components/create_marker.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_select_location/desktop_select_location_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'desktop_add_location_model.dart';

class DesktopAddLocationPage extends StatefulWidget {
  const DesktopAddLocationPage({Key? key}) : super(key: key);

  @override
  _DesktopAddLocationPageState createState() => _DesktopAddLocationPageState();
}

class _DesktopAddLocationPageState extends State<DesktopAddLocationPage> {
  late DesktopAddLocationModel _model;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopAddLocationModel(userPreview: userPreview);
        return _model;
      },
      child: Consumer<DesktopAddLocationModel>(
        builder: (_, model, child) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.all(DesktopDimens.paddingNormal),
            decoration: BoxDecoration(
              color: appTheme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tag',
                  style: appTheme.textTheme.bodyText2,
                ),
                SizedBox(height: DesktopDimens.paddingSmall),
                Container(
                  height: 48,
                  child: TextFormField(
                    controller: model.tagTextController,
                    style: appTheme.textTheme.bodyText2?.copyWith(
                      color: appTheme.primaryTextColor,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: DesktopDimens.paddingNormal),
                Text(
                  'Location',
                  style: appTheme.textTheme.bodyText2,
                ),
                SizedBox(height: DesktopDimens.paddingSmall),
                if (model.osmLocationModel == null)
                  GestureDetector(
                    onTap: openSelectLocation,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: appTheme.borderColor, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'Select',
                          style: appTheme.textTheme.button
                              ?.copyWith(color: appTheme.primaryColor),
                        ),
                      ),
                    ),
                  ),
                if (model.osmLocationModel != null)
                  Expanded(
                    child: GestureDetector(
                      onTap: openSelectLocation,
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: appTheme.borderColor, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AbsorbPointer(
                          absorbing: true,
                          child: FlutterMap(
                            options: MapOptions(
                              boundsOptions:
                                  FitBoundsOptions(padding: EdgeInsets.all(0)),
                              center: model.osmLocationModel?.latLng,
                              zoom: model.osmLocationModel?.zoom ?? 14.0,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate:
                                    'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=${MixedConstants.MAP_KEY}',
                                subdomains: ['a', 'b', 'c'],
                                minNativeZoom: 2,
                                maxNativeZoom: 18,
                                minZoom: 1,
                                tileProvider: NonCachingNetworkTileProvider(),
                              ),
                              MarkerLayerOptions(markers: [
                                if (model.osmLocationModel?.latLng != null)
                                  Marker(
                                    width: 40,
                                    height: 50,
                                    point: model.osmLocationModel!.latLng!,
                                    builder: (ctx) => Container(
                                        child: createMarker(
                                            diameterOfCircle: model
                                                    .osmLocationModel!
                                                    .diameter ??
                                                0)),
                                  )
                              ])
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: DesktopDimens.paddingNormal),
                Container(
                  alignment: Alignment.centerRight,
                  child: DesktopButton(
                    title: 'Save',
                    width: 180,
                    onPressed: _onSaveData,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void openSelectLocation() async {
    final latLng = _model.osmLocationModel?.latLng;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopSelectLocationPage(
          'Ha noi',
          latLng,
          onLocationPicked: (location) {
            _model.changeLocation(location);
          },
        ),
      ),
    );
  }

  Future _onSaveData() async {
    await _model.saveData(context);
  }
}
