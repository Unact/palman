import 'dart:async';

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
import '/app/repositories/return_acts_repository.dart';
import '/app/widgets/widgets.dart';

part 'goods_state.dart';
part 'goods_view_model.dart';

class GoodsPage extends StatelessWidget {
  final ReturnActExResult returnActEx;

  GoodsPage({
    required this.returnActEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoodsViewModel>(
      create: (context) => GoodsViewModel(
        returnActEx: returnActEx,
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<OrdersRepository>(context),
        RepositoryProvider.of<ReturnActsRepository>(context)
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

  Future<void> showScanPage() async {
    final vm = context.read<GoodsViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanView(
        onRead: vm.changeBarcode,
        showScanner: false,
        barcodeMode: true,
        child: Text('Отсканируйте штрих-код', style: Styles.formStyle.copyWith(fontSize: 18, color: Colors.white)),
      ))
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
                icon: const Icon(Icons.camera_alt),
                tooltip: 'Отсканировать ШК',
                onPressed: vm.tryShowScan
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.checklist),
                tooltip: 'Показать акт',
                onPressed: vm.toggleShowOnlyReturnAct,
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
      },
      listener: (context, state) async {
        switch (state.status) {
          case GoodsStateStatus.scanSuccess:
            Navigator.of(context).pop();
            break;
          case GoodsStateStatus.scanFailure:
          case GoodsStateStatus.showScanFailure:
            Misc.showMessage(context, state.message);
            break;
          case GoodsStateStatus.showScan:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showScanPage();
            });
            break;
          default:
        }
      }
    );
  }

  Widget buildGoodsView(BuildContext context, bool compactMode) {
    final vm = context.read<GoodsViewModel>();
    Map<String, List<GoodsReturnDetail>> groupedGoods = vm.state.groupByManufacturer ?
      vm.state.visibleGoodsDetails.groupListsBy((g) => g.goods.manufacturer ?? 'Не указан') :
      vm.state.visibleGoodsDetails.groupListsBy((g) => g.goods.name.split(' ').first);
    final keyStr = Object.hashAll([
      vm.state.selectedCategory,
      vm.state.selectedGoodsFilter,
      vm.state.showOnlyLatest,
      vm.state.goodsNameSearch
    ]).toString();

    return _GoodsGroupsView(
      key: Key(keyStr),
      groupedGoods: groupedGoods,
      initiallyExpanded: vm.state.goodsListInitiallyExpanded,
      compactMode: compactMode,
      showWithPrice: vm.state.showWithPrice,
      showGroupInfo: vm.state.showGroupInfo,
      showGoodsImage: vm.state.showGoodsImage,
      returnActEx: vm.state.returnActEx,
      linesExList: vm.state.linesExList,
      onIsBadChange: (goodsReturnDetail, isBad) => vm.updateReturnActLine(
        goodsReturnDetail,
        isBad: Optional.fromNullable(isBad)
      ),
      onProductionDateChange: (goodsReturnDetail, productionDate) => vm.updateReturnActLine(
        goodsReturnDetail,
        productionDate: Optional.fromNullable(productionDate)
      ),
      onVolChange: (goodsReturnDetail, vol) => vm.updateReturnActLine(
        goodsReturnDetail,
        vol: Optional.fromNullable(vol)
      )
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
          )
        ]
      )
    );
  }

  Widget buildCategoryView(BuildContext context, void Function(CategoriesExResult) onCategoryTap) {
    final vm = context.read<GoodsViewModel>();
    final Map<String, List<CategoriesExResult>> groupedCategories = {};

    for (var e in vm.state.shopDepartments) {
      groupedCategories[e.name] = vm.state.visibleCategories.where((c) => c.category.shopDepartmentId == e.id).toList();
    }

    return _CategoriesView(
      key: Key(vm.state.visibleCategories.hashCode.toString()),
      selectedCategory: vm.state.selectedCategory,
      groupedCategories: groupedCategories,
      initiallyExpanded: vm.state.categoriesListInitiallyExpanded,
      onCategoryTap: onCategoryTap
    );
  }
}

