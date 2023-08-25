import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/points_repository.dart';
import '/app/utils/misc.dart';

part 'point_preload_image_state.dart';
part 'point_preload_image_view_model.dart';

class PointPreloadImagePage extends StatelessWidget {
  PointPreloadImagePage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PointPreloadImageViewModel>(
      create: (context) => PointPreloadImageViewModel(
        RepositoryProvider.of<PointsRepository>(context)
      ),
      child: _PointPreloadImageView(),
    );
  }
}

class _PointPreloadImageView extends StatefulWidget {
  @override
  _PointPreloadImageViewState createState() => _PointPreloadImageViewState();
}

class _PointPreloadImageViewState extends State<_PointPreloadImageView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointPreloadImageViewModel, PointPreloadImageState>(
      builder: (context, state) {
        final vm = context.read<PointPreloadImageViewModel>();

        return Material(
          type: MaterialType.transparency,
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Фотографии точек',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center
              ),
              Container(height: 20),
              Text(
                'Загружено ${vm.state.loadedPointImages} из ${vm.state.pointImages.length}',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center
              ),
              Container(height: 40),
              const CircularProgressIndicator(),
              Container(height: 40),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    backgroundColor: Colors.red
                  ),
                  onPressed: vm.cancelPreload,
                  child: const Text('Отмена', style: TextStyle(color: Colors.white))
                )
              )
            ]
          )
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case PointPreloadImageStateStatus.failure:
          case PointPreloadImageStateStatus.success:
          case PointPreloadImageStateStatus.canceled:
          Misc.showMessage(context, state.message);
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      },
    );
  }
}
