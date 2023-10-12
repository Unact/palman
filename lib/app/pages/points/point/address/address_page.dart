import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:u_app_utils/u_app_utils.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/pages/shared/page_view_model.dart';

part 'address_state.dart';
part 'address_view_model.dart';

class AddressPage extends StatelessWidget {
  final String? address;
  final double? latitude;
  final double? longitude;

  AddressPage({
    required this.address,
    required this.latitude,
    required this.longitude,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressViewModel>(
      create: (context) => AddressViewModel(address: address, longitude: longitude, latitude: latitude),
      child: ScaffoldMessenger(child: _AddressView()),
    );
  }
}

class _AddressView extends StatefulWidget {
  @override
  AddressViewState createState() => AddressViewState();
}

class AddressViewState extends State<_AddressView> {
  YandexMapController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressViewModel, AddressState>(
      builder: (context, state) {
        final vm = context.read<AddressViewModel>();
        final size = MediaQuery.of(context).size;
        List<MapObject> mapObjects = [];

        if (state.latitude != null && state.longitude != null) {
          mapObjects.add(PlacemarkMapObject(
            mapId: const MapObjectId('point'),
            point: Point(latitude: state.latitude!, longitude: state.longitude!),
            consumeTapEvents: true,
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/placeicon.png'),
            ))
          ));
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            title: const Text('Редактирование адреса'),
            content: SingleChildScrollView(child: ListBody(children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Укажите адрес'),
                initialValue: vm.state.address,
                style: Styles.formStyle,
                onChanged: vm.changeAddress
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width / 1.5,
                height: size.height / 1.75,
                child: Stack(
                  children: [
                    YandexMap(
                      gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
                      logoAlignment: const MapAlignment(
                        horizontal: HorizontalAlignment.left,
                        vertical: VerticalAlignment.bottom
                      ),
                      onMapLongTap: (Point mapPoint) => vm.changeCoords(mapPoint.latitude, mapPoint.longitude),
                      onMapCreated: (controller) {
                        this.controller = controller;
                        moveCamera();
                      },
                      mapObjects: mapObjects
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: vm.changeCoordsToMyPosition,
                        child: const Icon(Icons.my_location_sharp),
                      )
                    )
                  ],
                )
              )
            ])),
            actions: <Widget>[
              TextButton(
                child: const Text(Strings.cancel),
                onPressed: () => Navigator.of(context).pop()
              ),
              TextButton(
                child: const Text(Strings.ok),
                onPressed: () => Navigator.of(context).pop((vm.state.address, vm.state.latitude, vm.state.longitude))
              )
            ]
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case AddressStateStatus.permissionNotGranted:
            Misc.showMessage(context, Strings.locationPermissionError);
            break;
          case AddressStateStatus.coordsChanged:
            await moveCamera();
          default:
            break;
        }
      }
    );
  }

  Future<void> moveCamera() async {
    final vm = context.read<AddressViewModel>();

    if (controller == null || vm.state.latitude == null || vm.state.longitude == null) return;

    final visibleRegion = await controller!.getVisibleRegion();

    if (!(
      visibleRegion.bottomLeft.latitude <= vm.state.latitude! &&
      visibleRegion.topRight.latitude >= vm.state.latitude! &&
      visibleRegion.bottomLeft.longitude <= vm.state.longitude! &&
      visibleRegion.topRight.longitude >= vm.state.longitude!
    )) {
      controller?.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: Point(latitude: vm.state.latitude!, longitude: vm.state.longitude!)))
      );
    }
  }
}
