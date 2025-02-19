import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as l;
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/visits_repository.dart';
import '/app/widgets/widgets.dart';

part 'visit_state.dart';
part 'visit_view_model.dart';

class VisitPage extends StatelessWidget {
  final VisitEx visitEx;

  VisitPage({
    required this.visitEx,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VisitViewModel>(
      create: (context) => VisitViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<VisitsRepository>(context),
        visitEx: visitEx
      ),
      child: _VisitView(),
    );
  }
}

class _VisitView extends StatefulWidget {
  @override
  _VisitViewState createState() => _VisitViewState();
}

class _VisitViewState extends State<_VisitView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    progressDialog.close();
    super.dispose();
  }

  Future<void> showCameraView() async {
    final vm = context.read<VisitViewModel>();

    await Navigator.push<String>(
      context,
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (BuildContext context) => CameraView(
          compress: true,
          onError: (String message) => WidgetsBinding.instance.addPostFrameCallback(
            (_) => Misc.showMessage(this.context, message)
          ),
          onTakePicture: (XFile file) => vm.state.takeSoftwarePhoto ? vm.addVisitSoftware(file) : vm.addVisitImage(file)
        )
      )
    );
  }

  Future<void> showVisitPurposeDialog(VisitPurpose purpose, bool completed) async {
    final vm = context.read<VisitViewModel>();
    final result = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? info;

        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleAlertDialog(
              title: const Text('Указать комментарий?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    onChanged: (newInfo) => setState(() => info = newInfo)
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: info != null && info!.isNotEmpty ? () => Navigator.of(context).pop(info) : null,
                  child: const Text('Да')
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text('Нет')
                )
              ]
            );
          }
        );
      }
    );

    await vm.completeVisitPurpose(purpose, completed, result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VisitViewModel, VisitState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Детали посещения')),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              children: buildVisitDetails(context)
            )
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case VisitStateStatus.inProgress:
            progressDialog.open();
            break;
          case VisitStateStatus.success:
            progressDialog.close();
            break;
          case VisitStateStatus.failure:
            progressDialog.close();
            Misc.showMessage(context, state.message);
            break;
          case VisitStateStatus.cameraError:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Misc.showMessage(context, state.message);
            });
            break;
          case VisitStateStatus.cameraOpened:
            await showCameraView();
            break;
          default:
        }
      },
    );
  }

  List<Widget> buildVisitDetails(BuildContext context) {
    final vm = context.read<VisitViewModel>();
    final visit = vm.state.visitEx.visit;

    return [
      visit.needCompletePurpose ? buildPurposeList(context) : Container(),
      visit.needCheckGL ? buildGoodsList(context) : Container(),
      visit.needTakePhotos ? buildImageList(context) : Container(),
      visit.needFillSoftware ? buildSoftwareList(context) : Container()
    ];
  }

  Widget buildGoodsList(BuildContext context) {
    final vm = context.read<VisitViewModel>();
    return Column(
      children: [
        const ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          title: Text('Списки', style: Styles.formStyle),
        ),
        ListView(
          shrinkWrap: true,
          children: vm.state.goodsListVisitExList.map((e) => buildGoodsListTile(context, e)).toList()
        )
      ]
    );
  }

  Widget buildGoodsListTile(BuildContext context, GoodsListVisitExResult goodsListVisitEx) {
    final vm = context.read<VisitViewModel>();

    if (goodsListVisitEx.hasVisitGoodsList) {
      return ExpansionTile(
        title: Text(goodsListVisitEx.goodsList.name, style: Styles.tileText),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: const Icon(Icons.check, color: Colors.green),
        trailing: const SizedBox(),
        children: goodsListVisitEx.visitGoods.map((i) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          title: Text(i.name, style: Styles.tileText)
        )).toList()
      );
    }

    return ExpansionTile(
      title: Text(goodsListVisitEx.goodsList.name, style: Styles.tileText),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: const Icon(Icons.hourglass_empty, color: Colors.yellow),
      trailing: IconButton(
        onPressed: () => vm.finishVisitList(goodsListVisitEx.goodsList),
        icon: const Icon(Icons.check_box)
      ),
      children: goodsListVisitEx.goods.map((i) {
        final added = (vm.state.listGoods[goodsListVisitEx.goodsList] ?? []).contains(i.id);

        return ListTile(
          contentPadding: const EdgeInsets.only(left: 24, right: 16),
          title: Text(i.name, style: Styles.tileText),
          trailing: added ? IconButton(
            onPressed: () => vm.deleteGoodsFromList(goodsListVisitEx.goodsList, i.id),
            icon: const Icon(Icons.check_box)
          ) : IconButton(
            onPressed: () => vm.addGoodsToList(goodsListVisitEx.goodsList, i.id),
            icon: const Icon(Icons.check_box_outline_blank)
          )
        );
      }).toList()
    );
  }

  Widget buildImageList(BuildContext context) {
    final vm = context.read<VisitViewModel>();

    return Column(
      children: [
        const ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Text('Фотографии', style: Styles.formStyle),
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          mainAxisSpacing: 16,
          children: buildImages(context)
            ..add(GestureDetector(child: IconButton(
              onPressed: () => vm.tryTakePicture(false),
              icon: const Icon(Icons.add_a_photo),
              tooltip: 'Сделать фотографию',
            ))
          )
        )
      ],
    );
  }

  List<Widget> buildImages(BuildContext context) {
    final vm = context.read<VisitViewModel>();
    final images = vm.state.images.map((image) => RetryableImage(
      color: Theme.of(context).colorScheme.primary,
      cached: image.needSync || vm.state.showLocalImage,
      imageUrl: image.imageUrl,
      cacheKey: image.imageKey,
      cacheManager: VisitsRepository.visitImagesCacheManager,
    )).toList();

    return images.mapIndexed((idx, imageWidget) {
      return GestureDetector(
        onTap: () {
          Navigator.push<String>(
            context,
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (BuildContext context) => ImageGallery(
                curIdx: idx,
                images: images,
                onDelete: (idx) async => await vm.deleteVisitImage(vm.state.images[idx])
              )
            )
          );
        },
        child: imageWidget
      );
    }).toList();
  }

  List<Widget> buildSoftwares(BuildContext context) {
    final vm = context.read<VisitViewModel>();
    final images = vm.state.softwares.map((software) => RetryableImage(
      color: Theme.of(context).colorScheme.primary,
      cached: software.needSync || vm.state.showLocalImage,
      imageUrl: software.imageUrl,
      cacheKey: software.imageKey,
      cacheManager: VisitsRepository.visitSoftwaresCacheManager,
    )).toList();

    return images.mapIndexed((idx, imageWidget) {
      return GestureDetector(
        onTap: () {
          Navigator.push<String>(
            context,
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (BuildContext context) => ImageGallery(
                curIdx: idx,
                images: images,
                onDelete: (idx) async => await vm.deleteVisitSoftware(vm.state.softwares[idx])
              )
            )
          );
        },
        child: imageWidget
      );
    }).toList();
  }

  Widget buildSoftwareList(BuildContext context) {
    final vm = context.read<VisitViewModel>();

    return Column(
      children: [
        const ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Text('1C', style: Styles.formStyle),
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          mainAxisSpacing: 16,
          children: buildSoftwares(context)
            ..add(GestureDetector(
              child: vm.state.softwares.isNotEmpty ?
                Container() :
                IconButton(
                  onPressed: () => vm.tryTakePicture(true),
                  icon: const Icon(Icons.add_a_photo),
                  tooltip: 'Сделать фотографию',
                )
            ))
        )
      ],
    );
  }

  Widget buildPurposeList(BuildContext context) {
    final vm = context.read<VisitViewModel>();

    return Column(
      children: [
        const ListTile(
          contentPadding: EdgeInsets.all(8),
          title: Text('Цели', style: Styles.formStyle),
        ),
        ...vm.state.purposes.map((e) => buildPurpose(context, e))

      ],
    );
  }

  Widget buildPurpose(BuildContext context, VisitPurpose purpose) {
    if (purpose.completed != null) {
      return ListTile(
        title: Text(purpose.description),
        subtitle: Text(
          '${purpose.completed! ? 'Выполнен' : 'Не выполнен'}${purpose.info != null ? ' - ${purpose.info}' : ''}'
        )
      );
    }

    return ListTile(
      title: Text(purpose.description),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.indeterminate_check_box),
            onPressed: () => showVisitPurposeDialog(purpose, false),
            tooltip: 'Отметить не выполнение',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 16)
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () => showVisitPurposeDialog(purpose, true),
            tooltip: 'Отметить выполнение',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 16)
          )
        ]
      )
    );
  }
}
