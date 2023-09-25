import 'dart:math';

import 'package:collection/collection.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/core.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/orders_repository.dart';
import '/app/repositories/prices_repository.dart';
import 'bonus_programs/bonus_programs_page.dart';
import 'goods_info/goods_info_page.dart';
import 'hand_price_change/hand_price_change_page.dart';

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
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    progressDialog.close();
  }

  Future<void> showBonusProgramSelectDialog([GoodsDetail? goodsDetail]) async {
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
            goodsEx: goodsDetail?.goodsEx
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
        fullscreenDialog: false
      )
    ) ?? false;

    if (result) await vm.updateGoodsPrices();
  }

  Future<void> showCategorySelectDialog() async {
    final vm = context.read<GoodsViewModel>();
    final result = await showDialog<CategoriesExResult>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: SizedBox(
            width: 360,
            child: Scaffold(
              appBar: AppBar(title: const Text('Выберите категорию')),
              body: buildCategoryView(
                context,
                (CategoriesExResult category) => Navigator.of(dialogContext).pop(category)
              )
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
                onPressed: () async {
                  Misc.unfocus(context);
                  await vm.clearFilters();
                }
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(166),
              child: buildHeader(context, compactMode)
            )
          ),
          body: Row(
            children: [
              compactMode ?
                Container() :
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: SizedBox(width: 260, child: buildCategoryView(context, vm.selectCategory))
                ),
              buildGoodsView(context, compactMode)
            ]
          ),
          bottomSheet: buildViewOptionsRow(context)
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

  Widget buildGoodsView(BuildContext context, bool compactMode) {
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

    return _GoodsGroupsView(
      key: Key(vm.state.goodsDetails.fold(0, (prev, e) => prev + e.goods.hashCode).toString()),
      groupedGoods: groupedGoods,
      showOnlyActive: vm.state.showOnlyActive,
      initiallyExpanded: vm.state.goodsListInitiallyExpanded,
      compactMode: compactMode,
      showGroupInfo: vm.state.showGroupInfo,
      showGoodsImage: vm.state.showGoodsImage,
      onVolChange: vm.updateOrderLineVol,
      orderEx: vm.state.orderEx,
      linesExList: vm.state.filteredOrderLinesExList,
      onBonusProgramTap: showBonusProgramSelectDialog,
      onTap: showGoodsInfoDialog
    );
  }

  Widget buildHeader(BuildContext context, bool compactMode) {
    final vm = context.read<GoodsViewModel>();

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                        tooltip: 'Очистить фильтры',
                      )
                  ),
                  controller: TextEditingController(text: vm.state.selectedBonusProgram?.name),
                  style: Styles.formStyle
                )
              )
            ],
          ),
          const SizedBox(height: 2),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Наименование',
              suffixIcon: vm.state.goodsNameSearch?.isEmpty ?? true ? null :  IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Очистить',
                onPressed: () => vm.setGoodsNameSearch(null)
              )
            ),
            onFieldSubmitted: vm.setGoodsNameSearch,
            autocorrect: false,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: vm.state.goodsFilters.map((e) => ChoiceChip(
        label: Text(e.name),
        labelStyle: Styles.formStyle,
        selected: e == vm.state.selectedGoodsFilter,
        onSelected: (bool selected) => vm.selectGoodsFilter(selected ? e : null)
      )).toList()
    );
  }

  Widget buildViewOptionsRow(BuildContext context) {
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
          Flexible(child: Text('Сумма: ${Format.numberStr(vm.state.total)}', style: Styles.formStyle))
        ]
      )
    );
  }

  Widget buildCategoryView(BuildContext context, void Function(CategoriesExResult) onCategoryTap) {
    final vm = context.read<GoodsViewModel>();
    final Map<String, List<CategoriesExResult>> groupedCategories = {};

    for (var e in vm.state.shopDepartments) {
      groupedCategories[e.name] = vm.state.visibleCategories.where((c) => c.shopDepartmentId == e.id).toList();
    }

    return _CategoriesView(
      key: Key(vm.state.visibleCategories.hashCode.toString()),
      selectedCategory: vm.state.selectedCategory,
      groupedCategories: groupedCategories,
      showOnlyActive: vm.state.showOnlyActive,
      initiallyExpanded: vm.state.categoriesListInitiallyExpanded,
      onCategoryTap: onCategoryTap
    );
  }
}

class _CategoriesView extends StatefulWidget {
  final Map<String, List<CategoriesExResult>> groupedCategories;
  final CategoriesExResult? selectedCategory;
  final void Function(CategoriesExResult) onCategoryTap;
  final bool showOnlyActive;
  final bool initiallyExpanded;

