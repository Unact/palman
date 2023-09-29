import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/points_repository.dart';
import 'point/point_page.dart';

part 'points_state.dart';
part 'points_view_model.dart';

class PointsPage extends StatelessWidget {
  PointsPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PointsViewModel>(
      create: (context) => PointsViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<PointsRepository>(context),
      ),
      child: _PointsView(),
    );
  }
}

class _PointsView extends StatefulWidget {
  @override
  _PointsViewState createState() => _PointsViewState();
}

class _PointsViewState extends State<_PointsView> {
  static const int kSliverHeaderHeight = 82;
  ym.PlacemarkMapObject? tappedPoint;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointsViewModel, PointsState>(
      builder: (context, state) {
        final vm = context.read<PointsViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.pointsPageName),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: buildHeader(context)
            )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: vm.addNewPoint,
            child: const Icon(Icons.add),
          ),
          body:  buildPointView(context)
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case PointsStateStatus.pointAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openPointPage(state.newPoint!);
            });
            break;
          default:
        }
      },
    );
  }

  Widget buildHeader(BuildContext context) {
    final vm = context.read<PointsViewModel>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DropdownButton(
            style: Theme.of(context).textTheme.titleMedium!.merge(Styles.formStyle),
            value: vm.state.selectedReason,
            items: PointsState.kReasonFilter.map<DropdownMenuItem<(String, String)>>(((String, String) v) {
              return DropdownMenuItem<(String, String)>(
                value: v,
                child: Text(v.$2),
              );
            }).toList(),
            onChanged: (v) => vm.changeSelectedReason(v!)
          ),
          SegmentedButton(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(
                value: true,
                label: Text('Список', style: Styles.formStyle)
              ),
              ButtonSegment<bool>(
                value: false,
                label: Text('Карта', style: Styles.formStyle)
              )
            ],
            showSelectedIcon: false,
            selected: {vm.state.listView},
            onSelectionChanged: (set) => vm.updateListView(set.first),
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity(horizontal: 0, vertical: 0),
            ),
          ),
        ]
      )
    );
  }

  Widget buildPointView(BuildContext context) {
    final vm = context.read<PointsViewModel>();
    final height = MediaQuery.of(context).size.height -
      kToolbarHeight -
      MediaQuery.of(context).padding.top -
      kBottomNavigationBarHeight -
      kSliverHeaderHeight;

    if (vm.state.listView) {
      return ListView(children: vm.state.filteredPointExList.map((e) => buildPointTile(context, e)).toList());
    }

    return SizedBox(
      height: height,
      child: ym.YandexMap(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
        },
        mapObjects: buildMapObjects(context),
        onMapCreated: (ym.YandexMapController controller) async {
          final pointsWithCoords = vm.state.filteredPointExList
            .where((e) => e.point.latitude != null && e.point.longitude != null).toList();
          final latitudes = pointsWithCoords.map((e) => e.point.latitude!).toList();
          final longitudes = pointsWithCoords.map((e) => e.point.longitude!).toList();

          if (latitudes.isEmpty || longitudes.isEmpty) return;

          ym.BoundingBox boundingBox = ym.BoundingBox(
            northEast: ym.Point(latitude: latitudes.reduce(max), longitude: longitudes.reduce(max)),
            southWest: ym.Point(latitude: latitudes.reduce(min), longitude: longitudes.reduce(min)),
          );

          await controller.moveCamera(ym.CameraUpdate.newBounds(boundingBox));
        },
      )
    );
  }

  List<ym.PlacemarkMapObject> buildMapObjects(BuildContext context) {
    final vm = context.read<PointsViewModel>();

    return vm.state.filteredPointExList
      .where((e) => e.point.latitude != null && e.point.longitude != null)
      .map((e) {
        final mapId = ym.MapObjectId('${e.point.id}');
        const textStyle = ym.PlacemarkTextStyle(placement: ym.TextStylePlacement.top);
        return ym.PlacemarkMapObject(
          mapId: mapId,
          point: ym.Point(latitude: e.point.latitude!, longitude: e.point.longitude!),
          consumeTapEvents: true,
          opacity: 0.75,
          icon: ym.PlacemarkIcon.single(ym.PlacemarkIconStyle(
            image: ym.BitmapDescriptor.fromAssetImage(
              e.filled ? 'assets/filled_placeicon.png' : 'assets/not_filled_placeicon.png'
            )
          )),
          text: ym.PlacemarkText(text: (tappedPoint?.mapId == mapId) ? e.point.buyerName : '', style: textStyle),
          onTap: (self, point) => setState(() => tappedPoint = self)
        );
      }).toList();
  }

  Widget buildPointTile(BuildContext context, PointEx pointEx) {
    final vm = context.read<PointsViewModel>();

    final tile = ListTile(
      contentPadding: const EdgeInsets.all(8),
      minLeadingWidth: 1,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: pointEx.filled ?
          const Icon(Icons.check, color: Colors.green) :
          const Icon(Icons.hourglass_empty, color: Colors.yellow)
      ),
      title: Text(pointEx.point.buyerName, style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Адрес: ${pointEx.point.address ?? Strings.nullSubstitute}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Вывеска: ${pointEx.point.name}',
              style: Styles.tileText
            )
          ]
        )
      ),
      dense: true,
      trailing: pointEx.point.needSync ? Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) : null,
      onTap: () => openPointPage(pointEx)
    );

    if (!pointEx.point.isNew) return tile;

    return Dismissible(
      key: Key(pointEx.hashCode.toString()),
      background: Container(color: Colors.red[500]),
      onDismissed: (direction) => vm.deletePoint(pointEx),
      confirmDismiss: (direction) => ConfirmationDialog(
        context: context,
        confirmationText: 'Вы точно хотите удалить точку?'
      ).open(),
      child: tile
    );
  }

  Future<void> openPointPage(PointEx pointEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PointPage(pointEx: pointEx),
        fullscreenDialog: false
      )
    );
  }
}
