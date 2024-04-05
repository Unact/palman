import 'dart:async';


import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/data/database.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/points_repository.dart';

part 'point_images_state.dart';
part 'point_images_view_model.dart';

class PointImagesPage extends StatelessWidget {
  final int curIdx;
  final PointEx pointEx;

  PointImagesPage({
    required this.curIdx,
    required this.pointEx,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PointImagesViewModel>(
      create: (context) => PointImagesViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<PointsRepository>(context),
        pointEx: pointEx
      ),
      child: _PointImagesView(curIdx: curIdx),
    );
  }
}

class _PointImagesView extends StatefulWidget {
  final int curIdx;

  _PointImagesView({
    required this.curIdx,
    Key? key
  }) : super(key: key);

  @override
  _PointImagesViewState createState() => _PointImagesViewState();
}

class _PointImagesViewState extends State<_PointImagesView> {
  late int _curIdx = widget.curIdx;
  late final _pageController = PageController(initialPage: _curIdx);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointImagesViewModel, PointImagesState>(
      builder: (context, state) {
        final vm = context.read<PointImagesViewModel>();
        final images = state.images.map((image) => RetryableImage(
          color: Theme.of(context).colorScheme.primary,
          cached: image.needSync || vm.state.showLocalImage,
          imageUrl: image.imageUrl,
          cacheKey: image.imageKey,
          cacheManager: PointsRepository.pointImagesCacheManager,
        )).toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(images.isEmpty ? '' : '${_curIdx + 1} из ${images.length}'),
            actions: [
              IconButton(
                onPressed: () async {
                  await vm.deletePointImage(state.images[_curIdx]);
                  setState(() { _curIdx = _curIdx > 0 ? _curIdx - 1 : 0; });
                },
                icon: const Icon(Icons.delete),
                tooltip: 'Удалить фотографию',
              )
            ]
          ),
          extendBodyBehindAppBar: true,
          body: GestureDetector(
            onVerticalDragEnd: (details) => Navigator.pop(context),
            child: Container(
              color: Colors.black,
              child: PhotoViewGallery.builder(
                pageController: _pageController,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions.customChild(
                    initialScale: 0.8,
                    child: images[_curIdx]
                  );
                },
                onPageChanged: (idx) => setState(() { _curIdx = idx; }),
                itemCount: images.length,
              ),
            ),
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case PointImagesStateStatus.pointImageDeleted:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.images.isEmpty) Navigator.pop(context);
            });
            break;
          default:
        }
      },
    );
  }
}
