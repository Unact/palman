import 'dart:math';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/prices_repository.dart';
import '/app/utils/format.dart';
import '/app/utils/parsing.dart';
import '/app/widgets/widgets.dart';
import 'bonus_programs/bonus_programs_page.dart';
import 'goods_info/goods_info_page.dart';

part 'goods_state.dart';
part 'goods_view_model.dart';

class GoodsPage extends StatelessWidget {
  final OrderExResult orderEx;

  GoodsPage({
    required this.orderEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoodsViewModel>(
      create: (context) => GoodsViewModel(
        orderEx: orderEx,
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<PricesRepository>(context)
      ),
      child: _GoodsView(),
    );
  }
}

class _GoodsView extends StatefulWidget {
  @override
  _GoodsViewState createState() => _GoodsViewState();
}

class _GoodsViewState extends State<_GoodsView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  AutoScrollController controller = AutoScrollController();
  TreeViewController? categoryTreeController;
  final Map<GoodsDetail, TextEditingController> volControllers = {};
  final TextEditingController nameController = TextEditingController();

  Future<void> showBonusProgramSelectDialog([GoodsExResult? goodsEx]) async {
    final vm = context.read<GoodsViewModel>();
    final result = await showDialog<FilteredBonusProgramsResult>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: BonusProgramsPage(
            date: vm.state.orderEx.order.date!,
            buyer: vm.state.orderEx.buyer!,
            category: vm.state.selectedCategory,
            goodsEx: goodsEx
          )
        );
      }
    );

    if (result != null) await vm.selectBonusProgram(result);
  }

  Future<void> showGoodsInfoDialog(GoodsDetail goodsDetail) async {
    final vm = context.read<GoodsViewModel>();
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => GoodsInfoPage(
          date: vm.state.orderEx.order.date!,
          buyer: vm.state.orderEx.buyer!,
          goodsEx: goodsDetail.goodsEx
        ),
        fullscreenDialog: true
      )
    ) ?? false;

    if (result) await vm.updateGoodsPrices();
  }

  Future<void> showCategorySelectDialog() async {
    final vm = context.read<GoodsViewModel>();
    final result = await showDialog<Category>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: SizedBox(
            width: 360,
            child: Scaffold(
              appBar: AppBar(title: const Text('Выберите категорию')),
              body: buildCategorySelect(context, (Category category) => Navigator.of(dialogContext).pop(category))
            )
          )
        );
      }
    );

    if (result != null) await vm.selectCategory(result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoodsViewModel, GoodsState>(
      builder: (context, state) {
        final vm = context.read<GoodsViewModel>();
        final compactMode = MediaQuery.of(context).size.width < 700;

        if (nameController.text != state.goodsNameSearch) nameController.text = state.goodsNameSearch ?? '';

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [
              IconButton(
                color: Colors.white,
                icon: Icon(vm.state.showOnlyActive ? Icons.access_time_filled : Icons.access_time),
                tooltip: 'Показать актив',
                onPressed: vm.state.showOnlyOrder ? null : vm.toggleShowOnlyActive
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.checklist),
                tooltip: 'Показать заказ',
                onPressed: vm.toggleShowOnlyOrder,
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.cleaning_services),
                tooltip: 'Очистить',
                onPressed: vm.clearFilters,
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(166),
              child: buildHeader(context, compactMode)
            )
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 68, top: 12),
            child: Row(
              children: [
                compactMode ?
                  Container() :
                  SizedBox(width: 260, child: buildCategorySelect(context, vm.selectCategory)),
                buildGoodsView(context)
              ],
            )
          ),
          bottomSheet: buildViewOptionsRow(context, compactMode)
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case GoodsStateStatus.searchStarted:
            await progressDialog.open();
            break;
          case GoodsStateStatus.searchFinished:
            progressDialog.close();
            break;
          default:
        }
      }
    );
  }

  Widget buildGoodsView(BuildContext context) {
    final vm = context.read<GoodsViewModel>();
    final Map<String, List<GoodsDetail>> groupedGoods = {};

    if (vm.state.groupByManufacturer) {
      for (var e in vm.state.manufacturers) {
        groupedGoods[e] = vm.state.goodsDetails.where((g) => g.goods.manufacturer == e).toList();
      }
    } else {
      for (var e in vm.state.goodsFirstWords) {
        groupedGoods[e] = vm.state.goodsDetails.where((g) => g.goods.name.split(' ').first == e).toList();
      }
    }

    final itemScrollController = ItemScrollController();
    final items = groupedGoods.entries.sorted((a, b) => a.key.compareTo(b.key));
    List<bool> groupedGoodsExpanded = List.filled(items.length, false);
    final goodsIndex = !vm.state.showGroupInfo ?
      Container() :
      SizedBox(
        height: 124,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            spacing: 4,
            runSpacing: -8,
            children: items.indexed.map((e) => ActionChip(
              label: Text(e.$2.key),
              labelStyle: Styles.formStyle,
              onPressed: () {
                groupedGoodsExpanded = List.generate(items.length, (index) => index == e.$1);
                itemScrollController.jumpTo(index: e.$1);
              }
            )).toList()
          )
        )
      );

    return Expanded(
      child: Column(
        children: [
          Flexible(
            child: Material(
              color: Colors.transparent,
              child: ScrollablePositionedList.builder(
                addAutomaticKeepAlives: false,
                addSemanticIndexes: false,
                itemScrollController: itemScrollController,
                itemCount: groupedGoods.entries.length,
                itemBuilder: (context, index) {
                  final children = items[index].value.map((g) => buildGoodsTile(context, g)).whereNotNull().toList();

                  if (children.isEmpty) return Container();

                  return ListTileTheme(
                    tileColor: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: ExpansionTile(
                        key: Key(items[index].key),
                        collapsedBackgroundColor: Colors.red,
                        initiallyExpanded: groupedGoodsExpanded[index],
                        trailing: Container(width: 0),
                        title: Text(items[index].key, style: const TextStyle(color: Colors.white)),
                        children: children
                      ),
                    )
                  );
                }
              )
            )
          ),
          goodsIndex
        ]
      )
    );
  }

  Widget buildHeader(BuildContext context, bool compactMode) {
    final vm = context.read<GoodsViewModel>();

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              !compactMode ?
                Container() :
                SizedBox(
                  width: 160,
                  child: TextField(
                    readOnly: true,
                    enabled: !vm.state.showOnlyOrder,
                    decoration: InputDecoration(
                      labelText: 'Категория',
                      suffixIcon: IconButton(
                        onPressed: showCategorySelectDialog,
                        icon: const Icon(Icons.arrow_drop_down),
                        tooltip: 'Выбрать категорию',
                      )
                    ),
                    controller: TextEditingController(text: vm.state.selectedCategory?.name),
                    style: Styles.formStyle
                  )
                ),
              Flexible(
                child: TextField(
                  readOnly: true,
                  enabled: !vm.state.showOnlyOrder,
                  decoration: InputDecoration(
                    labelText: 'Акция',
                    suffixIcon: vm.state.selectedBonusProgram == null ?
                      IconButton(
                        onPressed: showBonusProgramSelectDialog,
                        icon: const Icon(Icons.arrow_drop_down),
                        tooltip: 'Выбрать акцию',
                      ) :
                      IconButton(
                        onPressed: () => vm.selectBonusProgram(null),
                        icon: const Icon(Icons.delete),
                        tooltip: 'Очистить',
                      )
                  ),
                  controller: TextEditingController(text: vm.state.selectedBonusProgram?.name),
                  style: Styles.formStyle
                )
              )
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Наименование'),
            onFieldSubmitted: vm.setGoodsNameSearch,
            autocorrect: false,
            enabled: !vm.state.showOnlyOrder,
            style: Styles.formStyle,
            controller: nameController,
          ),
          buildGoodsFiltersRow(context),
        ],
      )
    );
  }

  Widget buildGoodsFiltersRow(BuildContext context) {
    final vm = context.read<GoodsViewModel>();

    if (vm.state.goodsFilters.isEmpty) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: vm.state.goodsFilters.map((e) => ChoiceChip(
        label: Text(e.name),
        labelStyle: Styles.formStyle,
        selected: e == vm.state.selectedGoodsFilter,
        onSelected: vm.state.showOnlyOrder ? null : (bool selected) => vm.selectGoodsFilter(selected ? e : null)
      )).toList()
    );
  }

  Widget buildViewOptionsRow(BuildContext context, bool compactMode) {
    final vm = context.read<GoodsViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SegmentedButton(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: true, label: Text('ТМ', style: Styles.formStyle)),
              ButtonSegment<bool>(value: false, label: Text('Название', style: Styles.formStyle))
            ],
            showSelectedIcon: false,
            selected: {vm.state.groupByManufacturer},
            onSelectionChanged: vm.changeGroupByManufacturer,
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity(horizontal: 0, vertical: 0),
            ),
          ),
          IconButton(
            icon: vm.state.showGoodsImage ? const Icon(Icons.image) : const Icon(Icons.image_outlined),
            onPressed: vm.toggleShowGoodsImage,
            tooltip: 'Отобразить фото',
          ),
          IconButton(
            icon: vm.state.showGroupInfo ? const Icon(Icons.book) : const Icon(Icons.book_outlined),
            onPressed: vm.toggleShowGroupInfo,
            tooltip: 'Отобразить индекс'
          ),
          Text('Сумма: ${Format.numberStr(vm.state.total)}', style: Styles.formStyle)
        ]
      )
    );
  }

  Widget buildGoodsTileTitle(BuildContext context, GoodsDetail goodsDetail) {
    final goodsEx = goodsDetail.goodsEx;
    final goods = goodsEx.goods;
    final stock = goods.isFridge ? goodsEx.fridgeStock! : goodsEx.normalStock!;
    final tags = goodsDetail.bonusPrograms;
    final daysDiff = goodsEx.lastShipmentDate != null ? DateTime.now().difference(goodsEx.lastShipmentDate!) : null;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: <InlineSpan>[
          TextSpan(
            text: goodsEx.goods.name,
            style: TextStyle(fontSize: 14.0, color: stock.isVollow ? Colors.pink : Colors.black)
          ),
          daysDiff == null ?
            const TextSpan() :
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Chip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  labelPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  label: Text(daysDiff.inDays.toString(), style: Styles.chipStyle),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                )
              )
            ),
          goodsEx.goods.extraLabel.isEmpty ?
            const TextSpan() :
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Chip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  labelPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  label: Text(goodsEx.goods.extraLabel, style: Styles.chipStyle),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                )
              )
            ),
          ...tags.map((e) => WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: ActionChip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                labelPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                label: Text(e.tagText, style: Styles.chipStyle),
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onPressed: () => showBonusProgramSelectDialog(goodsEx)
              )
            ),
          ))
        ]
      )
    );
  }

  Widget buildGoodsTileSubtitle(BuildContext context, GoodsDetail goodsDetail) {
    final vm = context.read<GoodsViewModel>();
    final goodsEx = goodsDetail.goodsEx;
    final goods = goodsEx.goods;
    final orderLineEx = vm.state.filteredOrderLinesExList.firstWhereOrNull((e) => e.line.goodsId == goods.id);
    final stock = goodsDetail.stock;
    final price = goodsDetail.pricelistPrice;
    final minPrice = min(goods.handPrice ?? double.infinity, goods.minPrice);
    final bonusPrice = goodsDetail.price;
    final effPrice = (bonusPrice - (orderLineEx?.line.priceOriginal ?? price)).abs();
    final linePrice = orderLineEx?.line.price ?? bonusPrice;

    return RichText(
      text: TextSpan(
        style: Styles.defaultTextSpan.copyWith(fontSize: 12),
        children: <InlineSpan>[
          TextSpan(
            text: (goodsEx.lastPrice ?? 0) > 0 && (goods.handPrice ?? 0) > 0 ?
              'Спец. цена: ${Format.numberStr(goodsEx.lastPrice)} ' :
              null,
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          TextSpan(
            text: 'Цена: ${Format.numberStr(linePrice)}',
            style: TextStyle(fontWeight: (goods.handPrice ?? 0) > 0 ? FontWeight.bold : FontWeight.normal)
          ),
          TextSpan(
            text: effPrice > 0 ? '(${Format.numberStr(price)})' : null,
            style: TextStyle(
              color: goodsDetail.conditionalDiscount ? Colors.red : Colors.blue,
              decoration: TextDecoration.lineThrough
            )
          ),
          TextSpan(text: ' руб.${goods.cost > 0 ? ' (${((linePrice - goods.cost)/goods.cost*100).round()}%)' : ''}',),
          TextSpan(
            text: minPrice != 0 && minPrice < bonusPrice ? ' Мин. цена: ${Format.numberStr(minPrice)} ' : null
          ),
          TextSpan(text: goodsDetail.rel == 1 ? '\n' :'\nВложение: ${goodsDetail.rel} '),
          TextSpan(text: 'Кратность: ${goodsDetail.stockRel} '),
          const TextSpan(text: 'Остаток: '),
          TextSpan(text: stock.vol~/goods.categoryPackageRel > 0 ? '${stock.vol~/goods.categoryPackageRel} к. ' : null),
          TextSpan(text: stock.vol%goods.categoryPackageRel > 0 ?
            '${(stock.vol%goods.categoryPackageRel).toInt()} шт. ' :
            null
          ),
          TextSpan(text: orderLineEx != null ? '\nСтоимость: ${Format.numberStr(orderLineEx.line.total)}' : null),
        ]
      )
    );
  }

  Widget? buildGoodsTileLeading(BuildContext context, GoodsDetail goodsDetail) {
    final vm = context.read<GoodsViewModel>();

    if (!vm.state.showGoodsImage) return null;

    final image = EntityImage(
      local: vm.state.showLocalImage,
      imageUrl: goodsDetail.goodsEx.goods.imageUrl,
      imagePath: goodsDetail.goodsEx.goods.imagePath,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => ImagesView(images: [image], idx: 0)
          )
        );
      },
      child: SizedBox(
        width: 80,
        height: 100,
        child: image
      )
    );
  }

  Widget? buildGoodsTile(BuildContext context, GoodsDetail goodsDetail) {
    final vm = context.read<GoodsViewModel>();

    if (goodsDetail.goodsEx.lastShipmentDate == null && vm.state.showOnlyActive) return null;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
      tileColor: Theme.of(context).scaffoldBackgroundColor,
      leading: buildGoodsTileLeading(context, goodsDetail),
      trailing: buildGoodsTileTrailing(context, goodsDetail),
      subtitle: buildGoodsTileSubtitle(context, goodsDetail),
      title: buildGoodsTileTitle(context, goodsDetail),
      onTap: () => showGoodsInfoDialog(goodsDetail),
    );
  }

  Widget buildGoodsTileTrailing(BuildContext context, GoodsDetail goodsDetail) {
    final vm = context.read<GoodsViewModel>();
    final orderLineEx = vm.state.filteredOrderLinesExList
      .firstWhereOrNull((e) => e.line.goodsId == goodsDetail.goods.id);
    final controller = volControllers.putIfAbsent(
      goodsDetail,
      () => TextEditingController(text: orderLineEx?.line.vol.toInt().toString())
    );
    final volStr = orderLineEx?.line.vol.toInt().toString() ?? '';
    final enabled = !(goodsDetail.price == 0 || goodsDetail.goodsEx.restricted);

    if (controller.text != volStr) controller.text = volStr;

    return SizedBox(
      width: 120,
      child: NumTextField(
        enabled: enabled,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decimal: false,
        controller: controller,
        style: Styles.formStyle,
        decoration: InputDecoration(
          border: !enabled ? InputBorder.none : null,
          prefixIcon: !enabled ? null : IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Увеличить кол-во',
            onPressed: () => vm.updateOrderLineVol(goodsDetail, (orderLineEx?.line.vol ?? 0) + goodsDetail.stockRel)
          ),
          suffixIcon: !enabled ? null : IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Уменьшить кол-во',
            onPressed: () => vm.updateOrderLineVol(goodsDetail, (orderLineEx?.line.vol ?? 0) - goodsDetail.stockRel)
          )
        ),
        onTap: () => vm.updateOrderLineVol(goodsDetail, Parsing.parseDouble(controller.text))
      )
    );
  }

  Widget buildCategorySelect(BuildContext context, Function onCategoryTap) {
    final vm = context.read<GoodsViewModel>();
    final TreeNode root = TreeNode.root(data: '');

    if (vm.state.shopDepartments.isEmpty) return Container();

    for (var e in vm.state.shopDepartments) {
      final node = TreeNode(key: 'shopDepartment-${e.id}', data: e);
      final shopCategories = vm.state.visibleCategories.where((c) => c.shopDepartmentId == e.id);

      if (shopCategories.isEmpty) continue;

      node.addAll(shopCategories.map((c) => TreeNode(key: 'category-${c.id}', data: c)).toList());

      root.add(node);
    }

    return TreeView.simple(
      padding: EdgeInsets.zero,
      tree: root,
      scrollController: controller,
      expansionBehavior: ExpansionBehavior.none,
      expansionIndicatorBuilder: (p0, p1) => NoExpansionIndicator(tree: root),
      showRootNode: false,
      onItemTap: (node) {
        if (vm.state.showOnlyOrder) return;

        if (node.data is Category) {
          onCategoryTap.call(node.data as Category);
          return;
        }

        for (var element in root.childrenAsList) {
          if (element != node && categoryTreeController!.elementAt(element.path).isExpanded) {
            categoryTreeController!.collapseNode(element as TreeNode);
          }
        }
      },
      builder: (context, node) => ListTile(
        enabled: !vm.state.showOnlyOrder,
        selected: node.data == vm.state.selectedCategory,
        title: Text(node.data.name),
      ),
      onTreeReady: (controller) => categoryTreeController = controller
    );
  }
}
