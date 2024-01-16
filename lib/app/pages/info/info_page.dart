import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/home/home_page.dart';
import '/app/pages/person/person_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/debts_repository.dart';
import '/app/repositories/locations_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/points_repository.dart';
import '/app/repositories/prices_repository.dart';
import '/app/repositories/return_acts_repository.dart';
import '/app/repositories/shipments_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/widgets/widgets.dart';

part 'info_state.dart';
part 'info_view_model.dart';

class InfoPage extends StatelessWidget {
  InfoPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoViewModel>(
      create: (context) => InfoViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<DebtsRepository>(context),
        RepositoryProvider.of<LocationsRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PointsRepository>(context),
        RepositoryProvider.of<PricesRepository>(context),
        RepositoryProvider.of<ReturnActsRepository>(context),
        RepositoryProvider.of<ShipmentsRepository>(context),
        RepositoryProvider.of<UsersRepository>(context),
      ),
      child: _InfoView(),
    );
  }
}

class _InfoView extends StatefulWidget {
  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<_InfoView> {
  final ScrollController scrollController = ScrollController();
  final EasyRefreshController refreshController = EasyRefreshController();

  void changePage(int index) {
    final homeVm = context.read<HomeViewModel>();

    homeVm.setCurrentIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InfoViewModel, InfoState>(
      builder: (context, state) {
        final vm = context.read<InfoViewModel>();
        final lastLoadTime = state.appInfo?.lastLoadTime != null ?
          Format.dateTimeStr(state.appInfo?.lastLoadTime) :
          'Загрузка не проводилась';

        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(onLongPress: vm.regenerateGuids, child: const Text(Strings.ruAppName)),
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.local_mall_sharp),
                tooltip: 'Загрузить фотографии точек',
                onPressed: state.isLoading || !state.pointImagePreloadCanceled ?
                  null :
                  vm.preloadPointImages
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.warehouse),
                tooltip: 'Загрузить фотографии товаров',
                onPressed: state.isLoading || !state.goodsImagePreloadCanceled ?
                  null :
                  vm.preloadGoodsImages
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.person),
                tooltip: 'Пользователь',
                onPressed: state.isLoading ?
                  null :
                  () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PersonPage(),
                        fullscreenDialog: false
                      )
                    );
                  }
              ),
              SaveButton(
                onSave: state.isLoading ? null : vm.syncChanges,
                pendingChanges: vm.state.pendingChanges,
              )
            ]
          ),
          body: Refreshable(
            scrollController: scrollController,
            refreshController: refreshController,
            processingText: state.toLoad != 0 ? 'Загружено ${state.loaded} из ${state.toLoad} словарей' : 'Загрузка',
            messageText: 'Последнее обновление: $lastLoadTime',
            pendingChanges: vm.state.pendingChanges,
            onRefresh: vm.getData,
            childBuilder: (context, physics) => ListView(
              physics: physics,
              padding: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildInfoCards(context)
                )
              ],
            )
          )
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case InfoStateStatus.reloadNeeded:
            context.read<GlobalKey<ScaffoldMessengerState>>().currentState!.showSnackBar(SnackBar(
              content: Text(state.message),
              actionOverflowThreshold: 1,
              action: SnackBarAction(
                label: 'Обновить',
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  changePage(0);
                  refreshController.callRefresh(scrollController: scrollController);
                }
              ),
            ));
            break;
          case InfoStateStatus.locationUpdateFailure:
          case InfoStateStatus.imageLoadInProgress:
          case InfoStateStatus.imageLoadSuccess:
          case InfoStateStatus.imageLoadCanceled:
          case InfoStateStatus.imageLoadFailure:
          case InfoStateStatus.guidRegenerateSuccess:
          case InfoStateStatus.guidRegenerateFailure:
            Misc.showMessage(context, state.message);
            break;
          default:
            break;
        }
      },
    );
  }

  List<Widget> buildInfoCards(BuildContext context) {
    return <Widget>[
      buildPointsCard(context),
      buildDebtsCard(context),
      buildOrdersCard(context),
      buildReturnActsCard(context),
      buildPreloadPointImagesCard(context),
      buildPreloadGoodsImagesCard(context),
      buildInfoCard(context),
      buildErrorCard(context)
    ];
  }

  Widget buildPointsCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: () => changePage(1),
        title: const Text(Strings.pointsPageName, style: Styles.tileTitleText),
        subtitle: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Загружено: ${vm.state.pointsTotal}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'В маршруте: ${vm.state.routePointsTotal}',
                style: Styles.tileText
              )
            ]
          )
        )
      )
    );
  }

  Widget buildPreloadPointImagesCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    if (vm.state.pointImages.isEmpty) return Container();

    return Card(
      child: ListTile(
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          tooltip: 'Отменить',
          onPressed: vm.cancelPreloadPointImages
        ),
        isThreeLine: true,
        title: const Text('Загрузка фотографий точек', style: Styles.tileTitleText),
        subtitle: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Загружено: ${vm.state.loadedPointImages}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'Всего: ${vm.state.pointImages.length}',
                style: Styles.tileText
              )
            ]
          )
        )
      )
    );
  }

  Widget buildPreloadGoodsImagesCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    if (vm.state.goodsWithImage.isEmpty) return Container();

    return Card(
      child: ListTile(
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          tooltip: 'Отменить',
          onPressed: vm.cancelPreloadGoodsImages
        ),
        isThreeLine: true,
        title: const Text('Загрузка фотографий товаров', style: Styles.tileTitleText),
        subtitle: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Загружено: ${vm.state.loadedGoodsImages}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'Всего: ${vm.state.goodsWithImage.length}',
                style: Styles.tileText
              )
            ]
          )
        )
      )
    );
  }

  Widget buildDebtsCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: () => changePage(2),
        title: const Text(Strings.debtsInfoPageName, style: Styles.tileTitleText),
        subtitle: Text('Инкассаций: ${vm.state.preEncashmentsTotal}', style: Styles.tileText)
      )
    );
  }

  Widget buildOrdersCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: () => changePage(3),
        title: const Text(Strings.ordersInfoPageName, style: Styles.tileTitleText),
        subtitle: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Заказов: ${vm.state.ordersTotal}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'Предзаказов: ${vm.state.preOrdersTotal}\n',
                style: Styles.tileText
              ),
              TextSpan(
                text: 'Отгрузок: ${vm.state.shipmentsTotal}',
                style: Styles.tileText
              )
            ]
          )
        )
      )
    );
  }

  Widget buildReturnActsCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: () => changePage(4),
        title: const Text(Strings.returnActsPageName, style: Styles.tileTitleText),
        subtitle: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Актов: ${vm.state.returnActsTotal}\n',
                style: Styles.tileText
              )
            ]
          )
        )
      )
    );
  }

  Widget buildInfoCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    return FutureBuilder(
      future: vm.state.user?.newVersionAvailable,
      builder: (context, snapshot) {
        if (!(snapshot.data ?? false)) return Container();

        return const Card(
          child: ListTile(
            isThreeLine: true,
            title: Text('Информация', style: Styles.tileTitleText),
            subtitle: Text('Доступна новая версия приложения', style: Styles.tileText),
          )
        );
      }
    );
  }

  Widget buildErrorCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    if (vm.state.syncMessage.isEmpty) return Container();

    return Card(
      child: ListTile(
        isThreeLine: true,
        title: const Text('Синхронизация', style: Styles.tileTitleText),
        subtitle: Text(vm.state.syncMessage, style: Styles.tileText.copyWith(color: Colors.red)),
      )
    );
  }
}