class _CategoriesView extends StatefulWidget {
  final Map<String, List<CategoriesExResult>> groupedCategories;
  final CategoriesExResult? selectedCategory;
  final void Function(CategoriesExResult) onCategoryTap;
  final bool initiallyExpanded;

  _CategoriesView({
    required this.selectedCategory,
    required this.groupedCategories,
    required this.onCategoryTap,
    required this.initiallyExpanded,
    Key? key
  }) : super(key: key);

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<_CategoriesView> {
  final Map<String, ExpandableSliverListController<CategoriesExResult>> groupedCategoriesExpansion = {};
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
              )
            ),
            ExpandableSliverList<CategoriesExResult>(
              initialItems: groupCategories,
              controller: groupedCategoriesExpansion[name]!,
              duration: const Duration(microseconds: 300),
              builder: (context, item, _) => buildCategoryTile(item)
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
    return Row(
      children: [
        Expanded(
          child: Text(categoryEx.category.name, style: Styles.tileTitleText.copyWith(fontWeight: FontWeight.w500))
        )
      ]
    );
  }
}

class _GoodsGroupsView extends StatefulWidget {
  final Map<String, List<GoodsReturnDetail>> groupedGoods;
  final bool initiallyExpanded;
  final bool showWithPrice;
  final bool showGroupInfo;
  final bool showGoodsImage;
  final bool compactMode;
  final void Function(GoodsReturnDetail, bool) onIsBadChange;
  final void Function(GoodsReturnDetail, DateTime?) onProductionDateChange;
  final void Function(GoodsReturnDetail, double?) onVolChange;
  final ReturnActExResult returnActEx;
  final List<ReturnActLineExResult> linesExList;

  _GoodsGroupsView({
    required this.groupedGoods,
    required this.showWithPrice,
    required this.initiallyExpanded,
    required this.showGroupInfo,
    required this.showGoodsImage,
    required this.compactMode,
    required this.returnActEx,
    required this.linesExList,
    required this.onIsBadChange,
    required this.onProductionDateChange,
    required this.onVolChange,
    Key? key
  }) : super(key: key);

  @override
  _GoodsGroupsViewState createState() => _GoodsGroupsViewState();
}

class _GoodsGroupsViewState extends State<_GoodsGroupsView> {
  final endOfTime = DateTime(9999, 1, 1);
  final startOfTime = DateTime(2015, 8, 1);
  final Map<String, ExpandableSliverListController<GoodsReturnDetail>> groupedGoodsExpansion = {};
  late final AutoScrollController goodsController = AutoScrollController(
    keepScrollOffset: false,
    axis: Axis.vertical,
    viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
  );
  final Map<GoodsReturnDetail, TextEditingController> dateControllers = {};

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

