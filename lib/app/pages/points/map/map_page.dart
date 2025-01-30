import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retry/retry.dart';
import 'package:u_app_utils/u_app_utils.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/points_repository.dart';

part 'map_state.dart';
part 'map_view_model.dart';

class MapPage extends StatelessWidget {
  MapPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapViewModel>(
      create: (context) => MapViewModel(
        RepositoryProvider.of<PointsRepository>(context)
      ),
      child: _MapView(),
    );
  }
}

class _MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  ym.PlacemarkMapObject? tappedPoint;
  List<ym.MapObject> mapObjects = [];
  Map<Color, String> colorIcons = {
    Styles.greenColor: 'assets/green_point.png',
    Styles.yellowColor: 'assets/yellow_point.png',
    Styles.greyColor: 'assets/grey_point.png',
    Styles.blueColor: 'assets/blue_point.png',
  };

  List<ym.MapObject> buildMapObjects(BuildContext context) {
    final vm = context.read<MapViewModel>();
    final placemarks = vm.state.pointBuyerRoutePointList
      .where((e) => e.point.latitude != null && e.point.longitude != null)
      .map((e) {
        final mapId = ym.MapObjectId('${e.point.id}');
        const textStyle = ym.PlacemarkTextStyle(placement: ym.TextStylePlacement.top);

        return ym.PlacemarkMapObject(
          mapId: mapId,
          point: ym.Point(latitude: e.point.latitude!, longitude: e.point.longitude!),
          consumeTapEvents: true,
          opacity: 0.75,
          icon: ym.PlacemarkIcon.single(
            ym.PlacemarkIconStyle(image: ym.BitmapDescriptor.fromAssetImage(colorIcons[pointColor(e)]!))
          ),
          text: ym.PlacemarkText(text: (tappedPoint?.mapId == mapId) ? e.point.buyerName : '', style: textStyle),
          onTap: (self, point) => setState(() => tappedPoint = self)
        );
      }).toList();

    return placemarks;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewModel, MapState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Точки')
          ),
          body: buildMap()
        );
      }
    );
  }

  Widget buildMap() {
    MapViewModel vm = context.read<MapViewModel>();

    return ym.YandexMap(
      mapObjects: buildMapObjects(context),
      onMapCreated: (ym.YandexMapController controller) async {
        final pointsWithCoords = vm.state.pointBuyerRoutePointList
          .where((e) => e.point.latitude != null && e.point.longitude != null).toList();
        final latitudes = pointsWithCoords.map((e) => e.point.latitude!).toList();
        final longitudes = pointsWithCoords.map((e) => e.point.longitude!).toList();

        if (latitudes.isEmpty || longitudes.isEmpty) return;

        final geometry = ym.Geometry.fromBoundingBox(
          ym.BoundingBox(
            northEast: ym.Point(latitude: latitudes.reduce(max), longitude: longitudes.reduce(max)),
            southWest: ym.Point(latitude: latitudes.reduce(min), longitude: longitudes.reduce(min)),
          )
        );

        await retry(
          () async {
            final result = await controller.moveCamera(ym.CameraUpdate.newGeometry(geometry));

            if (!result) throw Exception('');
          },
          retryIf: (e) => true
        );
      },
    );
  }

  Color pointColor(PointBuyerRoutePoint pointBuyerRoutePoint) {
    final routePoints = pointBuyerRoutePoint.routePoints;

    if (routePoints.any((e) => e.date == DateTime.now().date())) {
      return Styles.greenColor;
    }

    if (routePoints.isNotEmpty && routePoints.none((e) => e.date == DateTime.now().date())) {
      return Styles.yellowColor;
    }

    if (routePoints.isEmpty) {
      return Styles.greyColor;
    }

    return Styles.blueColor;
  }
}
