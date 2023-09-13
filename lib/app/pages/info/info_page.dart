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
import '/app/repositories/partners_repository.dart';
import '/app/repositories/points_repository.dart';
import '/app/repositories/prices_repository.dart';
import '/app/repositories/shipments_repository.dart';
import '/app/repositories/users_repository.dart';

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
        RepositoryProvider.of<PartnersRepository>(context),
        RepositoryProvider.of<PointsRepository>(context),
        RepositoryProvider.of<PricesRepository>(context),
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
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  Completer<IndicatorResult> refresherCompleter = Completer();

  Future<void> openRefresher() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshIndicatorKey.currentState!.show();
    });
  }

  void closeRefresher(IndicatorResult result) {
    refresherCompleter.complete(result);
    refresherCompleter = Completer();
  }

  void changePage(int index) {
    final homeVm = context.read<HomeViewModel>();

    homeVm.setCurrentIndex(index);
  }

  void setPageChangeable(bool pageChangeable) {
    final homeVm = context.read<HomeViewModel>();

    homeVm.setPageChangeable(pageChangeable);
  }

  Future<void> showConfirmationDialog() async {
    final vm = context.read<InfoViewModel>();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Внимание'),
          content: const SingleChildScrollView(child: Text('Присутствуют не сохраненные изменения. Продолжить?')),
          actions: <Widget>[
            TextButton(child: const Text(Strings.ok), onPressed: () => Navigator.of(context).pop(false)),
            TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(true))
          ],
        );
      }
    ) ?? true;

    await vm.getData(result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InfoViewModel, InfoState>(
      builder: (context, state) {
        final vm = context.read<InfoViewModel>();
        final lastSyncTime = state.appInfo?.lastSyncTime != null ?
          Format.dateTimeStr(state.appInfo?.lastSyncTime) :
          'Загрузка не проводилась';

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.ruAppName),
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.local_mall_sharp),
                tooltip: 'Загрузить фотографии точек',
                onPressed: state.isBusy || !state.pointImagePreloadCanceled ?
                  null :
                  vm.preloadPointImages
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.warehouse),
                tooltip: 'Загрузить фотографии товаров',
                onPressed: state.isBusy || !state.goodsImagePreloadCanceled ?
                  null :
                  vm.preloadGoodsImages
              ),
              Center(
                child: Badge(
                  backgroundColor: Colors.green,
                  label: Text(state.pendingChanges.toString()),
                  isLabelVisible: state.hasPendingChanges,
                  offset: const Offset(-4, 4),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.save),
                    splashRadius: 12,
                    tooltip: 'Сохранить изменения',
                    onPressed: state.isBusy || !state.hasPendingChanges ? null : vm.saveChangesForeground
                  )
                ),
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.person),
                tooltip: 'Пользователь',
                onPressed: state.isBusy ?
                  null :
                  () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PersonPage(),
                        fullscreenDialog: true
                      )
                    );
                  }
              )
            ]
          ),
          body: EasyRefresh(
            header: ClassicHeader(
              dragText: 'Потяните чтобы обновить',
              armedText: 'Отпустите чтобы обновить',
              readyText: 'Загрузка',
              processingText: state.toLoad != 0 ? 'Загружено ${state.loaded} из ${state.toLoad} словарей' : 'Загрузка',
              messageText: 'Последнее обновление: $lastSyncTime',
              failedText: state.message,
              processedText: 'Словари успешно обновлены',
              noMoreText: 'Идет сохранение данных'
            ),
            onRefresh: () async {
              if (vm.state.isBusy) return IndicatorResult.noMore;

              setPageChangeable(false);
              vm.tryGetData();
              final result = await refresherCompleter.future;
              setPageChangeable(true);

              return result;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
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
          case InfoStateStatus.imageLoadInProgress:
          case InfoStateStatus.imageLoadSuccess:
          case InfoStateStatus.imageLoadCanceled:
          case InfoStateStatus.imageLoadFailure:
            Misc.showMessage(context, state.message);
            break;
          case InfoStateStatus.loadConfirmation:
            showConfirmationDialog();
            break;
          case InfoStateStatus.loadDeclined:
            closeRefresher(IndicatorResult.fail);
            break;
          case InfoStateStatus.loadFailure:
            closeRefresher(IndicatorResult.fail);
            break;
          case InfoStateStatus.loadSuccess:
            closeRefresher(IndicatorResult.success);
            break;
          case InfoStateStatus.saveInProgress:
            progressDialog.open();
            break;
          case InfoStateStatus.saveFailure:
          case InfoStateStatus.saveSuccess:
            Misc.showMessage(context, state.message);
            progressDialog.close();
            break;
          case InfoStateStatus.syncInProgress:
            setPageChangeable(false);
            break;
          case InfoStateStatus.syncSuccess:
          case InfoStateStatus.syncFailure:
            setPageChangeable(true);
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
        title: const Text(Strings.pointsPageName),
        subtitle: Text('Загружено: ${vm.state.pointsTotal}', style: Styles.tileText)
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
        title: const Text('Загрузка фотографий точек'),
        subtitle: RichText(
          text: TextSpan(
            style: Styles.defaultTextSpan,
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
        title: const Text('Загрузка фотографий товаров'),
        subtitle: RichText(
          text: TextSpan(
            style: Styles.defaultTextSpan,
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
        title: const Text(Strings.debtsInfoPageName),
        subtitle: Text('Инкассаций: ${vm.state.encashmentsTotal}', style: Styles.tileText)
      )
    );
  }

  Widget buildOrdersCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: () => changePage(3),
        title: const Text(Strings.ordersInfoPageName),
        subtitle: RichText(
          text: TextSpan(
            style: Styles.defaultTextSpan,
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

  Widget buildInfoCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    if (!vm.state.newVersionAvailable) return Container();

    return const Card(
      child: ListTile(
        isThreeLine: true,
        title: Text('Информация'),
        subtitle: Text('Доступна новая версия приложения'),
      )
    );
  }

  Widget buildErrorCard(BuildContext context) {
    final vm = context.read<InfoViewModel>();

    if (vm.state.syncMessage.isEmpty) return Container();

    return Card(
      child: ListTile(
        isThreeLine: true,
        title: const Text('Синхронизация'),
        subtitle: Text(vm.state.syncMessage, style: const TextStyle(color: Colors.redAccent)),
      )
    );
  }
}
