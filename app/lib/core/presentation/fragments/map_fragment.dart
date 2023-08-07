import 'dart:io';

import 'package:app/core/domain/entities/coordinate.dart';
import 'package:app/core/domain/logic/map/map_cubit.dart';
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
  // Set<Marker> _mapMarkers = {};
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

    _addTileOverlay();
  }

  void _addTileOverlay() {
    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: const TileOverlayId('tile_overlay_1'),
      tileProvider: _DebugTileProvider(),
    );
    setState(() {
      _tileOverlay = tileOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: this._mapCubit,
      child: Container(
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
                          target: LatLng(
                              state.coordinate.lat, state.coordinate.lon),
                          zoom: 11,
                        ),
                      ),
                    );
              }
              if (Platform.isAndroid || Platform.isIOS) {
                // return FutureBuilder(
                // future: this._renderMarkers(coordinates: [state.coordinate]),
                // builder: (context, data) {
                // if (data.hasData) {
                // _mapMarkers = data.data as Set<Marker>;
                // }
                return Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      onTap: (position) {
                        print(position);
                      },
                      onCameraMove: (position) {},
                      initialCameraPosition: CameraPosition(
                        target:
                            LatLng(state.coordinate.lat, state.coordinate.lon),
                        zoom: 13.0,
                      ),
                      mapToolbarEnabled: false,
                      liteModeEnabled: false,
                      tiltGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      mapType: _mapType,
                      markers: const {}, //this._mapMarkers,
                      polylines: const {},
                      circles: const {},
                      polygons: const {},
                      tileOverlays: overlays,
                      gestureRecognizers: <Factory<EagerGestureRecognizer>>{}
                        ..add(Factory<EagerGestureRecognizer>(
                            () => EagerGestureRecognizer())),
                    ),
                    // if (this.widget.showControls) ...[
                    //   Positioned(
                    //     bottom: 20 + this.widget.mapViewButtonsOffset,
                    //     right: 20,
                    //     child: MapViewButtons(
                    //       onLocationTapped: () async {
                    //         if (this._mapController != null) {
                    //           this._mapController!.animateCamera(
                    //                 CameraUpdate.newCameraPosition(
                    //                   CameraPosition(
                    //                     target: LatLng(state.coordinate.lat,
                    //                         state.coordinate.lon),
                    //                     zoom: await this
                    //                         ._mapController!
                    //                         .getZoomLevel(),
                    //                   ),
                    //                 ),
                    //               );
                    //         }
                    //       },
                    //       onMapTypeTapped: () {
                    //         setState(() {
                    //           this._mapType = _mapType == MapType.normal
                    //               ? MapType.hybrid
                    //               : MapType.normal;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    //   Positioned(
                    //     bottom: 20,
                    //     left: 20,
                    //     child: MapZoomButtons(
                    //       onZoonInTapped: () {
                    //         if (this._mapController != null) {
                    //           this
                    //               ._mapController!
                    //               .animateCamera(CameraUpdate.zoomIn());
                    //         }
                    //       },
                    //       onZoonOutTapped: () {
                    //         if (this._mapController != null) {
                    //           this
                    //               ._mapController!
                    //               .animateCamera(CameraUpdate.zoomOut());
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ],
                  ],
                );
                //   },
                // );
              }
              return const SizedBox.shrink();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Future<Set<Marker>> _renderMarkers(
  //     {required List<Coordinate> coordinates}) async {
  //   Set<Marker> _markers = {};
  //   for (final Coordinate _coordinate in coordinates) {
  //     _markers.add(await _renderMarker(coordinate: _coordinate));
  //   }
  //   return _markers;
  // }

  // Future<Marker> _renderMarker({
  //   required Coordinate coordinate,
  // }) async {
  //   late BitmapDescriptor customIcon;

  //   await BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration(
  //       size: const Size(20, 20),
  //       devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
  //     ),
  //     AppIcons.iconMapPin,
  //   ).then((icon) {
  //     customIcon = icon;
  //   });

  //   return Marker(
  //     markerId: MarkerId('${coordinate.lat}-${coordinate.lon}'),
  //     position: LatLng(coordinate.lat, coordinate.lon),
  //     onTap: () {},
  //     icon: customIcon,
  //   );
  // }
}

class _DebugTileProvider implements TileProvider {
  _DebugTileProvider();

  static const int width = 100;
  static const int height = 100;

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    // final ui.PictureRecorder recorder = ui.PictureRecorder();
    // final Canvas canvas = Canvas(recorder);
    // final TextSpan textSpan = TextSpan(
    //   text: '$x,$y',
    //   style: textStyle,
    // );
    // final TextPainter textPainter = TextPainter(
    //   text: textSpan,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout(
    //   maxWidth: width.toDouble(),
    // );
    // textPainter.paint(canvas, Offset.zero);
    // canvas.drawRect(
    //     Rect.fromLTRB(0, 0, width.toDouble(), width.toDouble()), boxPaint);
    // final ui.Picture picture = recorder.endRecording();
    // final Uint8List byteData = await picture
    //     .toImage(width, height)
    //     .then((ui.Image image) =>
    //         image.toByteData(format: ui.ImageByteFormat.png))
    //     .then((ByteData? byteData) => byteData!.buffer.asUint8List());

    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(
                'https://tile.openweathermap.org/map/temp_new/$zoom/$x/$y.png?appid=de8c5572c3684f9ce1b2cb026c9b0b20'))
            .load(
                'https://tile.openweathermap.org/map/temp_new/$zoom/$x/$y.png?appid=de8c5572c3684f9ce1b2cb026c9b0b20'))
        .buffer
        .asUint8List();

    return Tile(width, height, bytes);
  }
}
