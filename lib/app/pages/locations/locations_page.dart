import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retry/retry.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/locations_repository.dart';

part 'locations_state.dart';
part 'locations_view_model.dart';

class LocationsPage extends StatelessWidget {
  LocationsPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationsViewModel>(
      create: (context) => LocationsViewModel(
        RepositoryProvider.of<LocationsRepository>(context)
      ),
      child: _LocationsView(),
    );
  }
}

class _LocationsView extends StatefulWidget {
  @override
  _LocationsViewState createState() => _LocationsViewState();
}

class _LocationsViewState extends State<_LocationsView> {
  ym.PlacemarkMapObject? tappedPoint;
  List<ym.MapObject> mapObjects = [];

  List<ym.MapObject> buildMapObjects(BuildContext context) {
    final vm = context.read<LocationsViewModel>();
    final polyline = ym.Polyline(
      points: vm.state.locations.map((e) => ym.Point(latitude: e.latitude, longitude: e.longitude)).toList()
    );
    return [
      ym.PolylineMapObject(
        mapId: ym.MapObjectId('locaitons'),
        polyline: polyline
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsViewModel, LocationsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Маршрут')
          ),
          body: buildMap()
        );
      }
    );
  }

  Widget buildMap() {
    return ym.YandexMap(
      mapObjects: buildMapObjects(context),
      onMapCreated: (ym.YandexMapController controller) async {
        await retry(
          () async {
            final result = await controller.moveCamera(ym.CameraUpdate.newGeometry(mapBoundingBox()));

            if (!result) throw Exception('');
          },
          retryIf: (e) => true
        );
      }
    );
  }

  ym.Geometry mapBoundingBox() {
    LocationsViewModel vm = context.read<LocationsViewModel>();

    if (vm.state.locations.length > 1) {
      return ym.Geometry.fromPolyline(
        ym.Polyline(
          points: vm.state.locations.map((e) => ym.Point(latitude: e.latitude, longitude: e.longitude)).toList()
        )
      );
    }

    return ym.Geometry.fromPoint(ym.Point(latitude: 55.7558, longitude: 37.6173));
  }
}
