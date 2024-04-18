import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:expandable_sliver_list/expandable_sliver_list.dart';
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
        RepositoryProvider.of<OrdersRepository>(context)
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
  final TextEditingController nameController = TextEditingController();

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
            categoryEx: vm.state.selectedCategory,
            goodsEx: goodsDetail?.goodsEx
          )
        );
      }
    );

    if (result != null) await vm.selectBonusProgram(result);
  }

  Future<void> showGoodsInfoDialog(GoodsDetail goodsDetail) async {
    final vm = context.read<GoodsViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => GoodsInfoPage(
          date: vm.state.orderEx.order.date!,
          buyer: vm.state.orderEx.buyer!,
          goodsEx: goodsDetail.goodsEx
        ),
        fullscreenDialog: false
      )
    );
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
                (CategoriesExResult categoryEx) => Navigator.of(dialogContext).pop(categoryEx)
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
    return BlocBuilder<GoodsViewModel, GoodsState>(
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
                tooltip: 'Очистить фильтры',
                onPressed: () async {
                  Misc.unfocus(context);
                  await vm.clearFilters();
                }
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(compactMode ? 166 : 116),
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
              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(disabledBorder: InputBorder.none)
                ),
                child: buildGoodsView(context, compactMode)
              )
            ]
          ),
          bottomSheet: buildViewOptionsRow(context)
        );
      }
    );
  }

  Widget buildGoodsView(BuildContext context, bool compactMode) {
    final vm = context.read<GoodsViewModel>();
    Map<String, List<GoodsDetail>> groupedGoods = vm.state.groupByManufacturer ?
      vm.state.visibleGoodsDetails.groupListsBy((g) => g.goods.manufacturer ?? 'Не указан') :
      vm.state.visibleGoodsDetails.groupListsBy((g) => g.goods.name.split(' ').first);
    final keyStr = Object.hashAll([
      vm.state.selectedCategory,
      vm.state.selectedGoodsFilter,
      vm.state.selectedBonusProgram,
      vm.state.showOnlyOrder,
      vm.state.showOnlyActive,
      vm.state.showOnlyLatest,
      vm.state.goodsNameSearch
    ]).toString();

    return _GoodsGroupsView(
      key: Key(keyStr),
      groupedGoods: groupedGoods,
      showOnlyActive: vm.state.showOnlyActive,
      initiallyExpanded: vm.state.goodsListInitiallyExpanded,
      showWithPrice: vm.state.showWithPrice,
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
          !compactMode ?
            Container() :
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Категория',
                suffixIcon: IconButton(
                  onPressed: showCategorySelectDialog,
                  icon: const Icon(Icons.arrow_drop_down),
                  tooltip: 'Выбрать категорию',
                )
              ),
              controller: TextEditingController(text: vm.state.selectedCategory?.category.name),
              style: Styles.formStyle
            ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
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
                )
              ),
              const SizedBox(width: 4),
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
          buildGoodsFiltersRow(context),
        ],
      )
    );
  }

  Widget buildGoodsFiltersRow(BuildContext context) {
    final vm = context.read<GoodsViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...vm.state.goodsFilters.map((e) => ChoiceChip(
          label: Text(e.name),
          labelStyle: Styles.formStyle,
          selected: e == vm.state.selectedGoodsFilter,
          onSelected: (bool selected) => vm.selectGoodsFilter(selected ? e : null)
        )).toList(),
        ChoiceChip(
          label: const Text('Н'),
          labelStyle: Styles.formStyle,
          selected: vm.state.showOnlyLatest,
          onSelected: (bool selected) => vm.toggleShowOnlyLatest()
        )
      ]
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
          Flexible(
            child: Text(
              'Сумма: ${Format.numberStr(vm.state.total)}',
              style: Styles.formStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis
            )
          )
        ]
      )
    );
  }

  Widget buildCategoryView(BuildContext context, void Function(CategoriesExResult) onCategoryTap) {
    final vm = context.read<GoodsViewModel>();
    final Map<String, List<CategoriesExResult>> groupedCategories = {};
    final keyStr = Object.hashAll([
      vm.state.selectedGoodsFilter,
      vm.state.selectedBonusProgram,
      vm.state.showOnlyOrder,
      vm.state.showOnlyActive,
      vm.state.showOnlyLatest,
      vm.state.goodsNameSearch
    ]).toString();

    for (var e in vm.state.shopDepartments) {
      groupedCategories[e.name] = vm.state.visibleCategories.where((c) => c.category.shopDepartmentId == e.id).toList();
    }

    return _CategoriesView(
      key: Key(keyStr),
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
  final Map<String, ExpandableSliverListController<CategoriesExResult>> groupedCategoriesExpansion = {};
  final Map<String, bool> groupedCategoriesActive = {};
  late final AutoScrollController categoriesController = AutoScrollController(
    keepScrollOffset: false,
    axis: Axis.vertical,
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
  );

  void _expand(AutoScrollController controller, int index, String name, bool forceExpand) {
    final collapsed = (groupedCategoriesExpansion[name]?.isCollapsed() ?? false) || forceExpand;

    for (var e in groupedCategoriesExpansion.keys) {
      groupedCategoriesExpansion[e]?.collapse();
    }
    if (collapsed) groupedCategoriesExpansion[name]?.expand();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.groupedCategories.entries.where((e) => e.value.isNotEmpty).toList();

    items.forEachIndexed((index, e) {
      groupedCategoriesExpansion.putIfAbsent(
        e.key,
        () => ExpandableSliverListController(
          initialStatus: widget.initiallyExpanded ?
            ExpandableSliverListStatus.expanded :
            ExpandableSliverListStatus.collapsed
        )
      );
      groupedCategoriesActive.putIfAbsent(e.key, () => widget.showOnlyActive);
    });

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomScrollView(
          controller: categoriesController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buildCategorySelectGroup(context, index, items[index].key, items[index].value);
                },
                childCount: items.length
              ),
            ),
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
    final keyStr = Object.hashAll([
      ...groupCategories.map((e) => e.category.id),
      name
    ]).toString();

    return AutoScrollTag(
      controller: categoriesController,
      index: index,
      key: Key(keyStr),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ListTile(
                onTap: () => _expand(categoriesController, index, name, false),
                title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                tileColor: Theme.of(context).colorScheme.primary,
                trailing: !widget.showOnlyActive ?
                  Container(width: 0) :
                  IconButton(
                    color: Colors.white,
                    icon: Icon(showOnlyActive ? Icons.access_time_filled : Icons.access_time),
                    tooltip: 'Показать актив',
                    onPressed: () => setState(() {
                      groupedCategoriesActive[name] = !showOnlyActive;

                      groupedCategoriesExpansion[name]?.expand();
                    })
                  )
              )
            ),
            ExpandableSliverList<CategoriesExResult>(
              initialItems: groupCategories,
              controller: groupedCategoriesExpansion[name]!,
              duration: const Duration(microseconds: 300),
              builder: (context, item, _) {
                final build = widget.showOnlyActive ? item.lastShipmentDate != null || !showOnlyActive : true;

                return build ? buildCategoryTile(item) : Container();
              }
            )
          ]
        )
      )
    );
  }

  Widget buildCategoryTile(CategoriesExResult categoryEx) {
    return ListTile(
      title: buildCategoryTileTitle(categoryEx),
      tileColor: Colors.transparent,
      selected: categoryEx == widget.selectedCategory,
      onTap: () => widget.onCategoryTap.call(categoryEx)
    );
  }

  Widget buildCategoryTileTitle(CategoriesExResult categoryEx) {
    final daysDiff = categoryEx.lastShipmentDate != null ?
      DateTime.now().difference(categoryEx.lastShipmentDate!) :
      null;

    return Row(
      children: [
        Expanded(
          child: Text(categoryEx.category.name, style: Styles.tileTitleText.copyWith(fontWeight: FontWeight.w500))
        ),
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
  final bool showWithPrice;
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
    required this.showWithPrice,
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
  final Map<String, ExpandableSliverListController<GoodsDetail>> groupedGoodsExpansion = {};
  final Map<String, bool> groupedGoodsActive = {};
  late final AutoScrollController goodsController = AutoScrollController(
    keepScrollOffset: false,
    axis: Axis.vertical,
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
  );

  void _expand(AutoScrollController controller, int index, String name, bool forceExpand) {
    final collapsed = (groupedGoodsExpansion[name]?.isCollapsed() ?? false) || forceExpand;

    for (var e in groupedGoodsExpansion.keys) {
      groupedGoodsExpansion[e]?.collapse();
    }
    if (collapsed) groupedGoodsExpansion[name]?.expand();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    });
  }

  Widget buildGoodsViewGroup(BuildContext context, int index, String name, List<GoodsDetail> groupGoods) {
    final showOnlyActive = groupedGoodsActive[name]!;
    final keyStr = Object.hashAll([
      ...groupGoods.map((e) => e.goods.id),
      name
    ]).toString();

    return AutoScrollTag(
      controller: goodsController,
      index: index,
      key: Key(keyStr),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ListTile(
                onTap: () => _expand(goodsController, index, name, false),
                title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                tileColor: Theme.of(context).colorScheme.primary,
                trailing: !widget.showOnlyActive ?
                  Container(width: 0) :
                  IconButton(
                    color: Colors.white,
                    icon: Icon(showOnlyActive ? Icons.access_time_filled : Icons.access_time),
                    tooltip: 'Показать актив',
                    onPressed: () => setState(() {
                      groupedGoodsActive[name] = !showOnlyActive;
                      groupedGoodsExpansion[name]?.expand();
                    })
                  )
              )
            ),
            ExpandableSliverList<GoodsDetail>(
              initialItems: groupGoods,
              controller: groupedGoodsExpansion[name]!,
              duration: const Duration(microseconds: 300),
              builder: (context, item, _) {
                final build = widget.showOnlyActive ? item.hadShipment || !showOnlyActive : true;

                return build ? buildGoodsTile(context, item) : Container();
              }
            )
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.groupedGoods.entries.where((e) => e.value.isNotEmpty).sorted((a, b) => a.key.compareTo(b.key));

    items.forEachIndexed((index, e) {
      groupedGoodsExpansion.putIfAbsent(
        e.key,
        () => ExpandableSliverListController(
          initialStatus: widget.initiallyExpanded ?
            ExpandableSliverListStatus.expanded :
            ExpandableSliverListStatus.collapsed
        )
      );
      groupedGoodsActive.putIfAbsent(e.key, () => widget.showOnlyActive);
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
              onPressed: () => _expand(goodsController, e.$1, e.$2.key, true)
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
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return buildGoodsViewGroup(context, index, items[index].key, items[index].value);
                          },
                          childCount: items.length
                        ),
                      ),
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

    return Text.rich(
      TextSpan(
        style: Styles.tileTitleText,
        children: <InlineSpan>[
          TextSpan(
            text: goodsEx.goods.name,
            style: Styles.tileTitleText.copyWith(
              color: goodsDetail.stock?.isVollow ?? false ? Colors.pink : Colors.black,
            )
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
          !goodsEx.goods.isLatest ?
            const TextSpan() :
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Chip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  labelPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  label: const Text('Новинка', style: Styles.chipStyle),
                  backgroundColor: Colors.yellow[700],
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
    final orderLineEx = widget.linesExList.firstWhereOrNull((e) => e.line.goodsId == goodsDetail.goods.id);
    final enabled = goodsDetail.price != 0 &&
      !goodsDetail.goodsEx.restricted &&
      widget.orderEx.order.isEditable;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          tileColor: Colors.transparent,
          trailing: buildGoodsTileTrailing(context, goodsDetail, orderLineEx, enabled),
          title: buildGoodsTileTitle(context, goodsDetail),
          onTap: !enabled ? null : () => widget.onTap(goodsDetail)
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _GoodsSubtitle(goodsDetail, orderLineEx)
        ),
        buildGoodsImage(context, goodsDetail),
        Divider(height: 4, color: Theme.of(context).textTheme.displaySmall?.color)
      ]
    );
  }

  Widget buildGoodsTileTrailing(
    BuildContext context,
    GoodsDetail goodsDetail,
    OrderLineExResult? orderLineEx,
    bool enabled
  ) {
    return SizedBox(
      width: 140,
      child: VolField(
        enabled: enabled,
        minValue: 0,
        vol: orderLineEx?.line.vol,
        step: goodsDetail.stockRel,
        style: Styles.formStyle.copyWith(fontWeight: FontWeight.bold),
        onVolChange: (vol) => widget.onVolChange(goodsDetail, vol)
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

  @override
  Widget build(BuildContext context) {
    final goodsEx = widget.goodsDetail.goodsEx;
    final goods = goodsEx.goods;
    final stock = widget.goodsDetail.stock;
    final stockVol = stock?.vol ?? 0;
    final price = widget.goodsDetail.pricelistPrice;
    final minPrice = goods.minPrice;
    final bonusPrice = widget.goodsDetail.price;
    final effPrice = (bonusPrice - (widget.orderLineEx?.line.priceOriginal ?? price)).abs();
    final linePrice = widget.orderLineEx?.line.price ?? bonusPrice;
    final color = Theme.of(context).textTheme.displaySmall?.color;
    List<Widget> children = [];

    if (!expanded) {
      children.addAll([
        IconButton(
          splashRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          constraints: const BoxConstraints(maxHeight: 24),
          icon: Icon(Icons.expand_circle_down, color: color),
          onPressed: () => setState(() => expanded = true)
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: Styles.tileText.copyWith(fontWeight: FontWeight.w500, color: color),
              children: <InlineSpan>[
                const TextSpan(text: 'Цена: '),
                TextSpan(text: Format.numberStr(linePrice)),
                TextSpan(
                  text: effPrice > 0 ? '(${Format.numberStr(price)})' : null,
                  style: TextStyle(
                    color: widget.goodsDetail.conditionalDiscount ? Colors.red : Colors.blue,
                    decoration: TextDecoration.lineThrough
                  )
                ),
                const TextSpan(text: ' руб.'),
                TextSpan(text: widget.goodsDetail.rel == 1 ? ' ' : ' Вложение: ${widget.goodsDetail.rel} '),
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
          splashRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          constraints: const BoxConstraints(maxHeight: 24),
          icon: Transform.rotate(angle: pi, child: Icon(Icons.expand_circle_down, color: color)),
          onPressed: () => setState(() => expanded = false)
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: Styles.tileText.copyWith(fontWeight: FontWeight.w500, color: color),
              children: <InlineSpan>[
                const TextSpan(text: 'Цена: '),
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
                  text: minPrice != 0 && minPrice < bonusPrice ? ' Мин. цена: ${Format.numberStr(minPrice)}\n' : '\n'
                ),
                TextSpan(text: widget.goodsDetail.rel == 1 ? '' : 'Вложение: ${widget.goodsDetail.rel} '),
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
