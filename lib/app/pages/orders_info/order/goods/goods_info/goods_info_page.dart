import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/prices_repository.dart';
import 'price_change/price_change_page.dart';

part 'goods_info_state.dart';
part 'goods_info_view_model.dart';

class GoodsInfoPage extends StatelessWidget {
  final DateTime date;
  final Buyer buyer;
  final GoodsExResult goodsEx;

  GoodsInfoPage({
    required this.date,
    required this.buyer,
    required this.goodsEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoodsInfoViewModel>(
      create: (context) => GoodsInfoViewModel(
        date: date,
        buyer: buyer,
        goodsEx: goodsEx,
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PricesRepository>(context),
      ),
      child: _GoodsInfoView(),
    );
  }
}

class _GoodsInfoView extends StatefulWidget {
  @override
  _GoodsInfoViewState createState() => _GoodsInfoViewState();
}

class _GoodsInfoViewState extends State<_GoodsInfoView> {
  Future<void> showPriceChangeDialog() async {
    final vm = context.read<GoodsInfoViewModel>();

    final result = await showDialog<(DateTime dateFrom, DateTime dateTo, double price)>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => PriceChangePage(
        price: vm.state.curPartnersPrice?.price,
        dateFrom: DateTime.now().date(),
        dateTo: vm.state.curPartnersPrice?.dateTo,
        goodsEx: vm.state.goodsEx,
        goodsPricelist: vm.state.curGoodsPricelist!
      )
    );

    if (result != null) await vm.updatePrice(result.$1, result.$2, result.$3);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoodsInfoViewModel, GoodsInfoState>(
      builder: (context, state) {
        final goods = state.goodsEx.goods;

        return Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none)
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Товар'),
              centerTitle: true,
              actions: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.price_change),
                  tooltip: 'Показать актив',
                  onPressed: state.curGoodsPricelist != null ? showPriceChangeDialog : null
                ),
              ]
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 4),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(goods.name, style: Styles.tileTitleText.copyWith(fontWeight: FontWeight.bold))
                ),
                Padding(padding: const EdgeInsets.only(top: 16), child: buildGoodsImage(context)),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Преднаименование',
                    border: InputBorder.none
                  ),
                  initialValue: goods.preName
                ),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Штук в коробе',
                    border: InputBorder.none
                  ),
                  initialValue: goods.categoryPackageRel.toString()
                ),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Штук в блоке',
                    border: InputBorder.none
                  ),
                  initialValue: goods.categoryBlockRel.toString()
                ),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Вес короба',
                    border: InputBorder.none
                  ),
                  initialValue: Format.numberStr(goods.weight)
                ),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Объем короба',
                    border: InputBorder.none
                  ),
                  initialValue: Format.numberStr(goods.mcVol)
                ),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Себестоимость',
                    border: InputBorder.none
                  ),
                  initialValue: Format.numberStr(goods.cost)
                ),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Производитель',
                    border: InputBorder.none
                  ),
                  initialValue: goods.manufacturer
                ),
                TextFormField(
                  canRequestFocus: false,
                  enableInteractiveSelection: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    labelText: 'Срок годности',
                    border: InputBorder.none
                  ),
                  initialValue: '${goods.shelfLife} ${goods.shelfLifeTypeName.toLowerCase()}'
                ),
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: const Text('Продажи'),
                  children: state.goodsShipments.map((e) => buildGoodsShipmentTile(context, e)).toList()
                ),
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: const Text('Прайс-листы'),
                  trailing: state.needSync ? Icon(Icons.sync, color: Theme.of(context).colorScheme.primary) : null,
                  children: state.goodsPricelists.map((e) => buildGoodsPricelistTile(context, e)).toList()
                )
              ],
            )
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case GoodsInfoStateStatus.priceUpdated:
          case GoodsInfoStateStatus.pricelistUpdated:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop(true);
            });
            break;
          default:
        }
      }
    );
  }

  Widget buildGoodsPricelistTile(BuildContext context, GoodsPricelistsResult goodsPricelist) {
    final vm = context.read<GoodsInfoViewModel>();
    final active = vm.state.partnersPricelists.any((e) => e.pricelistId == goodsPricelist.id);
    final permitted = goodsPricelist.permit;

    return ListTile(
      trailing: active ? const Icon(Icons.check) : null,
      title: Text(goodsPricelist.name, style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Цена: ${Format.numberStr(goodsPricelist.price)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: permitted ? 'Можно поменять' : '',
              style: Styles.tileText
            )
          ]
        )
      ),
      onTap: permitted ? () => vm.updatePricelist(goodsPricelist) : null
    );
  }

  Widget buildGoodsShipmentTile(BuildContext context, GoodsShipmentsResult goodsShipment) {
    return ListTile(
      title: Text(Format.dateStr(goodsShipment.date), style: Styles.tileTitleText),
      subtitle: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Кол-во: ${goodsShipment.vol.toInt()}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Цена: ${Format.numberStr(goodsShipment.price)}\n',
              style: Styles.tileText
            ),
            TextSpan(
              text: 'Стоимость: ${Format.numberStr(goodsShipment.vol * goodsShipment.price)}\n',
              style: Styles.tileText
            )
          ]
        )
      )
    );
  }

  Widget buildGoodsImage(BuildContext context) {
    final vm = context.read<GoodsInfoViewModel>();

    return GestureDetector(
      onTap: () {
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            fullscreenDialog: false,
            builder: (BuildContext context) => ImagesView(
              images: [
                RetryableImage(
                  color: Theme.of(context).colorScheme.primary,
                  cached: vm.state.showLocalImage,
                  imageUrl: vm.state.goodsEx.goods.imageUrl,
                  cacheKey: vm.state.goodsEx.goods.imageKey,
                  cacheManager: OrdersRepository.goodsCacheManager,
                )
              ],
              idx: 0
            )
          )
        );
      },
      child: RetryableImage(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/5,
        color: Theme.of(context).colorScheme.primary,
        cached: vm.state.showLocalImage,
        imageUrl: vm.state.goodsEx.goods.imageUrl,
        cacheKey: vm.state.goodsEx.goods.imageKey,
        cacheManager: OrdersRepository.goodsCacheManager,
      )
    );
  }
}