  Widget buildGoodsViewGroup(BuildContext context, int index, String name, List<GoodsReturnDetail> groupGoods) {
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
                tileColor: Theme.of(context).colorScheme.primary
              )
            ),
            ExpandableSliverList<GoodsReturnDetail>(
              initialItems: groupGoods,
              controller: groupedGoodsExpansion[name]!,
              duration: const Duration(microseconds: 300),
              builder: (context, item, _) => buildGoodsTile(context, item)
            )
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final items = widget.groupedGoods.entries.sorted((a, b) => a.key.compareTo(b.key));

    items.where((e) => e.value.isNotEmpty).forEachIndexed((index, e) {
      groupedGoodsExpansion.putIfAbsent(
        e.key,
        () => ExpandableSliverListController(
          initialStatus: widget.initiallyExpanded ?
            ExpandableSliverListStatus.expanded :
            ExpandableSliverListStatus.collapsed
        )
      );
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

  Widget buildGoodsTileTitle(BuildContext context, GoodsReturnDetail goodsReturnDetail) {
    final goodsEx = goodsReturnDetail.goodsEx;

    return Text.rich(
      TextSpan(
        style: Styles.tileTitleText,
        children: <InlineSpan>[
          TextSpan(text: goodsEx.goods.name),
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
        ]
      )
    );
  }

  Widget buildGoodsImage(BuildContext context, GoodsReturnDetail goodsReturnDetail) {
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
                  imageUrl: goodsReturnDetail.goodsEx.goods.imageUrl,
                  cacheKey: goodsReturnDetail.goodsEx.goods.imageKey,
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
        imageUrl: goodsReturnDetail.goodsEx.goods.imageUrl,
        cacheKey: goodsReturnDetail.goodsEx.goods.imageKey,
        cacheManager: OrdersRepository.goodsCacheManager,
      )
    );
  }

  Widget buildGoodsTile(BuildContext context, GoodsReturnDetail goodsReturnDetail) {
    final returnActLineEx = widget.linesExList.firstWhereOrNull((e) => e.line.goodsId == goodsReturnDetail.goods.id);

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          tileColor: Colors.transparent,
          trailing: buildGoodsTileTrailing(context, goodsReturnDetail, returnActLineEx),
          title: buildGoodsTileTitle(context, goodsReturnDetail)
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: buildGoodsTileSubtitle(context, goodsReturnDetail)
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: buildGoodsTileDetails(context, goodsReturnDetail, returnActLineEx)
        ),
        buildGoodsImage(context, goodsReturnDetail),
        Divider(height: 4, color: Theme.of(context).textTheme.displaySmall?.color)
      ]
    );
  }

  Widget buildGoodsTileSubtitle(BuildContext context, GoodsReturnDetail goodsReturnDetail) {
    return Row(
      children: [
        Text(
        'Продано: ${goodsReturnDetail.returnStocks.fold(0, (prev, e) => prev + e.vol.toInt())}',
        )
      ]
    );
  }

  Widget buildGoodsTileDetails(
    BuildContext context,
    GoodsReturnDetail goodsReturnDetail,
    ReturnActLineExResult? returnActLineEx
  ) {
    final controller = dateControllers.putIfAbsent(
      goodsReturnDetail,
      () => TextEditingController(text: Format.dateStr(returnActLineEx?.line.productionDate))
    );
    final productionDateStr = Format.dateStr(returnActLineEx?.line.productionDate);

    if (controller.text != productionDateStr) controller.text = productionDateStr;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: DropdownButtonFormField(
            isExpanded: true,
            style: Theme.of(context).textTheme.titleMedium!.merge(Styles.formStyle).copyWith(
              fontWeight: FontWeight.bold
            ),
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              labelText: 'Состояние'
            ),
            items: <bool>[false, true].map((bool value) {
              return DropdownMenuItem<bool>(
                value: value,
                child: Text(value ? 'Некондиция' : 'Кондиция'),
              );
            }).toList(),
            value: returnActLineEx?.line.isBad,
            onChanged: (bool? value) => widget.onIsBadChange(goodsReturnDetail, value!)
          )
        ),
        Expanded(
          child: TextFormField(
            readOnly: true,
            style: Styles.formStyle.copyWith(fontWeight: FontWeight.bold),
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              labelText: 'Дата производства',
              suffixIcon: IconButton(
                onPressed: () => showDateDialog(goodsReturnDetail, returnActLineEx),
                tooltip: 'Указать дату',
                icon: const Icon(Icons.calendar_month)
              )
            )
          )
        )
      ]
    );
  }

  Future<void> showDateDialog(GoodsReturnDetail goodsReturnDetail, ReturnActLineExResult? returnActLineEx) async {
    DateTime? result = await showDatePicker(
      context: context,
      firstDate: startOfTime,
      lastDate: endOfTime,
      initialDate: returnActLineEx?.line.productionDate ?? DateTime.now()
    );

    widget.onProductionDateChange(goodsReturnDetail, result);
  }

  Widget buildGoodsTileTrailing(
    BuildContext context,
    GoodsReturnDetail goodsReturnDetail,
    ReturnActLineExResult? returnActLineEx
  ) {
    return SizedBox(
      width: 140,
      child: VolField(
        minValue: 0,
        vol: returnActLineEx?.line.vol,
        style: Styles.formStyle.copyWith(fontWeight: FontWeight.bold),
        onVolChange: (vol) => widget.onVolChange(goodsReturnDetail, vol)
      )
    );
  }
}