  _CategoriesView({
    required this.selectedCategory,
    required this.groupedCategories,
    required this.onCategoryTap,
    required this.showOnlyActive,
    required this.initiallyExpanded,
    Key? key
  }) : super(key: key);

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<_CategoriesView> {
  final Map<String, GlobalKey<ExpansionTileCustomState>> groupedCategoriesExpansion = {};
  final Map<String, bool> groupedCategoriesActive = {};
  late final AutoScrollController categoriesController = AutoScrollController(
    keepScrollOffset: false,
    axis: Axis.vertical,
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
  );

   void _scrollToIndex(AutoScrollController controller, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    widget.groupedCategories.entries.where((e) => e.value.isNotEmpty).forEachIndexed((index, e) {
      groupedCategoriesExpansion.putIfAbsent(e.key, () => GlobalKey());
      groupedCategoriesActive.putIfAbsent(e.key, () => widget.showOnlyActive);
      children.add(buildCategorySelectGroup(context, index, e.key, e.value));
    });

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomScrollView(
          controller: categoriesController,
          slivers: [
            SliverToBoxAdapter(child: Column(children: children)),
            SliverToBoxAdapter(child: SizedBox(height: constraints.maxHeight*0.9))
          ]
        );
      },
    );
  }

  Widget buildCategorySelectGroup(
    BuildContext context,
    int index,
    String name,
    List<CategoriesExResult> groupCategories
  ) {
    final showOnlyActive = groupedCategoriesActive[name]!;
    final children = groupCategories
      .where((e) => widget.showOnlyActive ? e.lastShipmentDate != null || !showOnlyActive : true)
      .map((e) => buildCategoryTile(e)).toList();

    return AutoScrollTag(
      controller: categoriesController,
      index: index,
      key: Key(name),
      child: ListTileTheme(
        tileColor: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: ExpansionTileItem(
            expansionKey: groupedCategoriesExpansion[name],
            initiallyExpanded: widget.initiallyExpanded,
            onExpansionChanged: (changed) {
              if (!changed) return;

              _scrollToIndex(categoriesController, index);
              for (var e in groupedCategoriesExpansion.entries) {
                if (e.key != name) e.value.currentState?.collapse();
              }
            },
            childrenPadding: EdgeInsets.zero,
            decoration: const BoxDecoration(),
            trailing: !widget.showOnlyActive ?
              Container(width: 0) :
              IconButton(
                color: Colors.white,
                icon: Icon(showOnlyActive ? Icons.access_time_filled : Icons.access_time),
                tooltip: 'Показать актив',
                onPressed: () => setState(() => groupedCategoriesActive[name] = !showOnlyActive)
              ),
            title: Text(name, style: const TextStyle(color: Colors.white)),
            children: children
          ),
        )
      )
    );
  }

  Widget buildCategoryTile(CategoriesExResult category) {
    return ListTile(
      title: buildCategoryTileTitle(category),
      tileColor: Colors.transparent,
      selected: category == widget.selectedCategory,
      onTap: () => widget.onCategoryTap.call(category)
    );
  }

  Widget buildCategoryTileTitle(CategoriesExResult category) {
    final daysDiff = category.lastShipmentDate != null ?
      DateTime.now().difference(category.lastShipmentDate!) :
      null;

    return Row(
      children: [
        Expanded(child: Text(category.name)),
        daysDiff == null ?
          Container() :
          Padding(
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
      ]
    );
  }
}

class _GoodsGroupsView extends StatefulWidget {
  final Map<String, List<GoodsDetail>> groupedGoods;
  final bool showOnlyActive;
  final bool initiallyExpanded;
  final bool showGroupInfo;
  final bool showGoodsImage;
  final bool compactMode;
  final void Function(GoodsDetail) onTap;
  final void Function(GoodsDetail) onBonusProgramTap;
  final void Function(GoodsDetail goodsDetail, double? vol) onVolChange;
  final OrderExResult orderEx;
  final List<OrderLineExResult> linesExList;

  _GoodsGroupsView({
    required this.groupedGoods,
    required this.showOnlyActive,
    required this.initiallyExpanded,
    required this.showGroupInfo,
    required this.showGoodsImage,
    required this.compactMode,
    required this.onTap,
    required this.onBonusProgramTap,
    required this.onVolChange,
    required this.orderEx,
    required this.linesExList,
    Key? key
  }) : super(key: key);

