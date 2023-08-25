import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/orders_repository.dart';
import '/app/utils/misc.dart';

part 'goods_preload_image_state.dart';
part 'goods_preload_image_view_model.dart';

class GoodsPreloadImagePage extends StatelessWidget {
  GoodsPreloadImagePage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoodsPreloadImageViewModel>(
      create: (context) => GoodsPreloadImageViewModel(
        RepositoryProvider.of<OrdersRepository>(context)
      ),
      child: _GoodsPreloadImageView(),
    );
  }
}

class _GoodsPreloadImageView extends StatefulWidget {
  @override
  _GoodsPreloadImageViewState createState() => _GoodsPreloadImageViewState();
}

class _GoodsPreloadImageViewState extends State<_GoodsPreloadImageView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoodsPreloadImageViewModel, GoodsPreloadImageState>(
      builder: (context, state) {
        final vm = context.read<GoodsPreloadImageViewModel>();

        return Material(
          type: MaterialType.transparency,
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Фотографии товаров',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center
              ),
              Container(height: 20),
              Text(
                'Загружено ${vm.state.loadedGoodsImages} из ${vm.state.goodsWithImage.length}',
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
          case GoodsPreloadImageStateStatus.failure:
          case GoodsPreloadImageStateStatus.success:
          case GoodsPreloadImageStateStatus.canceled:
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
