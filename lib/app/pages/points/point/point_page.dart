import 'package:collection/collection.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/points_repository.dart';
import 'address/address_page.dart';

part 'point_state.dart';
part 'point_view_model.dart';

class PointPage extends StatelessWidget {
  final PointEx pointEx;

  PointPage({
    required this.pointEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PointViewModel>(
      create: (context) => PointViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<PointsRepository>(context),
        pointEx: pointEx
      ),
      child: _PointView(),
    );
  }
}

class _PointView extends StatefulWidget {
  @override
  _PointViewState createState() => _PointViewState();
}

class _PointViewState extends State<_PointView> {
  late final ProgressDialog progressDialog = ProgressDialog(context: context);
  TextEditingController? numberOfCdesksController;
  TextEditingController? maxDebtController;
  TextEditingController? nds10Controller;
  TextEditingController? nds20Controller;
  TextEditingController? plongController;

  Future<void> showAddressDialog() async {
    final vm = context.read<PointViewModel>();
    final point = vm.state.pointEx.point;

    final result = await showDialog<(String?, double, double)?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AddressPage(
        address: point.address,
        latitude: point.latitude,
        longitude: point.longitude
      )
    );

    if (result != null) await vm.updateAddress(result.$1, result.$2, result.$3);
  }

  Future<void> showCameraView() async {
    final vm = context.read<PointViewModel>();

    await Navigator.push<String>(
      context,
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (BuildContext context) => CameraView(
          compress: true,
          onError: (String message) => WidgetsBinding.instance.addPostFrameCallback(
            (_) => Misc.showMessage(this.context, message)
          ),
          onTakePicture: (XFile file) => vm.addPointImage(file)
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointViewModel, PointState>(
      builder: (context, state) {
        final vm = context.read<PointViewModel>();
        maxDebtController ??= TextEditingController(text: state.pointEx.point.maxdebt?.toString());
        nds10Controller ??= TextEditingController(text: state.pointEx.point.nds10?.toString());
        nds20Controller ??= TextEditingController(text: state.pointEx.point.nds20?.toString());
        plongController ??= TextEditingController(text: state.pointEx.point.plong?.toString());
        numberOfCdesksController ??= TextEditingController(text: state.pointEx.point.numberOfCdesks?.toString());

        return Scaffold(
          appBar: AppBar(
            title: const Text('Точка'),
            actions: [
              Center(
                child: Badge(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  label: const Text('1'),
                  isLabelVisible: state.needSync,
                  offset: const Offset(-4, 4),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.save),
                    splashRadius: 12,
                    tooltip: 'Сохранить изменения',
                    onPressed: state.needSync ? vm.save : null
                  )
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              children: buildPointFields(context)
            )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: vm.tryTakePicture,
            child: const Icon(Icons.camera),
          ),
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case PointStateStatus.cameraError:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Misc.showMessage(context, state.message);
            });
            break;
          case PointStateStatus.cameraOpened:
            await showCameraView();
            break;
          case PointStateStatus.saveInProgress:
            progressDialog.open();
            break;
          case PointStateStatus.saveFailure:
          case PointStateStatus.saveSuccess:
            Misc.showMessage(context, state.message);
            progressDialog.close();
            break;
          default:
        }
      },
    );
  }

  List<Widget> buildPointFields(BuildContext context) {
    final vm = context.read<PointViewModel>();
    final point = vm.state.pointEx.point;

    return [
      InfoRow(title: const Text('Юр. лица'), trailing: ExpandingText(point.buyerName)),
      InfoRow(
        title: const Text('Адрес'),
        trailing: Row(
          children: [
            Expanded(child: ExpandingText(point.address ?? '', style: Styles.formStyle)),
            IconButton(
              onPressed: showAddressDialog,
              icon: const Icon(Icons.map),
              tooltip: 'Указать на карте',
              constraints: const BoxConstraints()
            )
          ]
        )
      ),
      InfoRow(
        title: const Text('Формат'),
        trailing: DropdownButtonFormField(
          isExpanded: true,
          value: point.pointFormat,
          style: Styles.formStyle,
          alignment: AlignmentDirectional.center,
          items: vm.state.pointFormats.map((PointFormat v) {
            return DropdownMenuItem<int>(
              value: v.id,
              child: Text(v.name),
            );
          }).toList(),
          onChanged: (v) => vm.updatePointFormat(v!)
        )
      ),
      InfoRow(
        title: const Text('Кол-во касс'),
        trailing: NumTextField(
          decimal: false,
          textAlign: TextAlign.start,
          controller: numberOfCdesksController,
          onTap: () => vm.updateNumberOfCdesk(numberOfCdesksController!.text),
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('Вывеска'),
        trailing: TextFormField(
          initialValue: point.name,
          onFieldSubmitted: vm.updateName,
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('Email для чеков'),
        trailing: TextFormField(
          initialValue: point.emailOnlineCheck,
          onFieldSubmitted: vm.updateEmailOnlineCheck,
          style: Styles.formStyle
        ),
      ),
      InfoRow(
        title: const Text('Email'),
        trailing: TextFormField(
          initialValue: point.email,
          onFieldSubmitted: vm.updateEmail,
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('ИНН'),
        trailing: TextFormField(
          initialValue: point.inn,
          onFieldSubmitted: vm.updateInn,
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('Лимит'),
        trailing: NumTextField(
          decimal: false,
          textAlign: TextAlign.start,
          controller: maxDebtController,
          onTap: () => vm.updateMaxdebt(maxDebtController!.text),
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('НДС10'),
        trailing: NumTextField(
          decimal: false,
          textAlign: TextAlign.start,
          controller: nds10Controller,
          onTap: () => vm.updateNds10(nds10Controller!.text),
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('НДС20'),
        trailing: NumTextField(
          decimal: false,
          textAlign: TextAlign.start,
          controller: nds20Controller,
          onTap: () => vm.updateNds20(nds20Controller!.text),
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('Срок'),
        trailing: NumTextField(
          decimal: false,
          textAlign: TextAlign.start,
          controller: plongController,
          onTap: () => vm.updatePlong(plongController!.text),
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('Тел. для чеков'),
        trailing: TextFormField(
          initialValue: point.phoneOnlineCheck,
          onFieldSubmitted: vm.updatePhoneOnlineCheck,
          style: Styles.formStyle
        )
      ),
      InfoRow(
        title: const Text('ЮЛ'),
        trailing: TextFormField(
          initialValue: point.jur,
          onFieldSubmitted: vm.updateJur,
          style: Styles.formStyle
        )
      ),
      const ListTile(
        contentPadding: EdgeInsets.all(8),
        title: Text('Фотографии точки'),
        subtitle: Text('Необходим вид с улицы, а также общий план торгового зала с разных углов. Не менее 3 фото.')
      ),
      GridView.count(crossAxisCount: 4, shrinkWrap: true, mainAxisSpacing: 16, children: buildImages(context))
    ];
  }

  List<Widget> buildImages(BuildContext context) {
    final vm = context.read<PointViewModel>();
    final images = vm.state.pointEx.images.map((image) => RetryableImage(
      color: Theme.of(context).colorScheme.primary,
      cached: image.needSync || vm.state.showLocalImage,
      imageUrl: image.imageUrl,
      cacheKey: image.imageKey,
      cacheManager: PointsRepository.pointImagesCacheManager,
    )).toList();

    return images.mapIndexed((idx, imageWidget) {
      return GestureDetector(
        onTap: () {
          Navigator.push<String>(
            context,
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (BuildContext context) => ImagesView(images: images, idx: idx)
            )
          );
        },
        child: imageWidget
      );
    }).toList();
  }
}