  @override
  _GoodsGroupsViewState createState() => _GoodsGroupsViewState();
}

class _GoodsGroupsViewState extends State<_GoodsGroupsView> {
  final Map<String, GlobalKey<ExpansionTileCustomState>> groupedGoodsExpansion = {};
  final Map<String, bool> groupedGoodsActive = {};
  late final AutoScrollController goodsController = AutoScrollController(
    keepScrollOffset: false,
    axis: Axis.vertical,
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
  );
  final Map<GoodsDetail, TextEditingController> volControllers = {};

  void _scrollToIndex(AutoScrollController controller, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    });
  }

  Widget buildGoodsViewGroup(BuildContext context, int index, String name, List<GoodsDetail> groupGoods) {
    final showOnlyActive = groupedGoodsActive[name]!;
    final children = groupGoods
      .where((g) => widget.showOnlyActive ? g.hadShipment || !showOnlyActive : true)
      .map((g) => buildGoodsTile(context, g)).toList();

    return AutoScrollTag(
      controller: goodsController,
      index: index,
      key: Key(name),
      child: ListTileTheme(
        tileColor: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: ExpansionTileItem(
            expansionKey: groupedGoodsExpansion[name],
            initiallyExpanded: widget.initiallyExpanded,
            onExpansionChanged: (changed) {
              if (!changed) return;

              _scrollToIndex(goodsController, index);
              for (var e in groupedGoodsExpansion.entries) {
                if (e.key != name) e.value.currentState?.collapse();
              }
            },
            childrenPadding: EdgeInsets.zero,
            decoration: const BoxDecoration(),
            trailing: !widget.showOnlyActive ?
              Container(width: 0) :
              IconButton(
                color: Colors.white,
                icon: Icon(showOnlyActive ? Icons.access_time_filled : Icons.access_time),
                tooltip: 'Показать актив',
                onPressed: () => setState(() => groupedGoodsActive[name] = !showOnlyActive)
              ),
            title: Text(name, style: const TextStyle(color: Colors.white)),
            children: children
          ),
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final items = widget.groupedGoods.entries.sorted((a, b) => a.key.compareTo(b.key));

    items.where((e) => e.value.isNotEmpty).forEachIndexed((index, e) {
      groupedGoodsExpansion.putIfAbsent(e.key, () => GlobalKey());
      groupedGoodsActive.putIfAbsent(e.key, () => widget.showOnlyActive);
      children.add(buildGoodsViewGroup(context, index, e.key, e.value));
    });

    final goodsIndex = !widget.showGroupInfo ?
      Container() :
      SizedBox(
        height: widget.compactMode ? 88 : 124,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            spacing: 4,
            runSpacing: -8,
            children: items.indexed.map((e) => ActionChip(
              label: Text(e.$2.key),
              labelStyle: Styles.formStyle,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              onPressed: () {
                for (var name in widget.groupedGoods.keys) {
                  groupedGoodsExpansion[name]?.currentState?.collapse();
                }
                groupedGoodsExpansion[e.$2.key]?.currentState?.expand();
                _scrollToIndex(goodsController, e.$1);
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
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return CustomScrollView(
                    controller: goodsController,
                    slivers: [
                      SliverToBoxAdapter(child: Column(children: children)),
                      SliverToBoxAdapter(child: SizedBox(height: constraints.maxHeight*0.9))
                    ]
                  );
                },
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 68),
            child: goodsIndex
          )
        ]
      )
    );
  }

  Widget buildGoodsTileTitle(BuildContext context, GoodsDetail goodsDetail) {
    final goodsEx = goodsDetail.goodsEx;
    final tags = goodsDetail.bonusPrograms;
    final daysDiff = goodsDetail.hadShipment ? DateTime.now().difference(goodsEx.lastShipmentDate!) : null;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: <InlineSpan>[
          TextSpan(
            text: goodsEx.goods.name,
            style: TextStyle(fontSize: 14.0, color: goodsDetail.stock?.isVollow ?? false ? Colors.pink : Colors.black)
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
                onPressed: () => widget.onBonusProgramTap(goodsDetail)
              )
            ),
          ))
        ]
      )
    );
  }

  Widget buildGoodsImage(BuildContext context, GoodsDetail goodsDetail) {
    final vm = context.read<GoodsViewModel>();

    if (!vm.state.showGoodsImage) return Container();

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
                  imageUrl: goodsDetail.goodsEx.goods.imageUrl,
                  cacheKey: goodsDetail.goodsEx.goods.imageKey,
                  cacheManager: OrdersRepository.goodsCacheManager,
                )
              ],
              idx: 0
            )
          )
        );
      },
      child: RetryableImage(
        height: widget.compactMode ? 120 : 240,
        width: widget.compactMode ? 150 : 300,
        color: Theme.of(context).colorScheme.primary,
        cached: vm.state.showLocalImage,
        imageUrl: goodsDetail.goodsEx.goods.imageUrl,
        cacheKey: goodsDetail.goodsEx.goods.imageKey,
        cacheManager: OrdersRepository.goodsCacheManager,
      )
    );
  }

  Widget buildGoodsTile(BuildContext context, GoodsDetail goodsDetail) {
    final vm = context.read<GoodsViewModel>();
    final orderLineEx = widget.linesExList.firstWhereOrNull((e) => e.line.goodsId == goodsDetail.goods.id);
    final enabled = goodsDetail.price != 0 &&
      !goodsDetail.goodsEx.restricted &&
      widget.orderEx.order.isEditable &&
      !widget.orderEx.order.needProcessing;

    if (vm.state.showWithPrice && goodsDetail.price == 0 && orderLineEx == null) return Container();
    if (goodsDetail.stock == null && orderLineEx == null) return Container();

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
          tileColor: Colors.transparent,
          trailing: buildGoodsTileTrailing(context, goodsDetail, orderLineEx, enabled),
          subtitle: _GoodsSubtitle(goodsDetail, orderLineEx),
          title: buildGoodsTileTitle(context, goodsDetail),
          onTap: !enabled ? null : () => widget.onTap(goodsDetail)
        ),
        buildGoodsImage(context, goodsDetail)
      ]
    );
  }

  Widget buildGoodsTileTrailing(
    BuildContext context,
    GoodsDetail goodsDetail,
    OrderLineExResult? orderLineEx,
    bool enabled
  ) {
    final controller = volControllers.putIfAbsent(
      goodsDetail,
      () => TextEditingController(text: orderLineEx?.line.vol.toInt().toString())
    );
    final volStr = orderLineEx?.line.vol.toInt().toString() ?? '';

    if (controller.text != volStr) controller.text = volStr;

    return SizedBox(
      width: 140,
      child: NumTextField(
        enabled: enabled,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decimal: false,
        controller: controller,
        style: Styles.formStyle.copyWith(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          border: !enabled ? InputBorder.none : null,
          suffixIcon: !enabled ? null : IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Увеличить кол-во',
            onPressed: () => widget.onVolChange(goodsDetail, (orderLineEx?.line.vol ?? 0) + goodsDetail.stockRel)
          ),
          prefixIcon: !enabled ? null : IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Уменьшить кол-во',
            onPressed: () => widget.onVolChange(goodsDetail, (orderLineEx?.line.vol ?? 0) - goodsDetail.stockRel)
          )
        ),
        onTap: () => widget.onVolChange(goodsDetail, Parsing.parseDouble(controller.text))
      )
    );
  }
}

