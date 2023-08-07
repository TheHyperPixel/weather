import 'dart:io';

import 'package:app/core/domain/entities/coordinate.dart';
import 'package:app/core/domain/enums/map_tile_type.dart';
import 'package:app/core/domain/logic/map/map_cubit.dart';
import 'package:app/core/presentation/components/app_base_button.dart';
import 'package:app/core/presentation/fragments/bottom_sheet.dart';
import 'package:app/core/presentation/localizations/app_localizations.dart';
import 'package:app/core/presentation/styles/app_border_radius.dart';
import 'package:app/core/presentation/styles/app_colors_delegate.dart';
import 'package:app/core/presentation/styles/app_icons.dart';
import 'package:app/core/presentation/styles/app_text_styles.dart';
import 'package:app/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFragment extends StatefulWidget {
  final Coordinate coordinate;
  final double mapViewButtonsOffset;
  final bool showControls;

  const MapFragment({
    super.key,
    required this.coordinate,
    this.mapViewButtonsOffset = 0,
    this.showControls = true,
  });

  @override
  State<MapFragment> createState() => _MapFragmentState();
}

class _MapFragmentState extends State<MapFragment> {
  late MapCubit _mapCubit;
  GoogleMapController? _mapController;
  MapType _mapType = MapType.normal;
  MapTileType _mapTileType = MapTileType.temperature;
  TileOverlay? _tileOverlay;

  @override
  void initState() {
    super.initState();

    this._mapCubit = getIt<MapCubit>()
      ..loadMap(
        coordinate: this.widget.coordinate,
      );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
    _updateTileOverlay();
  }

  void _clearTileOverlay() {
    if (this._mapController != null && _tileOverlay != null) {
      this._mapController!.clearTileCache(_tileOverlay!.tileOverlayId);
    }
  }

  void _updateTileOverlay() {
    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: TileOverlayId(_mapTileType.name),
      tileProvider: _MapTileProvider(mapTileType: _mapTileType),
    );
    setState(() {
      _tileOverlay = tileOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: this._mapCubit,
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          final Set<TileOverlay> overlays = <TileOverlay>{
            if (_tileOverlay != null) _tileOverlay!,
          };

          if (state is MapStateSuccess) {
            if (this._mapController != null) {
              this._mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target:
                            LatLng(state.coordinate.lat, state.coordinate.lon),
                        zoom: 12,
                      ),
                    ),
                  );
            }
            if (Platform.isAndroid || Platform.isIOS) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppBaseButton(
                    onTap: () {
                      this.showMapTileTypeBottomSheet(context: context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _mapTileType.title(
                              appLocalizations: AppLocalizations.of(context),
                            ),
                            style: AppTextStyles.paragraph(context: context),
                          ),
                        ),
                        Image.asset(
                          AppIcons.iconChevronForward,
                          color: AppColorsDelegate.of(context).dust,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: const AppBorderRadius.normal(),
                      child: Stack(
                        children: [
                          GoogleMap(
                            onMapCreated: _onMapCreated,
                            onTap: (position) {
                              print(position);
                            },
                            onCameraMove: (position) {
                              this._clearTileOverlay();
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  state.coordinate.lat, state.coordinate.lon),
                              zoom: 12,
                            ),
                            mapToolbarEnabled: false,
                            liteModeEnabled: false,
                            tiltGesturesEnabled: false,
                            myLocationButtonEnabled: false,
                            mapType: _mapType,
                            markers: const {},
                            polylines: const {},
                            circles: const {},
                            polygons: const {},
                            tileOverlays: overlays,
                            gestureRecognizers:
                                <Factory<EagerGestureRecognizer>>{}..add(
                                    Factory<EagerGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: AppBaseButton(
                              onTap: () {
                                setState(() {
                                  if (this._mapType == MapType.normal) {
                                    _mapType = MapType.satellite;
                                  } else {
                                    _mapType = MapType.normal;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColorsDelegate.of(context).white,
                                  borderRadius: const AppBorderRadius.normal(),
                                ),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    AppIcons.iconMap,
                                    color: AppColorsDelegate.of(context).coal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future showMapTileTypeBottomSheet({required BuildContext context}) async {
    await showBottomSheetWidget(
      context: context,
      isBarrierDismissable: true,
      isScrollControlled: false,
      enableDrag: true,
      bottomSheet: ((buildContext) {
        return BottomSheetWidget(
          margin: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).padding.top > 0
                ? MediaQuery.of(context).padding.top
                : 20,
            0,
            0,
          ),
          title: '',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            children: [
              for (MapTileType _mapTileType in MapTileType.values) ...[
                AppBaseButton(
                  onTap: () {
                    setState(() {
                      this._mapTileType = _mapTileType;
                    });
                    this._clearTileOverlay();
                    this._updateTileOverlay();
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      _mapTileType.title(
                        appLocalizations: AppLocalizations.of(context),
                      ),
                      style: AppTextStyles.paragraph(context: context),
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: AppColorsDelegate.of(context).dust,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _MapTileProvider implements TileProvider {
  static const int width = 256;
  static const int height = 256;
  final MapTileType mapTileType;

  _MapTileProvider({
    required this.mapTileType,
  });

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(
                'https://tile.openweathermap.org/map/${mapTileType.apiName}/$zoom/$x/$y.png?appid=de8c5572c3684f9ce1b2cb026c9b0b20'))
            .load(
                'https://tile.openweathermap.org/map/${mapTileType.apiName}/$zoom/$x/$y.png?appid=de8c5572c3684f9ce1b2cb026c9b0b20'))
        .buffer
        .asUint8List();

    return Tile(width, height, bytes);
  }
}
