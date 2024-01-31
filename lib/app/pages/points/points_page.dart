import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:u_app_utils/u_app_utils.dart';
import 'package:retry/retry.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/points_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/widgets/widgets.dart';
import 'point/point_page.dart';
import '../orders_info/order/order_page.dart';

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
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PointsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _PointsView(),
    );
  }
}

class _PointsView extends StatefulWidget {
  @override
  _PointsViewState createState() => _PointsViewState();
}

class _PointsViewState extends State<_PointsView> with SingleTickerProviderStateMixin {
  late final progressDialog = ProgressDialog(context: context);
  late TabController tabController;
  static const int kSliverHeaderHeight = 104;
  ym.PlacemarkMapObject? tappedPoint;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    progressDialog.close();
    super.dispose();
  }

  Future<void> showVisitSkipDialog(RoutePointEx routePointEx) async {
    final vm = context.read<PointsViewModel>();
    final result = await showDialog<VisitSkipReason>(
      context: context,
      builder: (BuildContext context) {
        VisitSkipReason? visitSkipReason;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Необходимо указать причину'),
              content: SingleChildScrollView(
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Причина'),
                  value: visitSkipReason,
                  items: vm.state.visitSkipReasons.map((e) => DropdownMenuItem<VisitSkipReason>(
                    value: e,
                    child: Text(e.name)
                  )).toList(),
                  onChanged: (newVal) => setState(() => visitSkipReason = newVal)
                )
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: visitSkipReason != null ? () => Navigator.of(context).pop(visitSkipReason) : null,
                  child: const Text(Strings.ok)
                )
              ]
            );
          }
        );
      }
    );

    if (result != null) await vm.visit(routePointEx, result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointsViewModel, PointsState>(
      builder: (context, state) {
        final vm = context.read<PointsViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.pointsPageName),
            actions: [
              SaveButton(
                onSave: state.isLoading ? null : vm.syncChanges,
                pendingChanges: vm.state.pendingChanges,
              )
            ],
            bottom: TabBar(
              onTap: (_) => setState(() {}),
              controller: tabController,
              tabs: const [
                Tab(child: Text('Маршрут', style: Styles.tabStyle, softWrap: false)),
                Tab(child: Text('Точки', style: Styles.tabStyle, softWrap: false)),
              ],
            ),
          ),
          floatingActionButton: tabController.index == 0 ? FloatingActionButton(
            heroTag: null,
            onPressed: vm.addNewPoint,
            child: const Icon(Icons.add),
          ) : null,
          body: Refreshable(
            confirmRefresh: vm.state.pendingChanges != 0,
            onRefresh: vm.getData,
            onError: (error, stackTrace) {
              if (error is! AppError) Misc.reportError(error, stackTrace);
            },
            childBuilder: (context, physics) => TabBarView(
              controller: tabController,
              children: [
                buildRoutePointListView(context, physics),
                buildPointListView(context, physics),
              ]
            )
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case PointsStateStatus.orderAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openOrderPage(state.newOrder!);
            });
            break;
          case PointsStateStatus.pointAdded:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openPointPage(state.newPoint!);
            });
            break;
          case PointsStateStatus.visitInProgress:
            progressDialog.open();
            break;
          case PointsStateStatus.visitSuccess:
          case PointsStateStatus.visitFailure:
            progressDialog.close();
            Misc.showMessage(context, state.message);
            break;
          default:
        }
      },
    );
  }

  Widget buildPointListView(BuildContext context, ScrollPhysics physics) {
    return CustomScrollView(
      physics: physics,
      slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: buildHeader(context),
        ),
        SliverList(delegate: buildPointView(context))
      ]
    );
  }

  Widget buildRoutePointListView(BuildContext context, ScrollPhysics physics) {
    final vm = context.read<PointsViewModel>();
    final routePointDate = vm.state.routePointExList
      .groupFoldBy<DateTime, List<RoutePointEx>>((e) => e.routePoint.date, (acc, e) => (acc ?? [])..add(e));

    return ListView(
      physics: physics,
      padding: const EdgeInsets.only(top: 16),
      children: routePointDate.entries.sorted(
        (a, b) => a.key.compareTo(b.key)
      ).map((e) => buildRoutePointDateTile(context, e.key, e.value)).toList()
    );
  }

  Widget buildRoutePointDateTile(BuildContext context, DateTime date, List<RoutePointEx> routePointExList) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: Format.dateStr(date),
              style: const TextStyle(color: Colors.black)
            ),
            const TextSpan(text: ' ('),
            TextSpan(
              text: DateFormat.E('ru').format(date),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            ),
            const TextSpan(text: ')')
          ]
        )
      ),
      children: routePointExList.map((e) => buildRoutePointTile(context, e)).toList()
    );
  }

  Widget buildRoutePointTile(BuildContext context, RoutePointEx routePointEx) {
    final vm = context.read<PointsViewModel>();

    return ListTile(
      minLeadingWidth: 1,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: routePointEx.routePoint.visited == null ?
          const Icon(Icons.hourglass_empty, color: Colors.yellow) :
          routePointEx.routePoint.visited! ?
            const Icon(Icons.check, color: Colors.green) :
            const Icon(Icons.clear, color: Colors.red)
      ),
      title: Text(
        routePointEx.buyer != null ? routePointEx.buyer!.fullname : routePointEx.routePoint.name,
        style: Styles.tileText
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.indeterminate_check_box),
            onPressed: routePointEx.routePoint.visited == null ? () => showVisitSkipDialog(routePointEx) : null,
            tooltip: 'Отметить не посещение',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 16)
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: routePointEx.routePoint.visited == null ? () => vm.visit(routePointEx) : null,
            tooltip: 'Отметить посещение',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 16)
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: routePointEx.buyer != null ? () => vm.addNewOrder(routePointEx) : null,
            tooltip: 'Создать заказ',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 16)
          )
        ]
      ),
      dense: false
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

  SliverChildDelegate buildPointView(BuildContext context) {
    final vm = context.read<PointsViewModel>();
    final height = MediaQuery.of(context).size.height -
      kToolbarHeight -
      MediaQuery.of(context).padding.top -
      kBottomNavigationBarHeight -
      kSliverHeaderHeight;

    if (vm.state.listView) {
      return SliverChildListDelegate(vm.state.filteredPointExList.map((e) => buildPointTile(context, e)).toList());
    }

    return SliverChildListDelegate([SizedBox(
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
      ))]
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
    final needSync = pointEx.point.needSync || pointEx.images.any((e) => e.needSync);

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
      trailing: needSync ? Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) : null,
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

  Future<void> openOrderPage(OrderExResult orderEx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OrderPage(orderEx: orderEx),
        fullscreenDialog: false
      )
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