class _GoodsSubtitle extends StatefulWidget {
  final GoodsDetail goodsDetail;
  final OrderLineExResult? orderLineEx;

  _GoodsSubtitle(
    this.goodsDetail,
    this.orderLineEx,
    {Key? key}
  ) : super(key: key);

  @override
  _GoodsSubtitleState createState() => _GoodsSubtitleState();
}

class _GoodsSubtitleState extends State<_GoodsSubtitle> {
  bool expanded = false;

  Future<void> showPriceChangeDialog() async {
    final vm = context.read<GoodsViewModel>();

    final result = await showDialog<double?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => HandPriceChangePage(
        minHandPrice: widget.goodsDetail.goods.handPrice!,
        handPrice: widget.orderLineEx!.line.price,
      )
    );

    if (result != null) await vm.updateOrderLinePrice(widget.orderLineEx!, result);
  }

  @override
  Widget build(BuildContext context) {
    final goodsEx = widget.goodsDetail.goodsEx;
    final goods = goodsEx.goods;
    final stock = widget.goodsDetail.stock;
    final stockVol = stock?.vol ?? 0;
    final price = widget.goodsDetail.pricelistPrice;
    final minPrice = min(goods.handPrice ?? double.infinity, goods.minPrice);
    final bonusPrice = widget.goodsDetail.price;
    final effPrice = (bonusPrice - (widget.orderLineEx?.line.priceOriginal ?? price)).abs();
    final linePrice = widget.orderLineEx?.line.price ?? bonusPrice;
    List<Widget> children = [];

    if (!expanded) {
      children.addAll([
        IconButton(
          icon: const Icon(Icons.expand_circle_down),
          onPressed: () => setState(() => expanded = true)
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Styles.defaultTextSpan.copyWith(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500
              ),
              children: <InlineSpan>[
                const TextSpan(text: 'Цена: '),
                (goods.handPrice ?? 0) > 0 ?
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: ActionChip(
                        onPressed: widget.orderLineEx == null ? null : showPriceChangeDialog,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        label: Text(
                          Format.numberStr(linePrice),
                          style: Styles.chipStyle.copyWith(
                            color: widget.orderLineEx == null ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                      )
                    )
                  ) :
                  TextSpan(text: Format.numberStr(linePrice)),
                TextSpan(
                  text: effPrice > 0 ? '(${Format.numberStr(price)})' : null,
                  style: TextStyle(
                    color: widget.goodsDetail.conditionalDiscount ? Colors.red : Colors.blue,
                    decoration: TextDecoration.lineThrough
                  )
                ),
                const TextSpan(text: ' руб.'),
                TextSpan(text: widget.goodsDetail.rel == 1 ? '\n' :'\nВложение: ${widget.goodsDetail.rel} '),
                TextSpan(text: 'Кратность: ${widget.goodsDetail.stockRel} '),
                TextSpan(text: 'Остаток: ${stockVol != 0 ? '' : '0 шт.'}'),
                TextSpan(text: stockVol~/goods.categoryPackageRel > 0 ?
                  '${stockVol~/goods.categoryPackageRel} к. ' :
                  null
                  ),
                TextSpan(text: stockVol%goods.categoryPackageRel > 0 ?
                  '${(stockVol%goods.categoryPackageRel).toInt()} шт. ' :
                  null
                ),
                TextSpan(
                  text: widget.orderLineEx != null ?
                    '\nСтоимость: ${Format.numberStr(widget.orderLineEx!.line.total)}' :
                    null
                ),
              ]
            )
          )
        )
      ]);
    } else {
      children.addAll([
        IconButton(
          icon: Transform.rotate(angle: pi, child: const Icon(Icons.expand_circle_down)),
          onPressed: () => setState(() => expanded = false)
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Styles.defaultTextSpan.copyWith(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: (goodsEx.lastPrice ?? 0) > 0 && (goods.handPrice ?? 0) > 0 ?
                    'Спец. цена: ${Format.numberStr(goodsEx.lastPrice)} ' :
                    null,
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                const TextSpan(text: 'Цена: '),
                (goods.handPrice ?? 0) > 0 ?
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: ActionChip(
                        onPressed: widget.orderLineEx == null ? null : showPriceChangeDialog,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        label: Text(
                          Format.numberStr(linePrice),
                          style: Styles.chipStyle.copyWith(
                            color: widget.orderLineEx == null ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                      )
                    )
                  ) :
                  TextSpan(text: Format.numberStr(linePrice)),
                TextSpan(
                  text: effPrice > 0 ? '(${Format.numberStr(price)})' : null,
                  style: TextStyle(
                    color: widget.goodsDetail.conditionalDiscount ? Colors.red : Colors.blue,
                    decoration: TextDecoration.lineThrough
                  )
                ),
                TextSpan(
                  text: ' руб.${goods.cost > 0 ? ' (${((linePrice - goods.cost)/goods.cost*100).round()}%)' : ''}'
                ),
                TextSpan(
                  text: minPrice != 0 && minPrice < bonusPrice ? ' Мин. цена: ${Format.numberStr(minPrice)} ' : null
                ),
                TextSpan(text: widget.goodsDetail.rel == 1 ? '\n' :'\nВложение: ${widget.goodsDetail.rel} '),
                TextSpan(text: 'Кратность: ${widget.goodsDetail.stockRel} '),
                TextSpan(text: 'Остаток: ${stockVol != 0 ? '' : '0 шт.'}'),
                TextSpan(text: stockVol~/goods.categoryPackageRel > 0 ?
                  '${stockVol~/goods.categoryPackageRel} к. ' :
                  null
                ),
                TextSpan(text: stockVol%goods.categoryPackageRel > 0 ?
                  '${(stockVol%goods.categoryPackageRel).toInt()} шт. ' :
                  null
                ),
                TextSpan(
                  text: widget.orderLineEx != null ?
                    '\nСтоимость: ${Format.numberStr(widget.orderLineEx!.line.total)}' :
                    null
                ),
              ]
            )
          )
        )
      ]);
    }

    return Row(children: children);
  }
}
